FakeUrlTag = Struct.new(:name, :text, :required)
DESCRIPTION_SUBS = { "\n" => " ",
                     "\"" => "\\\""}

def init
  Templates::Engine.with_serializer('routes_config_json.js', options[:serializer]) do
    erb(:whitelabel_api)
  end
end

# Renders json for all controllers
def controller_json
  controller_objects.inject([]) do |out, controller|
    out << controller_template(controller, 1)
  end.join(",\n")
end

# Returns all controller classes from the YARD Registry
def controller_objects
  root = Registry.root
  children = run_verifier(root.children)
  if root == Registry.root
    children += options[:objects].select {|o| o.namespace.is_a?(CodeObjects::Proxy) }
  end
  children.select{|o| o.is_a?(CodeObjects::ClassObject) && o.inheritance_tree.include?(P(ActionController::Base))}
end

# Renders the JSON for a single controller
# @param controller [CodeObjects::ClassObject] The controller to render
# @param indent_level [Number] Optional the level of indentation to render at
# @return [String] The json to be returned
def controller_template(controller, indent_level = 0)
  out = il("\"#{controller.name}\":{", indent_level)

  actions = controller.meths.select{|m| m.visibility == :public && m[:routes]}.collect do |method|
    action_template(method, indent_level + 1)
  end
  out << actions.join(",\n") << "\n"

  out << il("}", indent_level, false)
end

# Renders the json for a single action on a controller
def action_template(method, indent_level = 0)
  out = il("\"#{method.name}\":{", indent_level)
  out << il("\"description\": \"#{json_safe_string(method.docstring)}\",", indent_level + 1)
  out << il("\"secure\": false,", indent_level + 1)
  out << params_template(method, indent_level + 1) << ",\n"
  out << il("\"liquid_vars\":{},", indent_level + 1)
  out << routes_template(method, indent_level + 1) << ",\n"
  out << formats_template(method, indent_level + 1) << "\n"
  out << il("}", indent_level, false)
end

# Renders the Url Params json for a single action
def params_template(method, indent_level = 0)
  out = il("\"params\":{", indent_level)
  param_tags = method.tags(:url_param).reject{|t| t.name == "format"}
  grouped_tags = param_tags.group_by{|p| p.types.nil?}
  simple_params, complex_params = (grouped_tags[true] || []), (grouped_tags[false] || [])
  simple_params += complex_params.collect{|param| complex_param_json(param)}.flatten

  params = simple_params.sort_by(&:name).collect do |tag|
    param_out = il("\"#{tag.name}\":{", indent_level + 1)
    param_out << il("\"description\": \"#{tag.text}\",", indent_level + 2)
    param_out << il("\"required\": #{tag.required}", indent_level + 2)
    param_out << il("}", indent_level + 1, false)
  end

  out << params.join(",\n") << "\n"
  out << il("}", indent_level, false)
end

def complex_param_json(param_tag)
  param_tag.types.collect do |param_type|
    if (obj = YARD::Registry.resolve(nil, param_type, false, false)) && obj[:active_record_attributes]
      collect_nested_attributes(obj[:active_record_attributes].accessible_attributes, param_tag.name) do |attribute, attr_name|
        FakeUrlTag.new(attr_name, "#{param_tag.text}: attribute #{attribute}", false)
      end
    else
      [param_tag]
    end
  end.flatten
end

def collect_nested_attributes(attributes, prefix)
  attr_pairs = attributes.collect do |attr|
    if attr.simple?
      {attr => "#{prefix}[#{attr}]"}
    else
      collect_nested_attributes(attr.complex_type[:active_record_attributes].accessible_attributes, "#{prefix}[#{attr}][]")
    end
  end.flatten

  return attr_pairs unless block_given?
  attr_pairs.collect do |hash|
    attr, attr_name = hash.keys.first, hash.values.first
    yield(attr, attr_name)
  end
end


# Renders the routes json for a single action
def routes_template(method, indent_level = 0)
  out = il("\"methods\":{", indent_level)
  http_methods = method[:routes].group_by{|hash| hash[:methods]}.collect do |method, route_infos|
    method_out = il("\"#{method}\":{", indent_level + 1)
    method_out << il("\"routes\":[", indent_level + 2)
    routes_out = route_infos.collect do |route_info|
      il('"' + route_info[:name] + '"', indent_level + 3, false)
    end
    method_out << routes_out.join(",\n") << "\n"
    method_out << il("]", indent_level + 2)
    method_out << il("}", indent_level + 1, false)
  end
  out << http_methods.join(",\n") << "\n"
  out << il("}", indent_level, false)
end

# Renders the accepted html output formats for a single action
def formats_template(method, indent_level = 0)
  out = il("\"formats\":{", indent_level)
  formats = method.tags(:format).collect do |tag|
    il("\"#{tag.name}\": \"#{tag.text}\"", indent_level + 1, false)  
  end
  out << formats.join(",\n") << "\n"
  out << il("}", indent_level, false)
end

# Transforms string into an indented line
def il(str, indent_level, include_newline = true)
  ("\t" * indent_level) + str.gsub("\n", " ") + (include_newline ? "\n" : "")
end

def proxy?(obj)
  return true if obj.is_a?(::YARD::CodeObjects::Proxy)
end

def json_safe_string(string)
  DESCRIPTION_SUBS.to_a.inject(string){|str, char_swap| str.gsub(*char_swap)}
end
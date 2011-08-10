module YardTiiExtensions

  class YardRoutesEngine

    def initialize(registry)
      @registry = registry
    end

    def load_routes_into_registry!
      Routes.build.group_by{|rd| [rd.controller, rd.action]}.each do |cntrl_and_action, route_descs|
        controller, action = *cntrl_and_action
        obj = @registry.resolve(P(controller), "##{action}")
        #puts "Working on #{controller}:#{action} - results in #{obj.inspect}"
        next if obj.nil? || obj.is_a?(YARD::CodeObjects::Proxy)

        # Add routes
        obj[:routes] ||= []
        # In cases where two yard tasks are run one right another this prevents duplicate routes
        # being added
        route_descs.collect{|rd| {:name => rd.path, :methods => rd.methods}}.each do |rd|
          obj[:routes] << rd unless obj[:routes].include?(rd)
        end
        #puts "obj[:routes] - #{obj[:routes].inspect}"

        # Scan for missing parameters
        path_params = route_descs.collect{|rd| rd.path_parameters}
        uniq_path_params = path_params.flatten.uniq
        # All parameters that are in all paths are required
        req_params = path_params[1..-1].inject(path_params[0]){|req, rp| req & rp}
        #puts "req_params: #{req_params.inspect}"

        uniq_path_params.each do |param|
          unless url_tag = obj.tags.detect{|t| t.tag_name == "url_param" && t.name == param}
            url_tag = ::YardForLiquid::UrlParameterTag.new("url_param", "#{param} parameter is supplied in path")
            url_tag.object = obj
            obj.docstring.add_tag(url_tag)
          end
          url_tag.required = req_params.include?(param)  
        end
      end
    end

    class <<self
      def load_routes_into_registry!(registry = YARD::Registry)
        new(registry).load_routes_into_registry!
      end
    end

  end
end

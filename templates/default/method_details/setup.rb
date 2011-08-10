#def init
#  super
#  sections.last.place(:routes).before(:method_signature)
#end



def filter_messages
  filter_lists = object.namespace.inheritance_tree.collect{|obj| obj.is_a?(::YARD::CodeObjects::Proxy) ? nil : obj[:filters]}.compact
  return [] if filter_lists.empty?
  full_filter_list = filter_lists.first.with_ancestors(filter_lists[1..-1])
  full_filter_list.filters_for(object.name).collect{|filter| filter.documentation}  
end
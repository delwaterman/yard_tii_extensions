require 'yard_tii_extensions/route_descriptor'
#ActionDispatch

module YardTiiExtensions
  module Rails3

    # This class builds all the routes for a Rails 3 project
    class RouteDescriptorsBuilder

      def self.build_routes
        ::ActionDispatch::Routing::Routes.routes.select{|rt| rt.requirements[:controller] && rt.requirements[:action]}.collect do |route|
          cntrl = route.requirements[:controller].camelcase + "Controller"
          methods = (route.verb || "ANY").to_s.split("|").collect{|s| s.upcase}
          path_parameters = route.segment_keys.collect(&:to_s)
          
          # RouteDescriptor = Struct.new(:controller, :action, :route, :methods, :path_parameters)
          methods.collect do |method|
            ::YardTiiExtensions::RouteDescriptor.new(cntrl, route.requirements[:action], route.path, method, path_parameters)
          end
        end.flatten
      end
    end
  end
end
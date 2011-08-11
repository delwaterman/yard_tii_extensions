require 'yard_tii_extensions/route_descriptor'

module YardTiiExtensions
  module Rails2

    # This class builds all the routes for a Rails 3 project
    class RouteDescriptorsBuilder

      def self.build_routes
        ActionController::Routing::Routes.routes.collect do |route|
          verb = (route.conditions[:method] || :any).to_s.upcase
          controller = (route.defaults[:controller] + "_controller").camelcase
          path = route.segments.inject("") { |str,s| str << s.to_s }
          path_parameters = route.segments.select{|seg| seg.is_a?(ActionController::Routing::DynamicSegment)}.collect do |seg|
            seg.key.to_s
          end
          
          # RouteDescriptor = Struct.new(:controller, :action, :route, :methods, :path_parameters)
          ::YardTiiExtensions::RouteDescriptor.new(controller, route.defaults[:action], path, verb, path_parameters)
        end
      end
    end
  end
end
module YardTiiExtensions

  RouteDescriptor = Struct.new(:controller, :action, :path, :methods, :path_parameters)

  class Routes
    class <<self
      def build
        if RAILS_3
          require 'yard_tii_extensions/rails_3/route_descriptor_builder'
          klass = Rails3::RouteDescriptorsBuilder
        else
          require 'yard_tii_extensions/rails_2/route_descriptor_builder'
          klass = Rails2::RouteDescriptorsBuilder
        end
        klass.build_routes
      end
    end
  end


end
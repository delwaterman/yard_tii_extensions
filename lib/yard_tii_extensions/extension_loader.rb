module YardTiiExtensions
  
  module ExentsionLoader
    
    def self.load_extensions(configuration)

      require 'pathname'
      require 'yard-tii-extensions/yard_override'
      require 'yard-tii-extensions/yard_routes_engine'
      require 'yard-tii-extensions/routes_md_generator'
      # require 'yard-tii-extensions/liquid_customization_md_generator' if ::YardTiiCom::USE_LIQUID
      require 'yard-tii-extensions/handlers/before_filter_require_profile_handler'
      require 'yard-tii-extensions/handlers/attr_protected_handler'
      require 'yard-tii-extensions/handlers/attr_accessible_handler'
      require 'yard-tii-extensions/handlers/attr_accessor_handler'
      require 'yard-tii-extensions/handlers/accepts_nested_attributes_handler'
      require 'yard-tii-extensions/handlers/validate_presence_of_handler'
      require 'yard-tii-extensions/handlers/legacy/before_filter_require_profile_handler'
      require 'yard-tii-extensions/handlers/legacy/accepts_nested_attributes_handler'
      require 'yard-tii-extensions/handlers/legacy/attr_accessible_handler'
      require 'yard-tii-extensions/handlers/legacy/attr_accessor_handler'
      require 'yard-tii-extensions/handlers/legacy/attr_protected_handler'
      require 'yard-tii-extensions/handlers/legacy/super_serialize_handler'
      require 'yard-tii-extensions/handlers/legacy/validate_acceptance_of_handler'
      require 'yard-tii-extensions/handlers/legacy/validate_confirmation_of_handler'
      require 'yard-tii-extensions/handlers/legacy/validate_presence_of_handler'
      require 'yard-tii-extensions/handlers/legacy/validator_handler_helper'
      
      # require 'yard-tii-extensions/liquid_handlers'
      
      require 'yard-tii-extensions/url_parameter_tag'
      
      #template_dir = Pathname.new(File.dirname(__FILE__) + 'templates').realpath.to_s
      template_dir = Pathname.new(File.dirname(__FILE__) + '/../templates').to_s
      #puts "template_dir: #{template_dir}"
      YARD::Templates::Engine.register_template_path(template_dir)
      #puts "template_paths: " + YARD::Templates::Engine.template_paths.inspect
      
      # if YardTiiExtensions::USE_LIQUID
      #    YARD::Tags::Library.define_tag("Liquid Template Variables", :drop, :with_types_and_name)
      #  end
      
      
      YARD::Tags::Library.define_tag("URL Parameters", :url_param, ::YardForLiquid::UrlParameterTag)
      YARD::Tags::Library.define_tag("Responses for formats", :format, :with_name)
      YARD::Tags::Library.define_tag("Query String", :query_string)
      
      # ROUTES FILE
      # ROUTES_FILE = File.join(File.dirname(__FILE__), "../../../../tmp/routes.txt")
      
      # class String
      #   def camelcase
      #     gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
      #   end
      # end      
    end
    
    
  end
  
end
module YardTiiExtensions
  
  module ExentsionLoader
    
    def self.load_extensions(config = YardTiiExtensions::DocConfig.instance)

      require 'pathname'
      require 'yard_tii_extensions/yard_override'
      require 'yard_tii_extensions/yard_routes_engine' if config.need_routes?
      require 'yard_tii_extensions/routes_md_generator' if config.document_routes?
      require 'yard_tii_extensions/liquid_customization_md_generator' if config.document_liquid?
      
      
      require 'yard_tii_extensions/handlers/attr_protected_handler'
      require 'yard_tii_extensions/handlers/attr_accessible_handler'
      require 'yard_tii_extensions/handlers/attr_accessor_handler'
      require 'yard_tii_extensions/handlers/accepts_nested_attributes_handler'
      require 'yard_tii_extensions/handlers/validate_acceptance_of_handler'
      require 'yard_tii_extensions/handlers/validate_presence_of_handler'
      require 'yard_tii_extensions/handlers/validate_confirmation_of_handler'
      
      require 'yard_tii_extensions/handlers/legacy/accepts_nested_attributes_handler'
      require 'yard_tii_extensions/handlers/legacy/attr_accessible_handler'
      require 'yard_tii_extensions/handlers/legacy/attr_accessor_handler'
      require 'yard_tii_extensions/handlers/legacy/attr_protected_handler'
      require 'yard_tii_extensions/handlers/legacy/validate_acceptance_of_handler'
      require 'yard_tii_extensions/handlers/legacy/validate_confirmation_of_handler'
      require 'yard_tii_extensions/handlers/legacy/validate_presence_of_handler'
      require 'yard_tii_extensions/handlers/legacy/validator_handler_helper'
      
      if config.document_liquid?
        require 'yard_tii_extensions/handlers/register_tag_handler'
        require 'yard_tii_extensions/handlers/register_filter_handler'
        YARD::Tags::Library.define_tag("Liquid Template Variables", :drop, :with_types_and_name)
      end
      
      if config.url_parameters?
        require 'yard_tii_extensions/url_parameter_tag'
        YARD::Tags::Library.define_tag("URL Parameters", :url_param, ::YardForLiquid::UrlParameterTag)
        YARD::Tags::Library.define_tag("Responses for formats", :format, :with_name)
        YARD::Tags::Library.define_tag("Query String", :query_string)
      end
      
      if config.super_serialize?
        require 'yard_tii_extensions/handlers/super_serialize_handler'
        require 'yard_tii_extensions/handlers/legacy/super_serialize_handler'
      end
      
      if config.require_user_filter
        require 'yard_tii_extensions/handlers/before_filter_require_profile_handler' 
        require 'yard_tii_extensions/handlers/legacy/before_filter_require_profile_handler'
      end
    end
    
    
  end
  
end
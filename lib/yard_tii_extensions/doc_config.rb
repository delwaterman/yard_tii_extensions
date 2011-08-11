require 'pathname'
module YardTiiExtensions
  
  class DocConfig
    include Singleton
    
    # The name of the project
    attr_accessor :project_name
    # A short description of the project
    attr_accessor :project_description
    # True if the project uses Liquid Templates, would need documentation for those templates
    attr_accessor :document_liquid
    alias_method :document_liquid?, :document_liquid
    # True if the project should document routes
    attr_accessor :document_routes
    alias_method :document_routes?, :document_routes
    # True if the project should document url parameters
    attr_accessor :url_parameters
    alias_method :url_parameters?, :url_parameters
    # True if the project has a require_user_filter and should document those cases
    attr_accessor :require_user_filter
    alias_method :require_user_filter?, :require_user_filter
    # True if project should generate JSON API of all routes
    attr_accessor :json_api
    alias_method :json_api?, :json_api
    # Uses Ary's super_serialize plugn
    attr_accessor :super_serialize
    alias_method :super_serialize?, :super_serialize
    
    # True if the configuration was read
    attr_accessor :config_read
    
    DEFAULTS = {:document_liquid      => false,
                :document_routes      => true,
                :url_parameters       => true,
                :require_user_filter  => false,
                :json_api             => false,
                :super_serialize      => false}
                
    ATTRS = [:project_name, :project_description] + DEFAULTS.keys
    
    class Builder
      def initialize(config)
        @config = config
      end
      
      ATTRS.each do |attr|
        class_eval <<-CODE
          def #{attr}(value)
            @config.send(\"#{attr}\=", (value))
          end
        CODE
      end
    end
    
    class<<self
      def document(&block)
        builder = Builder.new(self.instance)
        yield builder
        self.instance.config_read = true
      end
      
      def get
        unless instance.config_read
          raise "Config file '#{config_file}' does not exist" unless File.file?(config_file)
          load config_file
        end
        instance
      end
      
      def config_file
        @config_file ||= File.join(Rails.root, "config", "initializers", "yard_documentation.rb")
      end
      
    end
  
    def initialize
      DEFAULTS.each do |attr, value|
        self.send("#{attr}=", value)
      end
      config_read = false
    end
      
    def need_routes?
      document_routes || json_api
    end    
  end
end
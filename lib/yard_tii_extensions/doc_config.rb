module YardTiiExtensions
  
  class DocConfig
    include Singleton
    
    # The name of the project
    attr_accessor :project_name
    # A short description of the project
    attr_accessor :project_description
    # True if the project uses Liquid Templates, would need documentation for those templates
    attr_accessor :document_liquid
    # True if the project should document routes
    attr_accessor :document_routes
    # True if the project should document url parameters
    attr_accessor :url_parameters
    # True if the project has a require_user_filter and should document those cases
    attr_accessor :require_user_filter
    # True if project should generate JSON API of all routes
    attr_accessor :json_api
    
    DEFAULTS = {:document_liquid      => false,
                :document_routes      => true,
                :url_parameters       => true,
                :require_user_filter  => false,
                :json_api             => false}
                
    ATTRS = [:project_name, :project_description] + DEFAULTS.keys
    
    class Builder
      def initialize(config)
        @config = config
      end
      
      ATTRS.each do |attr|
        eval <<-CODE
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
      end
    end
  
    def initialize
      DEFAULTS.each do |attr, value|
        self.send("#{attr}=", value)
      end
    end
      
  end
end
module YardForLiquid
  class RegisterTagHandler < YARD::Handlers::Ruby::Base
    # HANDLER = /^(?:\:\:)?Liquid::Template.register_tag[\s\(]?\s*([^\)]*)\)?/
    handles method_call(:register_tag)
    
    def process
      ensure_loaded!(tag_klass)
      tag_klass['liquid_tags'] ||= []
      tag_klass['liquid_tags'] << tag_name_parameter
    end

    def tag_klass
      P(parameters[1].source)
    end
    
    def tag_name_parameter
      @tag_name_parameter ||= parameters[0].jump(:tstring_content).source
    end

    private
    
    def parameters
      statement.parameters
    end

  end
end
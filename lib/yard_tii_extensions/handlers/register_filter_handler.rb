module YardTiiExtensions
    
  class RegisterFilterHandler < YARD::Handlers::Ruby::Base
    # HANDLER = /^(?:\:\:)?Liquid::Template.register_filter[\s\(]?\s*([^\)]*)\)?/
    handles method_call(:register_filter)

    def process
      ensure_loaded!(tag_klass)
      tag_klass['liquid_filters'] = true
    end

    def tag_klass
      P(parameters[0].jump(:const).source)
    end

    def parameters
      statement.parameters
    end

  end

end
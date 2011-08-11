module YardForLiquid

  class UrlParameterTag < ::YARD::Tags::Tag
    REQUIRED_MARK = '%required%'
    OPENING_TYPES = '({<'
    CLOSING_TYPES = '>})'

    attr_accessor :required

    def initialize(tag_name, text)
      super(tag_name, nil)
      @name, @types, parsed_text = *(factory.send(:extract_types_and_name_from_text, text, OPENING_TYPES, CLOSING_TYPES))
      @name, parsed_text = *(factory.send(:extract_name_from_text, text)) unless @name
      set_text(parsed_text)  
    end

    private


    def set_text(text)
      if text.include?(REQUIRED_MARK)
        self.required = true
        @text = text.gsub(REQUIRED_MARK, '')
      else
        self.required = false
        @text = text
      end
    end

    def factory
      ::YARD::Tags::Library.default_factory
    end

  end



end
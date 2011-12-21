module YardForLiquid
  module Legacy
    class RegisterTagHandler < YARD::Handlers::Ruby::Legacy::Base
      HANDLER = /^(?:\:\:)?Liquid::Template.register_tag[\s\(]?\s*([^\)]*)\)?/
      handles HANDLER

      def process
        ensure_loaded!(tag_klass)
        tag_klass['liquid_tags'] ||= []
        tag_klass['liquid_tags'] << liquid_tag
      end

      def liquid_tag
        @liquid_tag ||= strip_quotes(parameters[0])
      end

      def tag_klass
        P(parameters[1])
      end

      def parameters
        @parameters ||= HANDLER.match(statement.tokens.to_s)[1].split(/,\s*/)
      end

      private

      def strip_quotes(string)
        [/^["']/, /['"]$/].inject(string) {|string, r| string.gsub(r, '')}
      end
    end

    class RegisterFilterHandler < YARD::Handlers::Ruby::Legacy::Base
      HANDLER = /^(?:\:\:)?Liquid::Template.register_filter[\s\(]?\s*([^\)]*)\)?/
      handles HANDLER

      def process
        ensure_loaded!(tag_klass)
        tag_klass['liquid_filters'] = true
      end

      def tag_klass
        P(parameters[0])
      end

      def parameters
        @parameters ||= HANDLER.match(statement.tokens.to_s)[1].split(/,\s*/)
      end

    end
  end
end
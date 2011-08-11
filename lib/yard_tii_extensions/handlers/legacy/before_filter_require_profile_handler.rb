require 'yard_tii_extensions/filters'

module YardTiiExtensions
  module Legacy
    class BeforeFilterRequireProfileHandler < YARD::Handlers::Ruby::Legacy::Base
      MATCH = /^before_filter\s+:require_user/
      handles MATCH

      def process
        owner[:filters] ||= FilterList.new()
        owner[:filters] << (skip? ? SkipFilter : Filter).new(owner, :before_filter, :require_user, require_profile_options, "This action requires logged in user.")
      end

      private

      def options_tokens
        if @options_tokens.nil?
          token = statement.tokens.find{|tk| [":except", ":only"].include?(tk.text)}
          if token
            start_ix = statement.tokens.squeeze.index(token)
            @options_tokens = statement.tokens.squeeze[start_ix..-1]
          else
            @options_tokens = []
          end
        end
        @options_tokens
      end

      def require_profile_options
        @require_profile_options ||= if options_tokens.empty?
          {}
        else
          key = options_tokens.first.text == ":except" ? :except : :only
          actions = options_tokens[1..-1].collect(&:text).select{|txt| /\:?[a-zA-Z]+/ =~ txt}
          {key => actions}
        end
      end

      def skip?
        statement.to_s.starts_with?("skip")
      end
    end
  end
end
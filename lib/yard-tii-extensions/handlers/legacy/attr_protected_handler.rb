require 'yard_tii_extensions/active_record_attribute'
module YardTiiExtensions
  module Legacy
    class AttrProtectedMatcher < YARD::Handlers::Ruby::Legacy::Base
      include ActiveRecordAttributesHelper
      ATTR_PROTECTED = /^attr_protected\s+(.*)/
      handles ATTR_PROTECTED

      def process
        parameters.each do |param|
          ar_attribute(param).accessible = false
        end
      end

      def parameters
        @parameters ||= statement.tokens[1..-1].to_s.strip.split(/,\s+/).map{|param| param.sub(':', '')}
      end
    end
  end
end
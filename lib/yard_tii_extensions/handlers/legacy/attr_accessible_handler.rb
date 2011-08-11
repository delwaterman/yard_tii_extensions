require 'yard_tii_extensions/active_record_attribute'
module YardTiiExtensions
  module Legacy
    class AttrAccessibleMatcher < YARD::Handlers::Ruby::Legacy::Base
      include ActiveRecordAttributesHelper
      ATTR_ACCESSIBLE = /^attr_accessible\s+(.*)/
      handles ATTR_ACCESSIBLE

      def process
        parameters.each do |param|
          ar_attribute(param).accessible = true
        end
      end

      def parameters
        @parameters ||= statement.tokens[1..-1].to_s.strip.split(/,\s+/).map{|param| param.sub(':', '')}
      end
    end
  end
end
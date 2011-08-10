require 'yard_tii_extensions/active_record_attribute'
module YardTiiExtensions
  module Legacy

    class AttrAccessorHandler < YARD::Handlers::Ruby::Legacy::Base
      include ActiveRecordAttributesHelper
      handles /\Aattr(?:_(?:writer|accessor))?(?:\s|\()/

      def process
        return nil unless active_record_object?
        attributes.each{|attr| ar_attribute(attr)}
      end

      def attributes
        @attributes ||= statement.tokens[1..-1].to_s.strip.split(/,\s+/).map{|param| param.sub(':', '')}  
      end
    end
  end
end
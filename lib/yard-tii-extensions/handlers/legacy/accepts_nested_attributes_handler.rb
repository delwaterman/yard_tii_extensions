require 'yard_tii_extensions/active_record_attribute'
require 'yard_tii_extensions/handlers/legacy/validator_handler_helper'
module YardTiiExtensions
  module Legacy
    class AcceptsNestedAttributesHandler < YARD::Handlers::Ruby::Legacy::Base
      include ActiveRecordAttributesHelper
      include ValidatorHandlerHelper
      ATTR_NESTED = /^accepts_nested_attributes_for\s+(.*)/
      handles ATTR_NESTED

      def process
        nested_options = pull_conditions do |key, value|
          (key == ":allow_destroy" && value == "true")
        end
        nested_options ||= {}
        attributes.each do |children|
          ar_attribute("#{children}_attributes", nested_options.merge(:complex_type => determine_type(children)))
        end
      end

      private

      def determine_type(children)
        owner.path.constantize.reflections[children.to_sym].klass.to_s
      end

      def actual_klass
        @actual_klass ||= owner.path.constantize
      end
    
    end
  end
end
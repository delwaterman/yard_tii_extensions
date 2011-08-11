require 'yard_tii_extensions/active_record_attribute'
require 'yard_tii_extensions/handlers/legacy/validator_handler_helper'

module YardTiiExtensions
  module Legacy
    class ValidateAcceptanceOfHandler < YARD::Handlers::Ruby::Legacy::Base
      include ValidatorHandlerHelper
      include ActiveRecordAttributesHelper

      VALIDATION_STMNT = /^validates_acceptance_of\s+(.*)/
      handles VALIDATION_STMNT

      def process
        conditions = pull_conditions do |key, condition|
          %w(:if :unless :on).include?(key) || (key == "allow_nil" && value == "true")
        end

        attributes.each do |param|
          ar_attr = ar_attribute(param)
          ar_attr.required(conditions.join(' and ')) if conditions
        end
      end
    end
  end
end
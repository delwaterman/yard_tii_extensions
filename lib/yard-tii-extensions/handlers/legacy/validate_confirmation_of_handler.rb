require 'yard_tii_extensions/active_record_attribute'
require 'yard_tii_extensions/handlers/legacy/validator_handler_helper'

module YardTiiExtensions
  module Legacy
    class ValidateConfirmationOfHandler < YARD::Handlers::Ruby::Legacy::Base
      include ValidatorHandlerHelper
      include ActiveRecordAttributesHelper

      VALIDATION_STMNT = /^validates_confirmation_of\s+(.*)/
      handles VALIDATION_STMNT

      def process
        conditions = pull_conditions do |key, condition|
          %w(:if :unless :on).include?(key) || (key == ":allow_nil" && condition == "true")
        end
        conditions = conditions.collect{|k, v| "#{k} => #{v}"} if conditions

        attributes.each do |param|
          new_param_name = param.to_s + "_confirmation"
          ar_attr = ar_attribute(new_param_name)
          ar_attr.required(conditions.try(:join, ' and '))
        end
      end
    end
  end
end
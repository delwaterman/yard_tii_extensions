require 'yard_tii_extensions/active_record_attribute'
require 'yard_tii_extensions/handlers/legacy/validator_handler_helper'

module YardTiiExtensions
  module Legacy
    class ValidatePresenceOfHandler < YARD::Handlers::Ruby::Legacy::Base
      include ValidatorHandlerHelper
      include ActiveRecordAttributesHelper
      VALIDATION_STMNT = /^validates_presence_of\s+(.*)/
      handles VALIDATION_STMNT

      def process
        conditions = pull_conditions{|key, value|
          case key
            when ":if", ":unless", ":on"
              true
            when ":allow_nil"
              value == "true"
            else
              false
          end
        }

        attributes.each do |param|
          ar_attribute(param).required(conditions)
        end
      end
    end
  end
end
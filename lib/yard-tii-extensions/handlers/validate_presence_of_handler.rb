require 'yard_tii_extensions/active_record_attribute'
require 'yard_tii_extensions/handlers/class_statements_helper'

module YardTiiExtensions

  class ValidatePresenceOfHandler < YARD::Handlers::Ruby::Base
    # include ValidatorHandlerHelper
    include ActiveRecordAttributesHelper
    include ClassStatementsHelper
    # VALIDATION_STMNT = /^validates_presence_of\s+(.*)/
    handles method_call(:validates_presence_of)

    def process
      conditions = pull_options do |key, value|
        case key
          when ":if", ":unless", ":on"
            true
          when ":allow_nil"
            value == "true"
          else
            false
        end
      end
      
      conditions = nil if conditions.empty?
      attributes.each do |param|
        ar_attribute(param).required(conditions)
      end
    end
  end
  
end
require 'yard_tii_extensions/active_record_attribute'
require 'yard_tii_extensions/handlers/class_statements_helper'

module YardTiiExtensions

  class ValidatePresenceOfHandler < YARD::Handlers::Ruby::Base
    # include ValidatorHandlerHelper
    include ActiveRecordAttributesHelper
    include ClassStatementsHelper

    handles method_call(:validates_presence_of)

    def process
      conditions = pull_options do |key, value|
        case key.source
          when ":if", ":unless", ":on"
            true
          when ":allow_nil"
            value.source == "true"
          else
            false
        end
      end
      
      conditions = if conditions.empty?
        nil
      else
        conditions.to_a.collect do |key, value|
          "#{key.source} => #{value.source}"
        end.join(" and ")
      end
      
      attributes.each do |param|
        ar_attribute(param).required(conditions)
      end
    end
  end
  
end
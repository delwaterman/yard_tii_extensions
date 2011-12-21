require 'yard_tii_extensions/active_record_attribute'
require 'yard_tii_extensions/handlers/class_statements_helper'

module YardTiiExtensions
  class ValidateConfirmationOfHandler < YARD::Handlers::Ruby::Base
    include ClassStatementsHelper
    include ActiveRecordAttributesHelper
    
    handles method_call(:validates_confirmation_of)

    def process
      conditions = pull_options do |key, condition|
        %w(:if :unless :on).include?(key.source) || (key.source == ":allow_nil" && condition.source == "true")
      end
      conditions = conditions.collect{|k, v| "#{k.source} => #{v.source}"}

      attributes.each do |param|
        new_param_name = param.to_s + "_confirmation"
        ar_attr = ar_attribute(new_param_name)
        ar_attr.required(conditions.join(' and '))
      end
    end
  end
end
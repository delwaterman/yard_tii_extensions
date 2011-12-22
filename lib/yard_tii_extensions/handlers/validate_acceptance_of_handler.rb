require 'yard_tii_extensions/active_record_attribute'
require 'yard_tii_extensions/handlers/class_statements_helper'

module YardTiiExtensions
  class ValidateAcceptanceOfHandler < YARD::Handlers::Ruby::Base
    include ClassStatementsHelper
    include ActiveRecordAttributesHelper

    handles method_call(:validates_acceptance_of)

    def process
      conditions = pull_options do |key, condition|
        %w(:if :unless :on).include?(key.source) || (key.source == ":allow_nil" && condition.source == "true")
      end

      conditions = conditions.collect{|k, v| "#{k.source} => #{v.source}"}
      attributes.each do |param|
        ar_attr = ar_attribute(param)
        ar_attr.required(conditions.join(' and ')) if conditions.any?
      end
    end
  
  end
end
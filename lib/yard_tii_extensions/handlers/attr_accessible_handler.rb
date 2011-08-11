require 'yard_tii_extensions/active_record_attribute'
require 'yard_tii_extensions/handlers/class_statements_helper'

module YardTiiExtensions

  class AttrAccessibleMatcher < YARD::Handlers::Ruby::Base
    include ActiveRecordAttributesHelper
    include ClassStatementsHelper

    handles method_call(:attr_accessible)

    def process
      attributes.each do |param|
        ar_attribute(param).accessible = true
      end
    end
  end
end
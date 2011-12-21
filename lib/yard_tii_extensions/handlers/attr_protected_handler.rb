require 'yard_tii_extensions/active_record_attribute'
require 'yard_tii_extensions/handlers/class_statements_helper'
module YardTiiExtensions

  class AttrProtectedMatcher < YARD::Handlers::Ruby::Base
    include ActiveRecordAttributesHelper
    include ClassStatementsHelper
    
    handles method_call(:attr_protected)
    
    def process
      attributes.each do |attr|
        ar_attribute(attr).accessible = false
      end
    end

  end
end
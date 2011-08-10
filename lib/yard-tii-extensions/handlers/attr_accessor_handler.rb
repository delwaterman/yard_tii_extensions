require 'yard_tii_extensions/active_record_attribute'
require 'yard_tii_extensions/handlers/class_statements_helper'

module YardTiiExtensions

  class AttrAccessorHandler < YARD::Handlers::Ruby::Base
    include ActiveRecordAttributesHelper
    include ClassStatementsHelper
    handles method_call(:attr_accessor)
    handles method_call(:attr_writer)

    def process
      attributes.each{|attr| ar_attribute(attr)}
    end

  end
end
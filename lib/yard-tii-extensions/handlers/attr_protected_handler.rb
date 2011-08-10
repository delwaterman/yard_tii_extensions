require 'yard_tii_extensions/active_record_attribute'
module YardTiiExtensions

  class AttrProtectedMatcher < YARD::Handlers::Ruby::Base
    include ActiveRecordAttributesHelper
    
    handles method_call(:attr_protected)
    
    def process
      attributes.each do |attr|
        ar_attribute(attr).accessible = false
      end
    end
    
    def attributes
      @attributes ||= statement.parameters.collect do |param|
        attribute_name(param)
      end.compact
    end
    
    def attribute_name(param_ast)
      return nil unless param_ast
      param_ast.jump(:ident).source
    end

  end
end
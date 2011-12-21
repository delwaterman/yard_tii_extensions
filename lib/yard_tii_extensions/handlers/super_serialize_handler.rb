require 'yard_tii_extensions/active_record_attribute'
require 'yard_tii_extensions/handlers/class_statements_helper'

module YardTiiExtensions
  class SuperSerializeHandler < YARD::Handlers::Ruby::Base

    include ActiveRecordAttributesHelper
    include ClassStatementsHelper
    handles method_call(:super_serialize)

    def process
      column = ::SuperSerialize::ClassMethods::COLUMN
      # Add methods
      reader_meth = ::YARD::CodeObjects::MethodObject.new(namespace, name) do |o|
        o.source = %{def #{name}
          # #{column}.key?(:#{name}) ? #{column}[:#{name}] : #{default}
          #{column}.key?(:#{name}) && !#{column}[:#{name}].nil? ? #{column}[:#{name}] : #{default}
        end}
        o.docstring = statement.comments.to_s.empty? ? "Returns the value of attribute #{name}" : statement.comments
      end
      register reader_meth


      register ::YARD::CodeObjects::MethodObject.new(namespace, name) do |o|
        o.parameters = [['value', nil]]
        o.source =  %{def #{name}=(value)
          self.#{column}[:#{name}] = #{owner.name.to_s}.to_super_serialize(value)
          #{column}_will_change!
        end }
      end
    

      # Add attributes
      ar_attribute(name)
    end

    def name
      parameters[0].jump(:ident).source
    end

    def type
      parameters[1].jump(:const).source
    end

    def default
      return @default unless @default.nil?
      options.each do |key, value|
        next unless key.source == ":default"
        @default = value.source
        break
      end
    end

  end
end
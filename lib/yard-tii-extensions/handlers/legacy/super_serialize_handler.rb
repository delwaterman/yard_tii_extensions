require 'yard_tii_extensions/active_record_attribute'
require 'yard_tii_extensions/handlers/legacy/validator_handler_helper'
module YardTiiExtensions
  module Legacy
    class SuperSerializeHandler < YARD::Handlers::Ruby::Legacy::Base
      include ValidatorHandlerHelper
      include ActiveRecordAttributesHelper
      handles /\Asuper_serialize/

      def process
        column = ::SuperSerialize::ClassMethods::COLUMN
        # Add methods
        reader_meth = ::YARD::CodeObjects::MethodObject.new(owner, name) do |o|
          o.source = %{def #{name}
            # #{column}.key?(:#{name}) ? #{column}[:#{name}] : #{default}
            #{column}.key?(:#{name}) && !#{column}[:#{name}].nil? ? #{column}[:#{name}] : #{default}
          end}
          o.docstring = statement.comments.to_s.empty? ? "Returns the value of attribute #{name}" : statement.comments
        end
        register reader_meth


        register ::YARD::CodeObjects::MethodObject.new(owner, name) do |o|
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
        parameters[0].sub(":", '')
      end

      def type
        parameters[1]
      end

      def default
        return @default if @default
        md = /\s+\:default\s+=>\s+(\S+)/.match(statement.tokens.to_s)
        md ? md[1] : nil
      end

      def parameters
        @parameters ||= statement.tokens[1..-1].to_s.strip.split(/,\s+/)
      end
    end
  end
end
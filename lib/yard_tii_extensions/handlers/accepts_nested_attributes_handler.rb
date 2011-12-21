require 'yard_tii_extensions/active_record_attribute'
require 'yard_tii_extensions/handlers/class_statements_helper'
module YardTiiExtensions
    class AcceptsNestedAttributesHandler < YARD::Handlers::Ruby::Base
      include ActiveRecordAttributesHelper
      include ClassStatementsHelper
      handles method_call(:accepts_nested_attributes_for)

      def process
        nested_options = options.to_a.inject({}) do |hash, key_and_value|
          key, value = key_and_value
          if key.source == ":allow_destroy" && value.source == "true"
            hash.merge(key.source => value.source)
          else
            hash
          end
        end
        
        attributes.each do |children|
          ar_attribute("#{children}_attributes", nested_options.merge(:complex_type => determine_type(children)))
        end
      end

      private

      def determine_type(children)
        if active_record?
          actual_klass.reflections[children.to_sym].klass.to_s
        elsif mongo_mapper?
          actual_klass.associations[children.to_sym].klass.to_s
        else
          raise "Don't know how to process 'accepts_nested_attributes_for' for '#{namespace.path}'"
        end
      end

      def actual_klass
        @actual_klass ||= namespace.path.constantize
      end
      
      def active_record?
        # only looking for direct descendants
        namespace.inheritance_tree(false).include? P("ActiveRecord::Base")
      end
    
      def mongo_mapper?
        # These are included modules
        namespace.inheritance_tree(true).any? {|obj| obj == P("MongoMapper::Document") || obj == P("MongoMapper::EmbeddedDocument")}
      end
    
    end
end
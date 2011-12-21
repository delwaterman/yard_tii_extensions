require 'yard_tii_extensions/active_record_attribute'

module YardTiiExtensions

  # An attribute for an active record model
  class ActiveRecordAttribute
    attr_accessor :name, :requirement, :accessible

    def initialize(name, options = {})
      self.name = name
      self.requirement = options[:required]
      self.accessible = options[:accessible]
    end

    def required(condition = nil)
      requirement = Requirement.new(condition)
    end

    def required?(conditional = false)
      conditional ? (!!requirement) : (requirement && requirement.absolute?)
    end

    def to_s
      name
    end

    def simple?
      true
    end

    def convert_to_nested(type, options = {})
      NestedTypeAttribute.new(self.name,
                              type,
                              {:required => requirement, :accessible => accessible}.merge(options))
    end

    # A requirement for an ActiveRecordAttribute
    class Requirement
      attr_accessor :condition

      def initialize(condition_str = nil)
        self.condition = condition_str
      end

      def absolute?
        condition.nil?
      end
    end
  end

  class NestedTypeAttribute < ActiveRecordAttribute
    attr_accessor :complex_type, :options

    def initialize(name, complex_type, options = {})
      super(name, options)
      self.complex_type = complex_type
      self.options = options
    end

    def complex_type
      case @complex_type
        when String
          P(@complex_type)
        when Class
          P(@complex_type.to_s)
        else
          @complex_type
      end
    end

    def simple?
      false
    end

    def convert_to_nested
      self.dup
    end

  end

  # Special hash to manage ActiveRecord Attributes
  class ActiveRecordAttributes < Hash
    def find_or_build(key, options = {})
      type = options.delete(:complex_type)
      if self[key]
        self[key] = self[key].convert_to_nested(type, options) if type && self[key].simple?
        self[key]
      else
        self[key] = type ? NestedTypeAttribute.new(key, type, options) : ActiveRecordAttribute.new(key)
      end
    end

    def accessible_attributes
      accessible_settings = values.map{|attr| attr.accessible}.uniq
      # If an attribute is explicitly set to being accessible then its assumed that all other
      # attributes must be explicitly set to true. Otherwise the attribute must be explicitly
      # set to false to deny access.
      accessible_settings.include?(true) ? values.select{|v| v.accessible == true} : values.select{|v| v.accessible != false}
    end
  end

  module ActiveRecordAttributesHelper
    def ar_attribute(name, options = {})
      namespace[:active_record_attributes] ||= ActiveRecordAttributes.new
      namespace[:active_record_attributes].find_or_build(name, options)
    end

    def active_record_object?
      namespace.inheritance_tree.include?(P("ActiveRecord::Base"))
    end
  end

end
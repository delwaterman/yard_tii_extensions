require 'yard_tii_extensions/active_record_attribute'

module YardTiiExtensions
  module Legacy
    module ValidatorHandlerHelper
      OPTIONS_HASH = /(\:?\w+)\s+=>\s+(.+)/
    
      def self.included(klass)
        klass.class_eval <<-CODE
          attr_accessor :_options
          attr_accessor :_parameters
          attr_accessor :_attributes
        CODE
      end

      def options
        return _options if _options
        options_ix = parameters.index{|stmnt| OPTIONS_HASH =~ stmnt}
        if options_ix
          _options = parameters[options_ix..-1].map do |stmnt|
            md = OPTIONS_HASH.match(stmnt)
            {md[1] => md[2]}
          end
        else
          _options = []
        end
      end

      def parameters
        _parameters ||= statement.tokens[1..-1].to_s.strip.split(/,\s+/)
      end

      def attributes
        return _attributes if _attributes
        attribute_ix = parameters.index{|stmnt| OPTIONS_HASH =~ stmnt}
        _attributes ||= (attribute_ix ?  parameters[0..(attribute_ix - 1)] : parameters).map{|p| p.gsub(/^\:/, '')}.map{|p| p.gsub(/['"]/, '')}
      end

      def pull_conditions(&block)
        raise ArgumentError, "Must provide a block" unless block_given?
        temp_ar = options.select do |hash|
          key, value = hash.to_a.first
          yield(key, value)
        end
        return nil if temp_ar.empty?
        temp_ar.inject({}){|massive_hash, individual_hash| massive_hash.merge(individual_hash)}
      end
    end
  end
end
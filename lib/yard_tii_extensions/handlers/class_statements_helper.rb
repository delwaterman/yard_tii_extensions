module YardTiiExtensions
  
  module ClassStatementsHelper
    
    def self.included(klass)
      klass.class_eval <<-CODE
        attr_accessor :_options
        attr_accessor :_attributes
      CODE
    end

    def attributes
      return _attributes if _attributes
      attr_names = ->(params){params.collect{|ast| ast.jump(:ident).source}}
      
      _attributes = case options_ix
        when 0
          []
        when nil
          attr_names.(parameters)
        else
          attr_names.(parameters[0..(options_ix - 1)])
      end
    end

    def options
      return _options if _options
       _options = {}
      return _options unless options_ix
       
      # Cycle through all the :assoc nodes and pull the keys and values
      parameters[options_ix].children.each do |assoc_node|
        _options.merge!(assoc_node.children.first => assoc_node.children.last)
      end
      _options 
    end
    
    def pull_options
      raise ArgumentError, "Must provide a block" unless block_given?
    
      options.to_a.inject({}) do |hash, key_and_values|
        key, value = key_and_values.first, key_and_values.last
        if yield(key, value)
          hash.merge(key => value)
        else
          hash
        end
      end
    end
    
    # def pull_key(ast)
    #    ast.jump(:ident).source
    #  end
    #   
    #  def pull_values(ast)
    #    case ast.type
    #    when :array
    #      array_innards(ast).collect do |a|
    #        pull_values(a)
    #      end.flatten
    #    when :symbol_literal
    #      ast.jump(:ident).source
    #    else 
    #      ast.source
    #    end
    #  end
    #   
    #  def array_innards(ast)
    #    ast.children.first.children
    #  end
    
    def parameters
      statement.parameters.children
    end
    
    def options_ix
      if parameters[-1].type == :list && parameters[-1].children.all?{|s| s.type == :assoc}
        parameters.length - 1
      else
        nil
      end
    end

    
  end
end
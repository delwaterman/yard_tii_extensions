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
      options_ix = parameters.index{|ast| ast && ast.try(:type) == :list}
      if options_ix == 0
        _attributes = []
        return _attributes
      end
      attribute_asts = (options_ix ? parameters[0..(options_ix - 1)] : parameters[0..-2])
      _attributes = attribute_asts.collect{|ast| ast.jump(:ident).source}
    end

    def options
      return _options if _options
      ast_opts = parameters[-2].jump(:assoc)
      _options = {}
      return _options unless ast_opts.type == :assoc
      key, value = nil, nil
      ast_opts.children.each_with_index do |ast, ix|
        if ix % 2 == 0   # key
          key = pull_key(ast)
        else             # value
          value = pull_values(ast)
          _options.merge!(key => value)
          key = nil
        end
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
    
    def pull_key(ast)
      ast.jump(:ident).source
    end
  
    def pull_values(ast)
      if ast.type == :array
        array_innards(ast).collect do |a|
          pull_values(a)
        end.flatten
      else
        ast.jump(:ident).source
      end
    end
  
    def array_innards(ast)
      ast.children.first.children
    end
    
    def parameters
      statement.parameters
    end

    
  end
end
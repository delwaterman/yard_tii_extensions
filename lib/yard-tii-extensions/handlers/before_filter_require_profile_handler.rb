require 'yard_tii_extensions/filters'

module YardTiiExtensions
  
  class BeforeFilterRequireProfileHandler < YARD::Handlers::Ruby::Base
    handles method_call(:before_filter)
    handles method_call(:skip_before_filter)

    def process
      return unless filter_name == :require_user
      owner[:filters] ||= FilterList.new()
      owner[:filters] << (skip? ? SkipFilter : Filter).new(owner, :before_filter, :require_user, require_profile_options, "This action requires logged in user.")
    end

    private

    def options
      return @options if @options
      ast_opts = statement.parameters[-2].jump(:assoc)
      @options = {}
      return @options unless ast_opts.type == :assoc
      key, value = nil, nil
      ast_opts.children.each_with_index do |ast, ix|
        if ix % 2 == 0   # key
          key = pull_key(ast)
        else             # value
          value = pull_values(ast)
          @options.merge!(key => value)
          key = nil
        end
      end
      @options 
    end
  
    def require_profile_options
      return @require_profile_options if @require_profile_options
    
      @require_profile_options = options.to_a.inject({}) do |hash, key_and_values|
        key, values = key_and_values.first, key_and_values.last
        if ["only", "except"].include?(key)
          hash.merge(key => values) 
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
  
    def filter_name
      statement.parameters.first.jump(:ident).source.to_sym
    end
  
    def array_innards(ast)
      ast.children.first.children
    end
  
    def skip?
      statement.method_name.source.starts_with?("skip")
    end
  end
end
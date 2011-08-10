module YardTiiExtensions
  class FilterList < Array
    
    def with_ancestors(ancestors)
      ancestors.inject(self) do |combined_filter, filter_list|
        combined_filter.inherits(filter_list)
      end
    end

    def filters_for(action_name)
      f_lists = [self]
      f_lists += @inherited_filter_lists if @inherited_filter_lists
      all_filters = f_lists.collect{|fl| fl.select{|filter| filter.filters?(action_name)}}.flatten
      grouped_filters = all_filters.group_by(&:method_name)
      grouped_filters.values.inject([]) do |array, filters|
        if filters.first.skip?
          array
        else
          array << filters.first
        end
      end

    end

    def inherits(filter_list)
      new_me = dup
      new_inherited_filter_lists = (@inherited_filter_lists.try(:dup) || [])
      new_inherited_filter_lists << filter_list
      new_me.instance_variable_set(:@inherited_filter_lists, new_inherited_filter_lists)
      new_me
    end
  end

  class Filter
    attr_accessor :controller, :method_name, :filter_type, :options, :documentation

    def initialize(controller, filter_type, method_name, options, documentation)
      self.controller = controller
      self.filter_type = filter_type
      self.method_name = method_name.to_sym
      self.options = options
      self.documentation = documentation
    end

    def method_object
      @method_object ||= ::YARD::Registry.resolve(controller, "##{method_name}", true, false)
    end

    def filters?(action_name)
      if options[:except]
        options[:except].include?(action_name.to_sym) ? false : true
      elsif options[:only]
        options[:only].include?(action_name.to_sym) ? true : false
      else
        true
      end
    end

    def skip?
      false
    end
  end

  class SkipFilter < Filter
    def filters?(action_name)
      super ? :skip : false
    end

    def skip?
      true
    end
  end
end
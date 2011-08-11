require 'erb'

module YardTiiExtensions
  class LiquidCustomizationMdGenerator
    TEMPLATE_FILE = File.join(File.dirname(__FILE__), '../../templates/liquid/LiquidCustomization.md.erb')
    TARGET_DIR = File.join(File.dirname(__FILE__), '../../../../../doc')

    class <<self

      def render!(register = YARD::Registry)
        @register = register
        write_to_file(template.result(binding))
      end

      def tag_docs
        @tag_docs ||= tags.inject([]) do |docs, tag|
          docs + tag['liquid_tags'].collect{|l_tag|
            "#{l_tag} - {#{tag.path}} #{("- " + tag.docstring.summary) unless tag.docstring.empty?}"
          }
        end.sort
      end

      def drop_docs
        @drop_docs ||= standard_summary(drops)
      end

      def filter_docs
        @filter_docs ||= filters.collect do |filter|
          "#{filter.name} - {#{filter.path}} #{("- " + filter.docstring.summary) unless filter.docstring.summary.empty?}"
        end
      end

      def standard_summary(objects)
        objects.collect do |o|
          "{#{o.path}} - #{o.docstring.summary unless o.docstring.summary.empty?}"
        end
      end

      private

      def template
        @template ||= ERB.new(File.read(TEMPLATE_FILE), nil, "<>")
      end

      def tags
        @tags ||= @register.objects.values.select do |object|
          object.is_a?(YARD::CodeObjects::ClassObject) && tag_base_classes.detect{|klass| object.inheritance_tree.include?(klass)}
        end.sort_by{|o| o.path.to_s}
      end

      def drops
        @drops ||= @register.objects.values.select do |object|
          object.is_a?(YARD::CodeObjects::ClassObject) && object.inheritance_tree.include?(base_drop_class)
        end.sort_by{|o| o.path.to_s}
      end

      def filters
        @filters ||= @register.objects.values.select do |object|
          object['liquid_filters']
        end.collect{|o| o.meths(:included => true, :scope => :instance, :visibility => :public)}.flatten.sort_by{|m| m.name.to_s}
      end

      def write_to_file(content)
        filename = File.join(TARGET_DIR, 'LiquidCustomization.md')
        File.open(filename, 'w') do |file|
          file << content
        end
      end

      def tag_base_classes
        @tag_base_classes ||= [P(Liquid::Block), P(Liquid::Tag)] 
      end

      def base_drop_class
        @base_drop_class ||= P(Liquid::Drop)
      end

    end
  end
end
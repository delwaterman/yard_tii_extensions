require 'erb'
require 'yard_tii_extensions/route_descriptor'

module YardTiiExtensions

  class RoutesMdGenerator
    TEMPLATE_FILE = File.join(File.dirname(__FILE__), '../../templates/routes_md_generator/routes.md.erb')
    TARGET_DIR = Rails.root + 'doc'

    class <<self

      def generate!
        markdown = generate_markdown
        write_to_file(markdown, TARGET_DIR)
      end

      def generate_markdown
        current_routes = Routes.build.delete_if{|rt| /\/rails\/info\/properties/ =~ rt.path}
        application_name = DocConfig.instance.application_name
        ERB.new(template, nil, "<>").result(binding)
      end
    
      def template
        @template ||= File.read(TEMPLATE_FILE)
      end

      def write_to_file(file_contents, target_dir)
        file = File.join(target_dir, 'Routes.md')
        File.open(file, 'w') do |f|
          f << file_contents
        end
      end

    end
  end
end
require 'yard'
$:.unshift "#{File.dirname(__FILE__)}"

module YardTiiExtensions
  GEM_ROOT = File.expand_path(File.join(File.dirname(__FILE__), ".."))
  
  if defined?(Rails)
    require 'yard_tii_extensions/railtie'
    RAILS_3 = /^3\./ =~ Rails.version
    RAILS_2 = !RAILS_3
  end
  
  template_dir = Pathname.new(File.join(GEM_ROOT, 'templates')).to_s
  YARD::Templates::Engine.register_template_path(template_dir)
end

require 'yard_tii_extensions/doc_config'
require 'yard_tii_extensions/extension_loader'
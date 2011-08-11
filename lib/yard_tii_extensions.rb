$:.unshift "#{File.dirname(__FILE__)}"

# Let's get rake tasks loading

# Configuration files working

# Executable to configure file

module YardTiiExtensions
  GEM_ROOT = File.expand_path(File.join(File.dirname(__FILE__), ".."))
  
  if defined?(Rails)
    require 'yard-tii-extensions/railtie'
    RAILS_3 = /^3\./ =~ Rails.version
    RAILS_2 = !RAILS_3
  end
end
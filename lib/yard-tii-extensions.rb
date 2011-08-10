$:.unshift "#{File.dirname(__FILE__)}"

# Let's get rake tasks loading

# Configuration files working

# Executable to configure file

module YardTiiExtensions
  require 'yard-tii-extensions/railtie' if defined?(Rails)
end
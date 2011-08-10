require 'yard-tii-extensions'
require 'rails'
module YardTiiExtensions
  class Railtie < Rails::Railtie
    # railtie_name :yard_tii_extensions

    rake_tasks do
      load "tasks/yard-tii-extensions.rake"
    end
  end
end

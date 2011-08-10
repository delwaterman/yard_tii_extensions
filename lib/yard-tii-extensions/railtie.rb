require 'yard_tii_extensions'
require 'rails'
module YardTiiExtensions
  class Railtie < Rails::Railtie
    railtie_name :yard_tii_extensions

    rake_tasks do
      load "tasks/yard_tii_com.rake"
    end
  end
end

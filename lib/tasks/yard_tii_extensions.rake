desc 'Generate full yard documentation'
# task :yard => ['yard:load_libs', 'yard:generate', 'yard:original', 'yard:json_api']
task :yard => ['yard:load_libs', 'yard:generate', 'yard:original']
task :whitelabel => ['yard:load_libs', 'yard:generate', 'yard:json_api']

namespace :yard do
  task :load_libs do
    require 'yard'
    require 'yard-tii-extensions/extension_loader'
    debugger
    YardTiiExtensions::ExentsionLoader.load_extensions(nil)
    YARD::Rake::YardocTask.new('yard:original') do |t|
#      t.files   = ['lib/**/*.rb', 'app/**/*.rb', '-', 'doc/Routes.md', 'doc/Comments.md', 'doc/Profiles.md']
      t.files   = ['lib/**/*.rb', 'app/**/*.rb', 'config/initializers/*.rb', '-', 'doc/*.md']
#        t.options = %w(--title Time\ Community\ Platform --quiet --output-dir ./doc/yard)
      t.options = %w(--title Time\ Community\ Platform --output-dir ./doc/yard)
    end

    YARD::Rake::YardocTask.new('yard:json_api') do |t|
      t.files   = ['lib/**/*.rb', 'app/**/*.rb', '-', 'doc/*.md']
#        t.options = %w(--title Time\ Community\ Platform --quiet --output-dir ./doc/yard)
      t.options = %w(--title Time\ Community\ Platform --output-dir ./doc/yard/json_api --template json_api --format js)
    end
  end

  desc 'Builds the routes markdown file for further processing by yard'
  task :generate => 'generate:routes_markdown'

  namespace :generate do
    desc 'Builds the routes markdown file for further processing by yard'
    task :routes_markdown => [:environment, :load_libs] do
      YardTiiExtension::RoutesMdGenerator.generate!
    end
  end
end

# namespace :yard do
#   desc "Test rake"
#   task :test_loading do
#     puts "Yay!!! I ran"
#   end
# end




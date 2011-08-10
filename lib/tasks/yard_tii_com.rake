# desc 'Generate full yard documentation'
# task :yard => ['yard:load_libs', 'yard:generate', 'yard:original', 'yard:json_api']
# task :whitelabel => ['yard:load_libs', 'yard:generate', 'yard:json_api']
# 
# namespace :yard do
#   task :load_libs do
#     require 'yard'
#     # TODO port in yard-struct
# #    require 'yard-struct'
#     require 'vendor/plugins/yard_tii_com/lib/yard_tii_com'
#     YARD::Rake::YardocTask.new('yard:original') do |t|
# #      t.files   = ['lib/**/*.rb', 'app/**/*.rb', '-', 'doc/Routes.md', 'doc/Comments.md', 'doc/Profiles.md']
#       t.files   = ['lib/**/*.rb', 'app/**/*.rb', 'config/initializers/*.rb', '-', 'doc/*.md']
# #        t.options = %w(--title Time\ Community\ Platform --quiet --output-dir ./doc/yard)
#       t.options = %w(--title Time\ Community\ Platform --output-dir ./doc/yard)
#     end
# 
#     YARD::Rake::YardocTask.new('yard:json_api') do |t|
#       t.files   = ['lib/**/*.rb', 'app/**/*.rb', '-', 'doc/*.md']
# #        t.options = %w(--title Time\ Community\ Platform --quiet --output-dir ./doc/yard)
#       t.options = %w(--title Time\ Community\ Platform --output-dir ./doc/yard/json_api --template json_api --format js)
#     end
#   end
# 
#   desc 'Builds the routes markdown file for further processing by yard'
#   task :generate => 'generate:routes_markdown'
# 
#   namespace :generate do
#     desc 'Builds the routes markdown file for further processing by yard'
#     task :routes_markdown => [:environment, :load_libs] do
#       YardTiiCom::RoutesMdGenerator.generate!
#     end
#   end
# end

namespace :yard do
  task :test_loading do
    puts "Yay!!! I ran"
  end
end




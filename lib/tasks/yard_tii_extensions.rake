# Clearing up task descriptions
def reset_description(task, new_description)
  task = Rake::Task[task]
  task.instance_variable_set(:@comment, nil)
  task.instance_variable_set(:@full_comment, nil)
  task.add_description(new_description)
end

config = YardTiiExtensions::DocConfig.get
default_tasks = ['yard:original']
if config.document_routes
  default_tasks.insert(0, 'yard:generate:routes_markdown')
end

if config.json_api
  default_tasks << 'Generates the JSON API for communicating with the server'
  YARD::Rake::YardocTask.new('yard:json_api') do |t|
    t.files   = ['lib/**/*.rb', 'app/**/*.rb', '-', 'doc/*.md']
    t.options = %w(--title Time\ Community\ Platform --output-dir ./doc/yard/json_api --template json_api --format js)
  end
  reset_description('yard:json_api', "Generate the JSON API documentation")
end

desc "Generates all yard documentation for project"
task :yard => default_tasks

YARD::Rake::YardocTask.new('yard:original') do |t|
  t.files   = ['lib/**/*.rb', 'app/**/*.rb', 'config/initializers/*.rb', '-', 'doc/*.md']
  t.options = ["--title", config.project_name, "--output-dir", "./doc/yard"]
end
reset_description('yard:original', "The basic documentation generation for YARD")

namespace :yard do
  task :load_libs do
    YardTiiExtensions::ExentsionLoader.load_extensions(config)
  end

  namespace :generate do
    if config.document_routes
      desc 'Builds a Routes Markdown file to document all routes'
      task :routes_markdown => [:environment, :load_libs] do
        YardTiiExtensions::RoutesMdGenerator.generate!
      end
    end
  end
end



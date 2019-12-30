# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

if Rails.env.development?
  require 'quality/rake/task'
  
  Quality::Rake::Task.new do |task| 
    task.skip_tools = ['linguist']
  end 
  task default: [:spec, :quality]
end

Rails.application.load_tasks

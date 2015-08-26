ENV['RACK_ENV'] ||= 'development'

require "bundler/gem_tasks"
require "rake/testtask"

require "./lib/scrape_covers"

Dir["./lib/tasks/**/*.rake"].each do |task_file|
  import task_file
end

# Used to output comments
Rake::TaskManager.record_task_metadata = true

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => :test

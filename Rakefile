require "bundler/gem_tasks"
require "rake/testtask"
require 'dotenv'

Dotenv.load

require "./lib/scrape_covers"

import "./lib/tasks/db.rake"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => :test

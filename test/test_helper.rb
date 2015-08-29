ENV['RACK_ENV'] = 'test'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'scrape_covers'

ScrapeCovers.configure do |config|
  rack_env = ENV['RACK_ENV'].upcase
  config.db_host = ENV["#{rack_env}_DB_HOST"]
  config.db_name = ENV["#{rack_env}_DB_NAME"]
  config.db_user = ENV["#{rack_env}_DB_USER"]
  config.db_password = ENV["#{rack_env}_DB_PASSWORD"]
  config.log_sql_queries = ENV["LOG_SQL_QUERIES"] == 'true' ? true : false
end

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/reporters'

require 'pry'

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(:color => true)]

FIXTURE_FILE_PATH = File.join(File.dirname(__FILE__), 'html_files')

class Minitest::Test
  def reset_db
    ScrapeCovers::Db.reset_db
  end
end

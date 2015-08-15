$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'scrape_covers'

require 'dotenv'

Dotenv.load

ScrapeCovers.configure do |config|
  config.db_host = ENV['DEVELOPMENT_DB_HOST']
  config.db_name = ENV['DEVELOPMENT_DB_NAME']
  config.db_user = ENV['DEVELOPMENT_DB_USER']
  config.db_password = ENV['DEVELOPMENT_DB_PASSWORD']
end

begin
  ScrapeCovers::Db.connection
rescue => e
  puts e
  puts "Make sure Database: #{ScrapeCovers.db_name} exists: "
  puts "psql -U #{ScrapeCovers.db_user} -d #{ScrapeCovers.db_name} -c 'SELECT * FROM pg_stat_activity'\n"
  puts "If it does not: psql -U #{ScrapeCovers.db_user} -c 'CREATE DATABASE #{ScrapeCovers.db_name}'"
end

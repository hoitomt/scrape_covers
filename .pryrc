ENV['RACK_ENV'] = 'development'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'scrape_covers'

begin
  ScrapeCovers::Db.connection
rescue => e
  puts e
  puts "Make sure Database: #{ScrapeCovers.db_name} exists: "
  puts "psql -U #{ScrapeCovers.db_user} -d #{ScrapeCovers.db_name} -c 'SELECT * FROM pg_stat_activity'\n"
  puts "If it does not: psql -U #{ScrapeCovers.db_user} -c 'CREATE DATABASE #{ScrapeCovers.db_name}'"
end

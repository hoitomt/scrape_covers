require 'bundler'
Bundler.require(:default)

require 'dotenv'
Dotenv.load

Dir["./lib/config/**/*.rb", "./lib/scrape_covers/**/*.rb"].each do |file|
  require file
end

module ScrapeCovers
  class << self
    attr_accessor :db_host, :db_name, :db_user, :db_password, :log_sql_queries

    def configure
      yield self if block_given?
    end
  end
end

ScrapeCovers.configure do |config|
  # Not optimal - this is here because rake tasks include this file,
  # But RACK_ENV isn't set when it's included so it screws up the connection
  next unless ENV['RACK_ENV']

  rack_env = ENV['RACK_ENV'].upcase
  config.db_host = ENV["#{rack_env}_DB_HOST"]
  config.db_name = ENV["#{rack_env}_DB_NAME"]
  config.db_user = ENV["#{rack_env}_DB_USER"]
  config.db_password = ENV["#{rack_env}_DB_PASSWORD"]
  config.log_sql_queries = ENV["LOG_SQL_QUERIES"] == 'true' ? true : false
end

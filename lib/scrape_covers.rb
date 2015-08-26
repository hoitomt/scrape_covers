require 'bundler'
Bundler.require(:default)

require 'dotenv'
Dotenv.load

Dir["./lib/config/**/*.rb", "./lib/scrape_covers/**/*.rb"].each do |file|
  require file
end

module ScrapeCovers
  class << self
    attr_accessor :db_host, :db_name, :db_user, :db_password

    def configure
      yield self if block_given?
    end
  end
end

ScrapeCovers.configure do |config|
  rack_env = ENV['RACK_ENV'].upcase
  config.db_host = ENV["#{rack_env}_DB_HOST"]
  config.db_name = ENV["#{rack_env}_DB_NAME"]
  config.db_user = ENV["#{rack_env}_DB_USER"]
  config.db_password = ENV["#{rack_env}_DB_PASSWORD"]
end

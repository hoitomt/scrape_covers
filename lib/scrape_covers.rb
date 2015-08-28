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

require 'bundler'
Bundler.require(:default)

require "scrape_covers/version"
require "scrape_covers/db"

module ScrapeCovers
  class << self
    attr_accessor :db_host, :db_name, :db_user, :db_password

    def configure
      yield self if block_given?
    end
  end
end

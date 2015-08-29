require "./lib/scrape_covers"

namespace :scrape_covers do
  desc "Initialize the environment"
  task :environment, [:env] do |task, args|
    ENV['RACK_ENV'] ||= args[:env] || 'development'
    puts "#{task.full_comment}: #{ENV['RACK_ENV']}"

    ScrapeCovers.configure do |config|
      rack_env = ENV['RACK_ENV'].upcase
      config.db_host = ENV["#{rack_env}_DB_HOST"]
      config.db_name = ENV["#{rack_env}_DB_NAME"]
      config.db_user = ENV["#{rack_env}_DB_USER"]
      config.db_password = ENV["#{rack_env}_DB_PASSWORD"]
      config.log_sql_queries = ENV["LOG_SQL_QUERIES"] == 'true' ? true : false

      puts "Configure Scrape Covers #{config.db_name}"
    end
  end

end

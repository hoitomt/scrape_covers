namespace :scrape_covers do
  namespace :db do

    desc "Create the database"
    task :create do |task|
      puts task.full_comment
      ScrapeCovers::Db.create_database
    end

    desc "Setup the database"
    task :migrate do |task|
      puts task.full_comment
      ScrapeCovers::Db.create_results_table unless ScrapeCovers::Db.table_exists?('results')
      ScrapeCovers::Db.create_teams_table unless ScrapeCovers::Db.table_exists?('teams')
    end

    desc "Seed the teams"
    task :seed_teams do |task|
      puts task.full_comment
      ScrapeCovers::Db.seed_teams
    end

    # namespace :test do
    #   desc "Create and migrate the test database"
    #   task :prepare do |task|
    #     ENV['RACK_ENV'] = 'test'
    #     Rake::Task["scrape_covers:db:create"].reenable
    #     Rake::Task["scrape_covers:db:create"].invoke

    #     Rake::Task["scrape_covers:db:migrate"].reenable
    #     Rake::Task["scrape_covers:db:migrate"].invoke
    #   end
    # end
  end
end

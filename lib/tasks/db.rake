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
  end
end

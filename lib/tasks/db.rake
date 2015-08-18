namespace :scrape_covers do
  namespace :db do
    desc 'setup the database'
    task :migrate do
      ScrapeCovers::Db.create_results_table unless ScrapeCovers::Db.table_exists?('results')
      ScrapeCovers::Db.create_teams_table unless ScrapeCovers::Db.table_exists?('teams')
    end
  end
end

namespace :scrape_covers do
  namespace :scrape do

    desc "Scrape all known data from covers.com"
    task :all => [:environment] do |task|
      puts task.full_comment
      Years.nfl_years.each do |year|
        Teams.nfl_teams.keys.each do |covers_id|
          Rake::Task['scrape_covers:scrape:year_team'].reenable
          Rake::Task['scrape_covers:scrape:year_team'].invoke(year, covers_id)
        end
      end
    end

    desc "Scrape the data from covers.com for "
    task :year_team, [:year_range, :covers_id] do |task, args|
      year_range = args[:year_range]
      covers_id = args[:covers_id]

      url = ScrapeCovers::Crawler.nfl_url(year_range, covers_id)

      begin
        data = ScrapeCovers::Crawler.fetch_nfl_data(year_range, covers_id)

        team = ScrapeCovers::Team.find_by_covers_id(covers_id)
        parser = ScrapeCovers::Parser.new(team, data)
        results = parser.parse

        puts "Created results for #{team.name} - #{year_range}"
      rescue => e
        puts "#{e}: #{team.name} for year_range #{year_range} - #{url}"
      end
    end
  end
end

namespace :scrape_covers do
  namespace :scrape do

    desc "Scrape all known data from covers.com"
    task :all do |task|
      Years.nfl_years.each do |year|
        ScrapeCovers::Team.all.each do |team|
          puts "Year #{year} Team #{team}"
        end
      end
    end

    desc "Scrape the data from covers.com for a given year range and team id"
    task :year_team, [:year_range, :covers_team_id] do |task, args|
      puts task.full_comment
      year_range = args[:year_range]
      covers_team_id = args[:covers_team_id]
      team = ScrapeCovers::Team.find_by_covers_id(covers_team_id)
      url = ScrapeCovers::Crawler.nfl_url(year_range, covers_team_id)

      begin

        puts "Retrieve data from #{url}"
        data = ScrapeCovers::Crawler.fetch_nfl_data(year_range, covers_team_id)

        parser = ScrapeCovers::Parser.new(team, data)
        results = parser.parse
        results.each do |result|
          puts result.display
        end
      rescue => e
        puts "#{e}: #{team.name} for year_range #{year_range} - #{url}"
      end
    end
  end
end

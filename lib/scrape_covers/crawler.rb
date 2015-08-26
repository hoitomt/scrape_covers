require 'open-uri'

module ScrapeCovers
  class Crawler
    # Purposefully use a singleton to not spin up a bunch of objects
    class << self

      def fetch_nfl_data(team_scores_id, year_range)
        result = open(nfl_url(team_scores_id, year_range))
      end

      def nfl_url(year_range, covers_team_id)
        "http://www.covers.com/pageLoader/pageLoader.aspx?page=/data/nfl/teams/pastresults/#{year_range}/team#{covers_team_id}.html"
      end
    end
  end
end

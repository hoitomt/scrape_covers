require 'open-uri'

module ScrapeCovers
  class Crawler
    # Purposefully use a singleton to not spin up a bunch of objects
    class << self
      def url(team_scores_id, year_range)
        "http://www.covers.com/pageLoader/pageLoader.aspx?page=/data/ncf/teams/pastresults/#{year_range}/team#{team_scores_id}.html"
      end

      def fetch_data(team_scores_id, year_range)
        open(url(team_scores_id, year_range))
      end
    end
  end
end

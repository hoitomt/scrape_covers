module ScrapeCovers
  class Team
    attr_accessor :id, :covers_id, :name

    def self.find_by_covers_id(covers_id)
      db_data = ScrapeCovers::Db::find_team_by_covers_id(covers_id)
      return if db_data.nil?
      self.new(db_data)
    end

    def self.all
      ScrapeCovers::Db::all_teams.map do |team_data|
        self.new(team_data)
      end
    end

    def initialize(args)
      self.id = args['id']
      self.covers_id = args['covers_id']
      self.name = args['name']
    end
  end
end

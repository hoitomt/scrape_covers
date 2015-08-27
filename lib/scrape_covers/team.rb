module ScrapeCovers
  class Team
    attr_accessor :id, :covers_id, :name

    def self.find_by_covers_id(covers_id)
      db_data = ScrapeCovers::Db::find_team_by_covers_id(covers_id)
      return if db_data.nil?
      self.new(db_data)
    end

    def self.find_by_id(id)
      db_data = ScrapeCovers::Db::find_team_by_id(id)
      return if db_data.nil?
      self.new(db_data)
    end

    def self.all
      ScrapeCovers::Db::all_teams.map do |team_data|
        self.new(team_data)
      end
    end

    def self.create(args)
      self.new(args).save
    end

    def initialize(args)
      self.id = args['id'] || args[:id]
      self.covers_id = args['covers_id'] || args[:covers_id]
      self.name = args['name'] || args[:name]
    end

    def save
      db_result = ScrapeCovers::Db.upsert_team(team_args)
      self.id = db_result['id']
      self
    end

    private
    def team_args
      {
        id: self.id,
        covers_id: self.covers_id,
        name: self.name
      }
    end
  end
end

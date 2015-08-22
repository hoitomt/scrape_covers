require 'yaml'

class Teams
  class << self
    def nfl_teams
      @nfl_teams_hash ||= YAML::load_file(File.join(File.dirname(__FILE__), 'teams.yml'))['nfl']
    end

    def nfl_team_name(team_id)
      nfl_teams[team_id.to_i]
    end
  end
end

require 'yaml'

class Teams
  class << self
    def nfl_teams
      @nfl_teams_hash ||= YAML::load_file(File.join(File.dirname(__FILE__), 'teams.yml'))['nfl']
    end
  end
end

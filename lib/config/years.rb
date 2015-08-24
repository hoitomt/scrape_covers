require 'yaml'

class Years
  class << self
    def nfl_years
      @nfl_years ||= YAML::load_file(File.join(File.dirname(__FILE__), 'years.yml'))
    end
  end
end

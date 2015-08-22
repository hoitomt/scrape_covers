module ScrapeCovers
  attr_reader :date,
              :home_team, :home_team_id,
              :away_team, :away_team_id,
              :home_team_score, :away_team_score,
              :line, :over_under

  class Result
    def initialize(team_id, row)
      @subject_team_id = team_id.to_i
      @row = row
      raise "Unable to create a result - Invalid raw data: #{team_id}" if cells.length != 6
    end

    def save!
      self
    end

    def parse
    end

    def date
      return nil if date_cell.nil?
      date_string = date_cell.split(' ').last
      Date.strptime(date_string, '%m/%d/%y')
    end

    def home_team
      Teams.nfl_team_name(home_team_id)
    end

    def home_team_id
      set_team_ids
      @home_team_id
    end

    def away_team
      Teams.nfl_team_name(away_team_id)
    end

    def away_team_id
      set_team_ids
      @away_team_id
    end

    private

    def set_team_ids
      opponent_team_id = opponent_cell_href.match(/team(\d+)/).to_s.gsub('team', '').to_i
      if opponent_cell['@']
        @away_team_id = @subject_team_id
        @home_team_id = opponent_team_id
      else
        @away_team_id = opponent_team_id
        @home_team_id = @subject_team_id
      end
    end

    def cells
      @cells ||= @row.css('td')
    end

    # <td class="datacell">Saturday 08/09/14</td>
    def date_cell
      clean_cell(cells[0])
    end

    # <td class="datacell">@ <a href="...">Tennessee</a></td>
    def opponent_cell
      clean_cell(cells[1])
    end

    # The anchor link contains the team id
    def opponent_cell_href
      cells[1].css('a').first['href']
    end

    # <td class="datacell">L <a href="...">16-20</a></td>
    def result_cell
      clean_cell(cells[2])
    end

    # <td class="datacell">Pre-Week 1</td>
    def schedule_week_cell
      clean_cell(cells[3])
    end

    # <td class="datacell">L 2.5</td>
    def line_cell
      clean_cell(cells[4])
    end

    # <td class="datacell">U 37.5</td>
    def over_under_cell
      clean_cell(cells[5])
    end

    def clean_cell(cell)
      return nil if cell.nil?
      cell.content.strip
    end
  end
end

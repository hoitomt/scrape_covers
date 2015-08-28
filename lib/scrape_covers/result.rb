module ScrapeCovers
  attr_reader :date,
              :home_team, :home_team_id,
              :away_team, :away_team_id,
              :home_team_score, :away_team_score,
              :line, :over_under

  class Result
    def initialize(team, row)
      @subject_team = team
      @row = row
      raise "Unable to create a result - Invalid raw data: #{team_id}" if cells.length != 6
    end

    def save!
      ScrapeCovers::Db.upsert_result(self)
      self
    end

    def display
      puts %Q{
        #{self.away_team}(#{self.away_team_id})\t\t #{self.away_team_score}
        #{self.home_team}(#{self.home_team_id})\t\t #{self.home_team_score}
        Line: Home Team by #{self.line}
        Over Under: #{self.over_under}
      }
    end

    def date
      return nil if date_cell.nil?
      date_string = date_cell.split(' ').last
      @date = Date.strptime(date_string, '%m/%d/%y')
    end

    def home_team
      Team.find_by_id(home_team_id).name
    end

    def home_team_id
      set_team_ids
      home_team = Team.find_by_covers_id(@home_team_covers_id)
      @home_team_id = home_team.id
    end

    def away_team
      Team.find_by_id(away_team_id).name
    end

    def away_team_id
      set_team_ids
      away_team = Team.find_by_covers_id(@away_team_covers_id)
      @away_team_id = away_team.id
    end

    def home_team_score
      set_scores
      @home_team_score.to_i
    end

    def away_team_score
      set_scores
      @away_team_score.to_i
    end

    # line is relative to the home team
    def line
      @line = line_cell.split(' ').last.to_f
      if opponent_cell['@']
        @line *= -1
      end
      @line
    end

    def over_under
      over_under_cell.split(' ').last.to_f
    end

    private

    def set_team_ids
      opponent_team_id = opponent_cell_href.match(/team(\d+)/).to_s.gsub('team', '').to_i
      if opponent_cell['@']
        @away_team_covers_id = @subject_team.covers_id
        @home_team_covers_id = opponent_team_id
      else
        @away_team_covers_id = opponent_team_id
        @home_team_covers_id = @subject_team.covers_id
      end
    end

    def set_scores
      scores = score_only.split('-')
      if opponent_cell['@']
        @home_team_score = scores.last
        @away_team_score = scores.first
      else
        @home_team_score = scores.first
        @away_team_score = scores.last
      end
    end

    def score_only
      score_array = result_cell.split(' ')
      until score_array.last =~ /\d+/
        score_array.pop
      end
      score_array.last
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

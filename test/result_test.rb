require 'test_helper'

describe ScrapeCovers::Result do
  subject{ ScrapeCovers::Result.new(team_id, row) }
  let(:team_id) { '17' } # Green Bay
  let(:row) {
    r = %q{<tr>
      <td class="datacell">
        Saturday 08/09/14</td>
      <td class="datacell">
        @ <a href="/pageLoader/pageLoader.aspx?page=/data/nfl/teams/team10.html">Tennessee</a>
          </td>
      <td class="datacell">
        L <a href="/pageLoader/pageLoader.aspx?page=/data/nfl/results/2014-2015/boxscore42400.html">16-20</a>
          </td>
      <td class="datacell">
        Pre-Week 1</td>
      <td class="datacell">

                    L
                  2.5</td>
      <td class="datacell">

                U
              37.5</td>
    </tr>}
    Nokogiri::HTML(r)
  }

  describe '#parse' do
    before { subject.parse }

    it "creates the object" do
      subject.date.to_s.must_equal '2014-08-09'
      subject.home_team.must_equal 'Tennessee'
      subject.home_team_id.must_equal 10
      subject.away_team.must_equal 'Green Bay'
      subject.away_team_id.must_equal 17
      # subject.home_team_score.must_equal 20
      # subject.away_team_score.must_equal 16
      # subject.line.must_equal -2.5
      # subject.over_under.must_equal 37.5
    end
  end


end


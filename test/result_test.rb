require 'test_helper'

describe ScrapeCovers::Result do
  subject{ ScrapeCovers::Result.new(team, row) }
  let(:team) { ScrapeCovers::Team.create({covers_id: '17', name: 'Green Bay'}) }
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

  let(:overtime_row) {
    r = %q{<tr>
      <td></td>
      <td>@ <a href="/pageLoader/pageLoader.aspx?page=/data/nfl/teams/team10.html">Minnesota</a></td>
      <td class="datacell">
        L <a href="/pageLoader/pageLoader.aspx?page=/data/nfl/results/2013-2014/boxscore37757.html">26-29</a>
          <font color="#CC0000"> x</font></td>
      <td></td>
      <td></td>
      <td></td>
      </tr>}
    Nokogiri::HTML(r)
  }

  after { reset_db }

  describe '#parse' do
    it "creates the object" do
      subject.date.to_s.must_equal '2014-08-09'
      subject.home_team.must_equal 'Tennessee'
      subject.home_team_id.must_equal 10
      subject.away_team.must_equal 'Green Bay'
      subject.away_team_id.must_equal 17
      subject.home_team_score.must_equal 20
      subject.away_team_score.must_equal 16
      subject.line.must_equal -2.5
      subject.over_under.must_equal 37.5
    end

    describe "overtime result" do
      subject{ ScrapeCovers::Result.new(team, overtime_row) }

      it "overtime result" do
        subject.away_team_score.must_equal 26
        subject.home_team_score.must_equal 29
      end
    end

  end
end

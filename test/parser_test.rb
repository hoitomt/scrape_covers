require 'test_helper'

describe ScrapeCovers::Parser do
  let(:html_file) { File.read(File.join(FIXTURE_FILE_PATH, 'covers_test_page.html')) }
  let(:team) { ScrapeCovers::Team.create({covers_id: '17', name: 'Green Bay'}) }

  subject{ScrapeCovers::Parser.new(team, html_file)}

  after { reset_db }

  describe 'parse' do
    it 'returns an array of Result objects' do
      ScrapeCovers::Team.stub(:find_by_covers_id, team) do
        subject.parse.first.must_be_instance_of ScrapeCovers::Result
      end
    end
  end

end

require 'test_helper'

describe ScrapeCovers::Parser do
  let(:html_file){File.read(File.join(FIXTURE_FILE_PATH, 'covers_test_page.html'))}

  subject{ScrapeCovers::Parser.new(39, html_file)}

  describe 'parse' do
    it 'returns an array of Result objects' do
      subject.parse.first.must_be_instance_of ScrapeCovers::Result
    end
  end

end

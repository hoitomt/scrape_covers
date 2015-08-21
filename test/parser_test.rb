require 'test_helper'

describe ScrapeCovers::Parser do
  let(:html_file){File.read(File.join(FIXTURE_FILE_PATH, 'covers_test_page.html'))}

  subject{ScrapeCovers::Parser.new(html_file)}

  it 'exists' do
    subject.result_rows
  end
end

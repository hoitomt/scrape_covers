ENV['RACK_ENV'] = 'test'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'scrape_covers'

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/reporters'

require 'pry'

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(:color => true)]

FIXTURE_FILE_PATH = File.join(File.dirname(__FILE__), 'html_files')

require 'civicrm'

def test_file_path(filename)
  File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', filename))
end

RSpec.configure do |config|
  config.mock_with :mocha
end
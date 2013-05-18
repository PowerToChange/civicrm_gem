require 'civicrm'
require 'support/civicrm'
require 'support/civicrm_responses'
require 'support/test_matchers'

def test_file_path(filename)
  File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', filename))
end

RSpec.configure do |config|
  include CiviCrm::TestResponses
  config.mock_with :mocha
end
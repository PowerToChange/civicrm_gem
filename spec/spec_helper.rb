require 'civicrm'
require 'support/civicrm'
require 'support/civicrm_responses'
require 'support/test_matchers'
RSpec.configure do |config|
  include CiviCrm::TestResponses
  config.mock_with :mocha
end
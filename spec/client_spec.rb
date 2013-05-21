require 'spec_helper'

describe 'CiviCrm::Client' do
  describe '#build_opts' do
    CiviCrm.api_key = '123123'
    let(:params) { { :rowCount => 1, :offset => 8990 } }
    let(:expected_result) { {:method=>:get, :timeout=>80, :headers=>{:user_agent=>"CiviCrm RubyClient/1.0.1"}, :url=>"https://www.example.org/path/to/civi/codebase/civicrm/extern/rest.php?rowCount=1&offset=8990&json=1&api_key=123123"} }
    subject { CiviCrm::Client.send(:build_opts,:get, params) }
    it 'should return correct opts' do
      subject.should == expected_result
    end
  end
end
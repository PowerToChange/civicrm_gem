require 'spec_helper'

describe 'CiviCrm::Client' do

  describe '.request' do
    let(:client) { CiviCrm::Client }
    it 'should raise CiviCrm::Errors::Unauthorized if site_key is not provided' do
      CiviCrm.site_key = nil
      expect { client.request('get') }.to raise_error(CiviCrm::Errors::Unauthorized)
    end
    it 'should execute restclient requests' do
      CiviCrm.api_key = 'civicrm'
      CiviCrm.site_key = 'civicrm'
      RestClient::Request.expects(:execute).returns(OpenStruct.new(:body => '{}'))
      client.request(:get,{})
    end
  end

  describe '.build_opts' do
    let(:params) { { :rowCount => 1, :offset => 8990 } }
    let(:expected_result) { {:method=>:get, :timeout=>80, :headers=>{:user_agent=>"CiviCrm RubyClient/1.0.1"}, :url=>"https://www.example.org/path/to/civi/codebase/civicrm/extern/rest.php?rowCount=1&offset=8990&json=1&api_key=123123&key=123123"} }
    subject { CiviCrm::Client.send(:build_opts,:get, params) }
    it 'should return correct opts' do
      CiviCrm.api_key = '123123'
      CiviCrm.site_key = '123123'
      subject.should == expected_result
    end
  end
end
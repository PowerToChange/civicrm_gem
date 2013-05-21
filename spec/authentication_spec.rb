require 'spec_helper'

describe "Authentication" do

  let(:api_key) { [{'api_key' => '123123'}] }

  describe '.authenticate(name, password)' do
    subject { CiviCrm.authenticate("test", "test") }
    it "should call post request" do
      CiviCrm::Client.expects(:request).with(:post, q: 'civicrm/login', name: 'test', pass: 'test').returns(api_key)
      subject
    end
    it 'sets the global api_key' do
      CiviCrm::Client.stubs(:request).returns(api_key)
      subject
      CiviCrm.api_key.should == '123123'
    end
  end
end
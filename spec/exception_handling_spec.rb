require 'spec_helper'
require 'rest_client'
require 'ostruct'
describe "Exception handling" do
  let(:client) { CiviCrm::Client }
  subject { client.send(:execute,{}) }
  it "should raise CiviCrm::Errors::BadRequest on 400" do
    exception = RestClient::Exception.new(OpenStruct.new(code: 400, body: 'message'))
    RestClient::Request.stubs(:execute).raises(exception)
    expect { subject }.to raise_error(CiviCrm::Errors::BadRequest)
  end

  it "should raise CiviCrm::Errors::Unauthorized on 401" do
    exception = RestClient::Exception.new(OpenStruct.new(code: 401, body: 'message'))
    RestClient::Request.stubs(:execute).raises(exception)
    expect { subject }.to raise_error(CiviCrm::Errors::Unauthorized)
  end

  it "should raise CiviCrm::Errors::Forbidden on 403" do
    exception = RestClient::Exception.new(OpenStruct.new(code: 403, body: 'message'))
    RestClient::Request.stubs(:execute).raises(exception)
    expect { subject }.to raise_error(CiviCrm::Errors::Forbidden)
  end

  it "should raise CiviCrm::Errors::NotFound on 404" do
    exception = RestClient::Exception.new(OpenStruct.new(code: 404, body: 'message'))
    RestClient::Request.stubs(:execute).raises(exception)
    expect { subject }.to raise_error(CiviCrm::Errors::NotFound)
  end

  it "should raise CiviCrm::Errors::InternalError on 500" do
    exception = RestClient::Exception.new(OpenStruct.new(code: 500, body: 'message'))
    RestClient::Request.stubs(:execute).raises(exception)
    expect { subject }.to raise_error(CiviCrm::Errors::InternalError)
  end

  it "should raise CiviCrm::Errors::Unauthorized if site_key is not provided" do
    CiviCrm.site_key = nil
    expect { client.request('get') }.to raise_error(CiviCrm::Errors::Unauthorized)
  end
end
require 'spec_helper'
require 'rest_client'
require 'ostruct'
describe "API Bindings" do

  before :all do
    @client = authorized_civicrm_client
  end

  it "should not fetch from network while initializing a new Resource" do
    @client.expects(:get).never
    CiviCrm::Contact.new(id: "someid")
  end

  it "should run authentication" do
    @client.expects(:post).once.returns(test_response(api_key: 'test'))
    CiviCrm.authenticate("test", "test")
  end

  describe "exception handler" do

    before :all do
      @client = CiviCrm::Client
    end

    it "should raise CiviCrm::Errors::BadRequest on 400" do
      exception = RestClient::Exception.new(OpenStruct.new(code: 400, body: 'message'))
      RestClient::Request.stubs(:execute).raises(exception)
      expect { @client.execute!({}) }.to raise_error(CiviCrm::Errors::BadRequest)
    end

    it "should raise CiviCrm::Errors::Unauthorized on 401" do
      exception = RestClient::Exception.new(OpenStruct.new(code: 401, body: 'message'))
      RestClient::Request.stubs(:execute).raises(exception)
      expect { @client.execute!({}) }.to raise_error(CiviCrm::Errors::Unauthorized)
    end

    it "should raise CiviCrm::Errors::Forbidden on 403" do
      exception = RestClient::Exception.new(OpenStruct.new(code: 403, body: 'message'))
      RestClient::Request.stubs(:execute).raises(exception)
      expect { @client.execute!({}) }.to raise_error(CiviCrm::Errors::Forbidden)
    end

    it "should raise CiviCrm::Errors::NotFound on 404" do
      exception = RestClient::Exception.new(OpenStruct.new(code: 404, body: 'message'))
      RestClient::Request.stubs(:execute).raises(exception)
      expect { @client.execute!({}) }.to raise_error(CiviCrm::Errors::NotFound)
    end

    it "should raise CiviCrm::Errors::InternalError on 500" do
      exception = RestClient::Exception.new(OpenStruct.new(code: 500, body: 'message'))
      RestClient::Request.stubs(:execute).raises(exception)
      expect { @client.execute!({}) }.to raise_error(CiviCrm::Errors::InternalError)
    end

    it "should raise CiviCrm::Errors::Unauthorized if site_key is not provided" do
      CiviCrm.site_key = nil
      RestClient::Request.stubs(:execute).returns('test')
      expect { @client.request('get', 'test') }.to raise_error(CiviCrm::Errors::Unauthorized)
    end
  end
end
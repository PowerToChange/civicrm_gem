RSpec::Matchers.define :be_listable_resource do |expected|
  match do |actual|
    client = authorized_civicrm_client
    subject = actual.class
    test_response_hash = send(:"test_#{subject.name.demodulize.underscore}_array")

    client.expects(:get).once.returns(test_response(test_response_hash))
    c = subject.all

    c.should be_a_kind_of(Array)
  end
end
RSpec::Matchers.define :be_updatable_resource do |expected|
  match do |actual|
    client = authorized_civicrm_client
    subject = actual.class

    client.expects(:get).once.returns(test_response(test_contact({name: "foo"})))
    client.expects(:put).once.returns(test_response(test_contact({name: "bar"})))
    c = subject.find("resource_id")
    c.name.should == "foo"
    c.name = "bar"
    c.save
    c.name.should == "bar"
  end
end
RSpec::Matchers.define :be_deleteable_resource do |expected|
  match do |actual|
    client = authorized_civicrm_client
    subject = actual.class

    client.expects(:get).once.returns(test_response(test_contact({name: "foo"})))
    client.expects(:delete).once.returns(test_response(test_contact({name: "bar"})))
    c = subject.find("resource_id")
    c.delete
  end
end
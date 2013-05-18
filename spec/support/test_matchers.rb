# Custom Rspec matchers

RSpec::Matchers.define :be_listable_resource do |expected|
  match do |actual|
    subject = actual.class
    test_response_hash = expected
    client.expects(:get).once.returns(test_response(test_response_hash))
    c = subject.all
    c.should be_a_kind_of(Array)
  end
end
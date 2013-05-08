require 'spec_helper'
describe CiviCrm::Contact do
  it { should be_listable_resource }
  #it { should be_updatable_resource }

  it "should return contact on create" do
    client = authorized_civicrm_client

    client.expects(:post).once.returns(test_response(test_contact))
    c = CiviCrm::Contact.create
    c.should be_a_kind_of(CiviCrm::Contact)
  end
end
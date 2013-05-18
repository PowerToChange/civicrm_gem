require 'spec_helper'
describe CiviCrm::Contact do
  let(:contact) { File.read(test_file_path('contact/create.json')) }
  let(:contact_list) { File.read(test_file_path('contact/list.json')) }
  let(:client) { authorized_civicrm_client }

  it { should be_listable_resource(contact_list) }
  it "should return contact on create" do
    client.expects(:post).once.returns(test_response(contact))
    c = CiviCrm::Contact.create
    c.should be_a_kind_of(CiviCrm::Contact)
  end
end
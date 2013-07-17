require 'spec_helper'

class AssociationTestActivity < CiviCrm::BaseResource
  entity :activity
end

class AssociationTestContact < CiviCrm::BaseResource
  entity :contact
  has_many :association_test_activities, foreign_key: :contact_id, class_name: 'AssociationTestActivity'
end

describe 'associations' do

  before do
    CiviCrm.api_key = 'civicrm'
    CiviCrm.site_key = 'civicrm'
    CiviCrm::Client.stubs(:request).returns([{}])
  end

  describe 'has_many' do
    it 'defines method' do
      AssociationTestContact.new(name: 'Associated').should respond_to(:association_test_activities)
    end
  end

end
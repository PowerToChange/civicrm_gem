require 'spec_helper'
require 'ostruct'
class TestContact < CiviCrm::BaseResource
  entity :contact
end

describe 'resourceful' do

  before do
    CiviCrm.api_key = 'civicrm'
    CiviCrm.site_key = 'civicrm'
    CiviCrm::Client.stubs(:request).returns([{}])
  end

  describe '.entity' do
    it 'sets entity_class_name' do
      TestContact.entity_class_name.should == 'Contact'
    end
  end

  describe '#initialize' do
    subject { TestContact.new({id: 123, 'email' => 'test@gmail.com'}) }
    it 'returns contact instance with attributes' do
      subject.id.should == 123
    end
  end

  describe '.build_from' do
    subject { CiviCrm::Resource.build_from(response, {'entity' => 'Contact'}) }
    context 'when response is an Array of hashes' do
      let(:response) { [{:name => 'Adrian'},{:name => 'Sheldon'}] }
      it 'returns an Array' do
        subject.should be_a_kind_of(Array)
      end
      it 'returns an Array of resource objects' do
        subject.first.should be_a_kind_of(CiviCrm::Resource)
      end
    end
    context 'when response is a hash' do
      let(:response) { {:name => 'Adrian'} }
      it 'returns a resource object' do
        subject.should be_a_kind_of(CiviCrm::Resource)
      end
    end
    context 'when response is a string' do
      let(:response) { "Some string response" }
      it 'returns a string' do
        subject.should == "Some string response"
      end
    end
    context 'when has attributes that can be built' do
      let(:response) do
        [
          { :name => 'Adrian' },
          { :name => 'Sheldon', :test_contacts => [ {:name => 'Batman'}, {:name => 'Darth Vader'} ] }
        ]
      end
      it 'builds the attribute containing buildable entities' do
        subject.last.test_contacts.should be_present
      end
      it 'builds the attribute with the correct class' do
        subject.last.test_contacts.each do |test_contact|
          test_contact.should be_a_kind_of(TestContact)
        end
      end
    end
  end

  describe '.create' do
    it 'should respond to create' do
      TestContact.should respond_to(:create)
    end
    it 'should return a contact' do
      c = TestContact.create
      c.should be_a_kind_of(TestContact)
    end
  end

  context 'listable' do
    context 'enumerable' do
      let(:contacts) { [TestContact.new(:name => 'Adrian'), TestContact.new(:name => 'John')] }
      before do
        TestContact.stubs(:all).returns(contacts)
      end
    end
  end

  describe '.find' do
    it 'should respond to find' do
      TestContact.should respond_to(:find)
    end
    it 'should return a contact' do
      c = TestContact.find(1)
      c.should be_a_kind_of(TestContact)
    end
  end

  describe '.where' do
    it 'should respond to where' do
      TestContact.should respond_to(:where)
    end
    it 'should return a relation' do
      TestContact.where(id: 1).should be_a_kind_of(CiviCrm::Actions::Relation)
    end
  end

  describe '.includes' do
    it 'should respond to includes' do
      TestContact.should respond_to(:includes)
    end
    it 'should return a relation' do
      TestContact.includes(:notes).should be_a_kind_of(CiviCrm::Actions::Relation)
    end
  end

  describe '#delete' do
    let(:contact) { TestContact.new }
    it 'should respond to delete' do
      contact.should respond_to(:delete)
    end
  end

  describe '#update' do
    let(:contact) { TestContact.new }
    it 'should respond to update' do
      contact.should respond_to(:update)
    end
  end

  describe '#save' do
    subject { contact.save }
    context 'when new record' do
      before do
        TestContact.stubs(:create).returns(OpenStruct.new(id: 123))
      end
      let(:contact) { TestContact.new(email: 'adrian@gmail.com') }
      it 'should respond to save' do
        contact.should respond_to(:save)
      end
      it 'should return TestContact with id' do
        subject.id.should_not be_nil
      end
    end
    context 'when existing record' do
      let(:contact) { TestContact.new(id: 123, email: 'adrian@gmail.com') }
      it 'should return TestContact with updated email' do
        contact.email = 'kingkong@gmail.com'
        subject.email.should == 'kingkong@gmail.com'
      end
    end
  end

  describe '#build_url' do
    subject { TestContact.build_url({ lightsaber: 'blue' }) }

    it 'should return a String' do
      subject.should be_a(String)
    end
  end

end
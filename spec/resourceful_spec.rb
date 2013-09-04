require 'spec_helper'
require 'ostruct'

class TestContact < CiviCrm::BaseResource
  entity :contact

  before_save :call_me_back
  after_save :call_me_back
  def call_me_back
  end
end

describe 'resourceful' do

  before do
    CiviCrm.api_key = 'civicrm'
    CiviCrm.site_key = 'civicrm'
    CiviCrm::Client.stubs(:request).returns([{}])
  end

  describe 'entity' do
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

  describe '#refresh_from' do
    let(:contact) { TestContact.new({id: 123, 'email' => 'test@gmail.com'}) }
    let(:params) { { id: 321, email: 'test@ballistiq.com' } }
    subject { contact.refresh_from(params) }

    it 'should update the attributes' do
      subject.email.should eq 'test@ballistiq.com'
      subject.id.should eq 321
    end
    it 'should return self' do
      subject.should be_a TestContact
    end
  end

  describe '::build_from' do
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

  describe '::create' do
    it 'should respond to create' do
      TestContact.should respond_to(:create)
    end
    it 'should return a contact' do
      c = TestContact.create
      c.should be_a_kind_of(TestContact)
    end
  end

  describe '::update' do
    it 'should respond to update' do
      TestContact.should respond_to(:update)
    end
    it 'should return a contact' do
      c = TestContact.update(id: 1234)
      c.should be_a_kind_of(TestContact)
    end
    it 'should return false if id is not given' do
      TestContact.update.should be_false
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

  describe '::find' do
    it 'should respond to find' do
      TestContact.should respond_to(:find)
    end
    it 'should return a contact' do
      c = TestContact.find(1)
      c.should be_a_kind_of(TestContact)
    end
  end

  describe '::where' do
    it 'should respond to where' do
      TestContact.should respond_to(:where)
    end
    it 'should return a relation' do
      TestContact.where(id: 1).should be_a_kind_of(CiviCrm::Actions::Relation)
    end
  end

  describe '::includes' do
    it 'should respond to includes' do
      TestContact.should respond_to(:includes)
    end
    it 'should return a relation' do
      TestContact.includes(:notes).should be_a_kind_of(CiviCrm::Actions::Relation)
    end
  end

  describe '#persisted?' do
    subject { TestContact.new(params) }
    let(:params) { { first_name: 'Dude' } }

    it 'should respond to persisted?' do
      subject.should respond_to(:persisted?)
    end
    it 'should not be persisted if is a new record' do
      subject.persisted?.should be_false
    end

    context 'has id' do
      let(:params) { { id: 485329 } }
      it 'should be persisted if has id' do
        subject.persisted?.should be_true
      end
    end

    context 'does not have id' do
      let(:params) { { id: nil } }
      it 'should not be persisted if does not have id' do
        subject.persisted?.should be_false
      end
    end
  end

  describe 'delete' do
    let(:contact) { TestContact.new(id: 35433) }
    before { CiviCrm::Client.expects(:request).with(:post, 'id' => contact.id, 'entity' => 'Contact', 'action' => 'delete').returns([{ is_error: 0 }]) }

    context '::delete' do
      it 'should make delete request to client' do
        TestContact.delete('id' => contact.id)
      end
    end

    context '#delete' do
      it 'should make delete request to client' do
        contact.delete
      end
      it 'should return true for success' do
        contact.delete.should be_true
      end
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
        TestContact.stubs(:create).returns(TestContact.new(id: 123))
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

    describe 'callbacks' do
      let(:contact) { TestContact.new(id: 123, email: 'adrian@gmail.com') }

      it 'should call before and after callbacks' do
        TestContact.any_instance.expects(:call_me_back).twice
        subject
      end
    end
  end

  describe '#build_url' do
    subject { TestContact.build_url({ lightsaber: 'blue' }) }

    it 'should return a String' do
      subject.should be_a(String)
    end
  end

  describe '#initialize_attribute' do
    subject { TestContact.new.send(:initialize_attribute, attribute, value) }

    context 'time' do
      let(:attribute) { 'some_date_time_attribute' }
      let(:value) { '2013-08-12 20:24:40' }
      it 'should return a time object' do
        subject.should be_a Time
      end
    end

    context 'date' do
      let(:attribute) { 'some_date_attribute' }
      let(:value) { '2013-08-12' }
      it 'should return a date object' do
        subject.should be_a Date
      end
    end

    context 'attribute that does not require initialization' do
      let(:attribute) { 'hair_style' }
      let(:value) { 'long and black' }
      it 'should return the value' do
        subject.should eq value
      end
    end
  end

  describe 'attributes initializers' do
    before { CiviCrm.time_zone = ActiveSupport::TimeZone['Mountain Time (US & Canada)'] }

    context '#initialize_time_attribute' do
      subject { TestContact.initialize_time_attribute('2013-08-12 20:24:40') }

      it 'should return a Time object' do
        subject.should be_a(Time)
      end
      it 'should return the correct time' do
        subject.hour.should eq 2
        subject.min.should eq 24
        subject.sec.should eq 40
        subject.day.should eq 13
        subject.year.should eq 2013
        subject.month.should eq 8
      end
    end

    context '#initialize_date_attribute' do
      subject { TestContact.initialize_date_attribute('2013-08-12') }

      it 'should return a Date object' do
        subject.should be_a(Date)
      end
      it 'should return the correct date' do
        subject.day.should eq 12
        subject.year.should eq 2013
        subject.month.should eq 8
      end
    end
  end

end
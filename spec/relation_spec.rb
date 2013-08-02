require 'spec_helper'

class TestContact < CiviCrm::BaseResource
  entity :contact
end

describe 'relation' do

  let(:relation) { TestContact.where(id: 1) }

  before do
    CiviCrm.api_key = 'civicrm'
    CiviCrm.site_key = 'civicrm'
    CiviCrm::Client.stubs(:request).returns([{}])
  end

  describe 'chaining' do
    subject { relation.where(id: 1).includes(:whip).where(hat: 'fedora').includes(:horse, :holy_grail).where(nazis: false, sidekicks: true) }
    it 'should setup the where_params' do
      subject.where_params.should eq({ id: 1, hat: 'fedora', nazis: false, sidekicks: true })
    end
    it 'should setup the includes_entities' do
      subject.includes_entities.should eq([:whip, :horse, :holy_grail])
    end
    it 'should overwrite previous param if sent again' do
      subject.where(id: 2).where_params[:id].should eq 2
    end
  end

  describe '#initialize' do
    subject { relation.where(id: 1).includes(:notes) }
    it 'returns contact instance with where params' do
      subject.where_params[:id].should == 1
    end
    it 'returns contact instance with includes' do
      subject.includes_entities.should == [:notes]
    end
  end

  describe '.where' do
    subject { relation.where(id: 1, first_name: 'Indiana').where(last_name: 'Jones') }
    it 'should respond to where' do
      relation.should respond_to(:where)
    end
    it 'adds the where params to the relation' do
      subject.where_params.should eq({ id: 1, first_name: 'Indiana', last_name: 'Jones' })
    end
    it 'returns a relation' do
      subject.should be_a_kind_of(CiviCrm::Actions::Relation)
    end
  end

  describe '.includes' do
    subject { relation.includes(:whip).includes(:treasure, :artifacts) }
    it 'should respond to includes' do
      relation.should respond_to(:includes)
    end
    it 'adds the include entities to the relation' do
      subject.includes_entities.should eq([:whip, :treasure, :artifacts])
    end
    it 'returns a relation' do
      subject.should be_a_kind_of(CiviCrm::Actions::Relation)
    end
  end

  describe '.find' do
    subject { relation.find(1) }
    it 'should respond to find' do
      relation.should respond_to(:find)
    end
    it 'should return a contact' do
      subject.should be_a_kind_of(TestContact)
    end
  end

  describe '.all' do
    subject { relation.all }
    it 'should respond to all' do
      relation.should respond_to(:all)
    end
    it 'should return an array' do
      subject.should be_a_kind_of(Array)
    end
    it 'should return some contacts' do
      subject.should be_present
    end
  end

  describe '.first' do
    subject { relation.first }
    it 'should respond to first' do
      relation.should respond_to(:first)
    end
    it 'should return a contact' do
      subject.should be_a_kind_of(TestContact)
    end
  end

  describe '.count' do
    subject { relation.count }
    it 'should respond to count' do
      relation.should respond_to(:count)
    end
    it 'should return an integer' do
      subject.should be_a_kind_of(Integer)
    end
  end

end
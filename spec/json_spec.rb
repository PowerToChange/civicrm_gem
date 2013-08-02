require 'spec_helper'

describe 'CiviCrm::JSON' do
  describe '#parse' do
    let(:activities) { File.read(test_file_path('activity/list.json')) }
    subject { CiviCrm::JSON.parse(activities) }
    it 'should return an array' do
      subject.should be_a_kind_of(Array)
    end
    it 'should return 10 results' do
      subject.size.should > 0
    end
    it 'should return an array of hashes' do
      subject.first.should be_a_kind_of(Hash)
    end
    it 'should return with target_contact_id' do
      subject.collect{|a| a['target_contact_id'].first}.should == [nil, "32376", "32377", "32379", "32378", "32380", "32381", "32382", "32383", "32384"]
    end
    it 'should parse chained attributes' do
      subject.first['contacts'].should be_present
      subject.first['contacts'].should be_a_kind_of(Array)
    end
    it 'should parse attributes of entities returned in chained request' do
      subject.first['contacts'].first['contact_id'].should eq '1'
    end
    it 'should replace returned chained attribute with a new one' do
      subject.first["api.Contact.get"].should_not be_present
      subject.first["contacts"].should be_present
    end
  end
end
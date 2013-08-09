require 'spec_helper'

describe 'CiviCrm::Cache' do

  describe 'Store' do
    describe 'initialization' do
      it 'should initialize the cache store' do
        CiviCrm.cache.store.should be_present
        CiviCrm.cache.store.should be_a Dalli::Client
      end

      it 'should initialize the cache config' do
        CiviCrm.cache.config.should be_present
        CiviCrm.cache.config.should be_a CiviCrm::Cache::Config
      end
    end

    describe '#cache_request?' do
      before { CiviCrm.cache.config.cache_all_requests_for_entity('OptionValue', expires_in: 1.day) }

      http_methods_that_are_not_get = ['put', 'post', 'patch', 'head', 'delete', 'wut', :batman]

      context 'http method' do
        before { CiviCrm::Cache::Config.any_instance.stubs(:caches_request_for_entity?).returns(true) }

        it 'should only cache get requests' do
          ['get', :get, 'Get', 'GET', 'geT'].each do |method|
            CiviCrm.cache_request?(method, {}).should be_true
          end
          http_methods_that_are_not_get.each do |method|
            CiviCrm.cache_request?(method, {}).should be_false
          end
        end
      end

      it 'should only cache requests for OptionValue' do
        CiviCrm.cache_request?('get', { 'entity' => 'OptionValue' }).should be_true
        CiviCrm.cache_request?('get', { 'entity' => 'Contact' }).should be_false
      end

      it 'should not cache non-get requests to cacheable entities' do
        http_methods_that_are_not_get.each do |method|
          CiviCrm.cache_request?(method, { 'entity' => 'OptionValue' }).should be_false
        end
      end
    end
  end

  describe 'Helpers' do
    describe '#request_cache_key' do
      let(:correct_key) { "array:1:2:3-batman:Robin-one:1-subhash:{a:a-b:{}-c:}-x:X" }

      it 'should return a string' do
        subject.should be_a String
      end
      it 'should construct the key' do
        CiviCrm.cache.config.request_cache_key({ x: 'X', 'Batman' => 'Robin', one: 1, subhash: { b: {}, a: 'a', c: nil }, array: [1,2,3] }).should eq correct_key
      end
      it 'should ignore the order of the hash' do
        CiviCrm.cache.config.request_cache_key({ 'Batman' => 'Robin', subhash: { c: nil, a: 'a', b: {} }, array: [1,2,3], one: 1, x: 'X' }).should eq correct_key
      end
      it 'should ignore case on the keys' do
        CiviCrm.cache.config.request_cache_key({ 'BATMAN' => 'Robin', 'SubHash' => { c: nil, a: 'a', b: {} }, array: [1,2,3], 'onE' => 1, x: 'X' }).should eq correct_key
      end
      it 'should NOT ignore case on the values' do
        CiviCrm.cache.config.request_cache_key({ 'BATMAN' => 'robin', 'SubHash' => { c: nil, a: 'a', b: {} }, array: [1,2,3], 'onE' => 1, x: 'x' }).should_not eq correct_key
      end
      it 'should treat the hash with key indifference' do
        CiviCrm.cache.config.request_cache_key({ batman: 'Robin', 'SubHash' => { 'c' => nil, a: 'a', b: {} }, 'array' => [1,2,3], 'onE' => 1, x: 'X' }).should eq correct_key
      end
      it 'should ignore the difference between numbers and strings' do
        CiviCrm.cache.config.request_cache_key({ x: 'X', 'Batman' => 'Robin', one: '1', subhash: { b: {}, a: 'a', c: nil }, array: ['1',2,'3'] }).should eq correct_key
      end
    end

    describe '#request_cache_expires_in' do
      before { CiviCrm.cache.config.cache_all_requests_for_entity('OptionValue', expires_in: 1.day) }

      it 'should return the expires_in value for given entity' do
        CiviCrm.cache.config.request_cache_expires_in({ 'entity' => 'OptionValue' }).should eq 1.day
      end
      it 'should return zero if the entity does not cache' do
        CiviCrm.cache.config.request_cache_expires_in({ 'entity' => 'Contact' }).should eq 0
      end
    end
  end

  describe 'Config' do
    describe '#caches_request_for_entity?' do
      before { CiviCrm.cache.config.cache_all_requests_for_entity('OptionValue', expires_in: 1.day) }

      it 'should return true if the entity has been configured' do
        CiviCrm.cache.config.caches_request_for_entity?('OptionValue').should be_true
      end
      it 'should return false if the entity has not been configured' do
        CiviCrm.cache.config.caches_request_for_entity?('Contact').should be_false
      end
      it 'should handle symbols' do
        CiviCrm.cache.config.caches_request_for_entity?(:option_value).should be_true
      end
    end

    describe '#cache_all_requests_for_entity' do
      it 'should set the given options' do
        CiviCrm.cache.config.cache_all_requests_for_entity('OptionValue', expires_in: 1.day).should be_true
      end
    end

    describe '#entity_expires_in' do
      before { CiviCrm.cache.config.cache_all_requests_for_entity('OptionValue', expires_in: 1.day) }

      it 'should return the correct expires_in' do
        CiviCrm.cache.config.entity_expires_in('OptionValue').should eq 1.day
      end
      it 'should return 0 if the entity is not cached' do
        CiviCrm.cache.config.entity_expires_in('Contact').should eq 0
      end
    end
  end


end
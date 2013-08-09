module CiviCrm
  module Cache
    module Store
      require 'ostruct'

      @@cache_store = Dalli::Client.new('localhost:11211', { namespace: 'civicrm', compress: true })
      @@cache_config = CiviCrm::Cache::Config.new
      @@cache = OpenStruct.new(store: @@cache_store, config: @@cache_config)

      def cache
        @@cache
      end

      def cache_request?(method, params)
        method.to_s.downcase == 'get' && CiviCrm.cache.config.caches_request_for_entity?(params['entity'])
      end
    end
  end
end

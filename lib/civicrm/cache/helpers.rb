module CiviCrm
  module Cache
    module Helpers

      def hash_to_key(hash)
        hash.sort_by { |key, _| key.to_s }.collect { |p| p.join(':') }.join('-').downcase
      end

      def request_cache_key(params)
        hash_to_key(params)
      end

      def request_cache_expires_in(params)
        CiviCrm.cache.config.entity_expires_in(params['entity'])
      end
    end
  end
end
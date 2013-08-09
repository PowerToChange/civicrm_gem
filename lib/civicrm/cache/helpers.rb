module CiviCrm
  module Cache
    module Helpers

      def request_cache_key(params)
        hash_to_key(params)
      end

      def request_cache_expires_in(params)
        CiviCrm.cache.config.entity_expires_in(params['entity'])
      end

      private

      def hash_to_key(hash)
        hash.each do |key, value|
          hash[key] = "{#{ hash_to_key(value) }}" if value.is_a?(Hash)
        end

        hash.transform_keys { |key| key.to_s.downcase }.sort_by { |key, _| key.to_s }.collect { |p| p.join(':') }.join('-')
      end

    end
  end
end
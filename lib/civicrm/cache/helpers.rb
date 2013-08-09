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

        Hash[hash.map {|k, v| [k.to_s.downcase, v] }].sort_by { |k, _| k.to_s }.collect { |p| p.join(':') }.join('-')
      end

    end
  end
end
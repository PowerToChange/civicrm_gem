module CiviCrm
  module Cache
    class Config
      include CiviCrm::Cache::Helpers

      def initialize
        @entity_cache_rules = {}
      end

      def caches_request_for_entity?(entity)
        @entity_cache_rules[entity.to_s.camelize].present?
      end

      def cache_all_requests_for_entity(entity, options)
        @entity_cache_rules[entity.to_s.camelize] = options
      end

      def entity_expires_in(entity)
        return 0 unless caches_request_for_entity?(entity)
        @entity_cache_rules[entity.to_s.camelize][:expires_in]
      end
    end
  end
end
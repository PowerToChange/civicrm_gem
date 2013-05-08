module CiviCrm
  module Actions
    module Create
      module ClassMethods
        def create(attrs = {})
          params = {'entity' => entity_class_name, 'action' => 'create'}
          response = CiviCrm::Client.request(:post, params.merge(attrs))
          Resource.build_from(response.first, params)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
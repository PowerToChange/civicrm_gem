module CiviCrm
  module Actions
    module Find
      module ClassMethods
        def where(params = {})
          params.merge!('entity' => entity_class_name, 'action' => 'get')
          build_response(params)
        end

        def find(id)
          params = {'entity' => entity_class_name, 'action' => 'getsingle', 'id' => id, 'rowCount' => 1}
          build_response(params).first
        end

        private

        def build_response(params)
          response = CiviCrm::Client.request(:get, params)
          Resource.build_from(response, params)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
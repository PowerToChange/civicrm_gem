module CiviCrm
  module Actions
    module Find
      module ClassMethods

        def where(params)
          CiviCrm::Actions::Relation.new(self).where(params)
        end

        def includes(*args)
          CiviCrm::Actions::Relation.new(self).includes(*args)
        end

        def find(id)
          CiviCrm::Actions::Relation.new(self).find(id)
        end

        def build_response(params = {})
          params.merge!('entity' => self.entity_class_name)
          params['action'] ||= 'get'
          response = CiviCrm::Client.request(:get, params)
          self.build_from(response, params)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
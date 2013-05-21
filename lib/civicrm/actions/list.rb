module CiviCrm
  module Actions
    module List
      module ClassMethods
        def all
          Resource.build_from(response, params)
        end

        def count
          all.count
        end

        def first
          all.first
        end

        def last
          all.last
        end

        private

        def params
          {'entity' => entity_class_name, 'action' => 'get'}
        end

        def response
          CiviCrm::Client.request(:get, params)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
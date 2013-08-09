module CiviCrm
  module Actions
    module Update
      extend ActiveSupport::Concern

      def update
        return false unless self.valid?

        params = {'entity' => self.class.entity_class_name, 'action' => 'create'}
        response = CiviCrm::Client.request(:post, params.merge(self.attributes))
        refresh_from(response.first)
        self
      end

      module ClassMethods
        def update(attrs = {})
          return false unless attrs['id'].present? || attrs[:id].present?
          self.create(attrs)
        end
      end
    end
  end
end
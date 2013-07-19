module CiviCrm
  module Actions
    module Update
      extend ActiveSupport::Concern

      def update
        return false unless self.valid?

        params = {'entity' => self.class.entity_class_name, 'action' => 'update', 'id' => id}
        response = CiviCrm::Client.request(:post, params.merge(self.attributes))
        refresh_from(response.first)
        self
      end
    end
  end
end
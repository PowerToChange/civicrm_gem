module CiviCrm
  module Actions
    module Destroy
      def delete
        params = {'entity' => self.class.entity_class_name, 'action' => 'delete', 'id' => id}
        response = CiviCrm::Client.request(:post, params)
        refresh_from(response.first.to_hash)
      end
    end
  end
end
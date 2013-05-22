module CiviCrm
  module Actions
    module Destroy
      def delete
        params = {'entity' => self.class.entity_class_name, 'action' => 'delete', 'id' => id}
        response = CiviCrm::Client.request(:post, params)
        response[:is_error] == 0
      end
    end
  end
end
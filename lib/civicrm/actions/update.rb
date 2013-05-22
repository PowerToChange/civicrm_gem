module CiviCrm
  module Actions
    module Update
      def update(attrs = {})
        params = {'entity' => self.class.entity_class_name, 'action' => 'update', 'id' => id}
        new_attrs = attributes.merge(attrs)
        response = CiviCrm::Client.request(:post, params.merge(values: new_attrs))
        refresh_from(response.first)
        self
      end
    end
  end
end
module CiviCrm
  module Actions
    module Update
      # TODO: this method doesn't work yet
      def update(attrs = {})
        params = {'entity' => self.class.entity_class_name, 'action' => 'replace', 'id' => id}
        new_attrs = attributes.merge(attrs)
        response = CiviCrm::Client.request(:post, params.merge(values: new_attrs))
        refresh_from(response.first.to_hash)
      end

      def save
        @previously_changed = changes
        @changed_attributes.clear
        update()
      end
    end
  end
end
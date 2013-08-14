module CiviCrm
  module Actions
    module Create
      extend ActiveSupport::Concern

      module ClassMethods
        def create(attrs = {})
          new_me = self.new(attrs)
          return false unless new_me.valid?

          params = {'entity' => entity_class_name, 'action' => 'create'}
          response = CiviCrm::Client.request(:post, params.merge(new_me.attributes))
          self.build_from(response, params).first
        end
      end
    end
  end
end
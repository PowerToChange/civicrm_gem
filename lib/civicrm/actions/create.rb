module CiviCrm
  module Actions
    module Create
      extend ActiveSupport::Concern

      module ClassMethods
        def create(attrs = {})
          return false unless self.new(attrs).valid?
          params = {'entity' => entity_class_name, 'action' => 'create'}
          response = CiviCrm::Client.request(:post, params.merge(attrs))
          self.build_from(response, params).first
        end
      end

    end
  end
end
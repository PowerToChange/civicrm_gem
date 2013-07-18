module CiviCrm
  module Actions
    module Create
      extend ActiveSupport::Concern
      include ActiveModel::Validations

      module ClassMethods
        def create(attrs = {})
          self.new(attrs).create
        end
      end

      private

      def create
        return false unless self.valid?

        params = {'entity' => entity_class_name, 'action' => 'create'}
        response = CiviCrm::Client.request(:post, params.merge(attrs))
        self.class.build_from(response, params).first
      end

    end
  end
end
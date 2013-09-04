module CiviCrm
  module Actions
    module Destroy

      def delete
        self.class.delete({'id' => id})
      end

      module ClassMethods
        def delete(params)
          params.merge!({'entity' => self.entity_class_name, 'action' => 'delete'})
          response = CiviCrm::Client.request(:post, params)
          response.try(:first).try(:[], :is_error).present? && response.first[:is_error].to_i == 0
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

    end
  end
end
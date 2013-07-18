module CiviCrm
  module Actions
    module Saveable
      include CiviCrm::Actions::Create
      include CiviCrm::Actions::Update
      extend ActiveSupport::Concern

      def save
        begin
          if self.id.present?
            response = self.update
          else
            response = self.class.create(self.attributes)
          end
        rescue => e
          puts e
          return false
        end
      end

    end
  end
end
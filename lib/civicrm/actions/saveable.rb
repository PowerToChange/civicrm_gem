module CiviCrm
  module Actions
    module Saveable
      extend ActiveSupport::Concern

      included do
        include CiviCrm::Actions::Create
        include CiviCrm::Actions::Update
        include ActiveSupport::Callbacks

        define_callbacks :save
      end

      def save
        begin
          run_callbacks :save do
            if self.id.present?
              self.update
            else
              self.class.create(self.attributes)
            end
          end
        rescue => e
          puts e
          return false
        end
      end

      module ClassMethods
        def before_save(*args)
          args.each do |arg|
            set_callback :save, :before, arg
          end
        end

        def after_save(*args)
          args.each do |arg|
            set_callback :save, :after, arg
          end
        end
      end

    end
  end
end
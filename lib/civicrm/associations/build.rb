module CiviCrm
  module Associations
    module Build
      extend ActiveSupport::Concern

      included do

        def self.has_many(association_name, options = {})
          begin
            association_class = options[:class_name] || "CiviCrm::#{ ActiveSupport::Inflector.camelize(ActiveSupport::Inflector.singularize(association_name)) }"
            association_class = association_class.constantize
            raise "Invalid CiviCrm association" unless association_class.respond_to?(:where)
          rescue
            puts "FAILS"
            return false
          end

          id_name = options[:foreign_key] || 'id'
          params = options[:with] || {}

          define_method association_name do
            unless instance_variable_get("@#{association_name}")
              instance_variable_set "@#{association_name}", association_class.where({ id_name => self.id }.merge(params))
            end
            instance_variable_get("@#{association_name}")
          end
          true
        end

        def self.belongs_to(association_name, options = {})
          begin
            association_class = options[:class_name] || "CiviCrm::#{ ActiveSupport::Inflector.camelize(association_name) }"
            association_class = association_class.constantize
            raise "Invalid CiviCrm association" unless association_class.respond_to?(:where)
          rescue
            return false
          end

          id_name = options[:foreign_key] || 'id'
          params = options[:with] || {}

          define_method association_name do
            unless instance_variable_get("@#{association_name}")
              instance_variable_set "@#{association_name}", association_class.where({ id_name => self.id, 'rowCount' => 1 }.merge(params)).first
            end
            instance_variable_get("@#{association_name}")
          end
          true
        end

      end
    end
  end
end
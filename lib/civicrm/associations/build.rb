module CiviCrm
  module Associations
    module Build
      extend ActiveSupport::Concern

      module ClassMethods
        def has_many(association_name, options = {})
          association_class = options[:class_name] || "CiviCrm::#{ ActiveSupport::Inflector.camelize(ActiveSupport::Inflector.singularize(association_name)) }"
          id_name = options[:foreign_key] || 'id'
          params = options[:with] || {}

          define_method association_name do
            unless instance_variable_get("@#{association_name}")
              instance_variable_set "@#{association_name}", association_class.constantize.where({ id_name => self.id }.merge(params))
            end
            instance_variable_get("@#{association_name}")
          end
        end
      end

    end
  end
end
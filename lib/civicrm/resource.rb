require 'active_model/dirty'

module CiviCrm
  class Resource
    class_attribute :entity_name

    def initialize(values = {})
      values = values.with_indifferent_access
      @values = {}.with_indifferent_access
      refresh_from(values)
    end

    # we will use this method for creating nested resources
    def refresh_from(values)
      values.each do |key, value|
        initialize_attribute(key, value)
      end
      self
    end

    def method_missing(name, *opts)
      if name[-1] == '='
        name = name.to_s.gsub(/\=$/, '')
        send(:"#{name}_will_change!")
        @values[name.to_s] = opts.first if @values.has_key?(name.to_s)
      else
        @values[name.to_s] if @values.has_key?(name.to_s)
      end
    end

    def to_hash
      @values
    end

    def attributes
      to_hash.reject{ |k, v| v.is_a? (CiviCrm::Resource)}
    end

    private

    # Do additional initialization on specific types of attributes
    def initialize_attribute(attribute, value)
      if value.is_a?(String)
        @values[attribute] = case attribute
        when /time/
          self.class.initialize_time_attribute(value)
        when /date/
          self.class.initialize_date_attribute(value)
        else
          value
        end
      else
        @values[attribute] = value
      end
    end

    class << self
      def entity(name = nil)
        self.entity_name = name
      end

      def entity_class_name
        self.entity_name.to_s.camelize
      end

      def build_from(resp, request_params = {})
        entity = request_params['entity']
        case resp
        when Array
          resp.map { |values| build_from(values, request_params) }
        when Hash
          self.new(build_attributes(resp))
        else
          resp
        end
      end

      def initialize_time_attribute(value)
        return nil unless value.present?
        CiviCrm.time_zone.parse(value).in_time_zone(Time.zone) # Convert CiviCrm time zone to local time zone
      end

      def initialize_date_attribute(value)
        initialize_time_attribute(value).try(:to_date)
      end

      private

      def build_attributes(resp)
        resp.each do |attribute, value|
          if value.is_a?(Array)
            attribute_class_name = "::#{ attribute.to_s.singularize.camelize }"
            attribute_class_name = "CiviCrm#{ attribute_class_name }" unless class_exists?(attribute_class_name)
            value.map! { |v| attribute_class_name.constantize.new(v) } if class_exists?(attribute_class_name)
          end
        end
        resp
      end

      def class_exists?(class_name)
        class_name.constantize
      rescue NameError => e
        return false
      else
        return true
      end
    end
  end
end
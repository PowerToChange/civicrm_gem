require 'active_model/dirty'

module CiviCrm
  class Resource
    class_attribute :entity_name

    def initialize(values = {})
      values = values.with_indifferent_access
      @values = {}
      @id = values['id'] if values['id']
      refresh_from(values)
    end

    # we will use this method for creating nested resources
    def refresh_from(values)
      values.each do |key, value|
        @values[key] = value
      end
    end

    def inspect
      id_string = !@id.nil? ? " id=#{@id}" : ""
      "#<#{self.class}:0x#{self.object_id.to_s(16)}#{id_string}> #{attributes}"
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

      private

      def build_attributes(resp)
        resp.each do |attribute, value|
          if value.is_a?(Array)
            begin
              attribute_klass = "::#{ attribute.to_s.singularize.camelize }".constantize
              value.map! { |v| attribute_klass.new(v) }
            rescue NameError => e
              puts e
            end
          end
        end
        resp
      end
    end
  end
end
require 'active_model/dirty'
module CiviCrm
  class Resource
    include ActiveModel::Dirty
    class_attribute :entity_name

    def initialize(values = {})
      @values = {}
      @id = values['id'] if values['id']
      refresh_from(values)
      self.class.define_attribute_methods(attributes.keys)
    end

    # we will use this method for creating nested resources
    def refresh_from(values)
      values.each do |key, value|
        @values[key] = value
      end
    end

    def to_s(*opts)
      @values.to_json
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

    def to_json(*opts)
      CiviCrm::JSON.encode(@values)
    end

    def as_json(*opts)
      @values.as_json(*a)
    end

    def to_hash
      @values
    end

    def attributes
      to_hash.reject{ |k, v| v.is_a? (CiviCrm::Resource)}
    end

    def attribute(key)
      to_hash[key]
    end

    class << self
      def entity(name = nil)
        self.entity_name = name
      end

      def entity_class_name
        self.entity_name.to_s.classify
      end

      def build_from(resp, request_params = {})
        entity = request_params['entity']
        case resp
        when Array
          resp.map { |values| build_from(values, request_params) }
        when Hash
          klass = "CiviCrm::#{entity.classify}".constantize
          resource = klass.new(resp)
          resource
        else
          resp
        end
      end
    end
  end
end
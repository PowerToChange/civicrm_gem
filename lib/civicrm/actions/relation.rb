module CiviCrm
  module Actions
    class Relation
      attr_accessor :where_params, :includes_entities

      def initialize(klass)
        @klass = klass
        @where_params = ActiveSupport::HashWithIndifferentAccess.new
        @includes_entities = ActiveSupport::HashWithIndifferentAccess.new
      end

      def where(params)
        relation = clone
        relation.where_params.merge!(params)
        relation
      end

      def includes(*args)
        relation = clone

        # The args could be symbols or hashes
        args.each do |arg|
          if arg.is_a?(Hash)
            arg.each { |entity, conditions| relation.includes_entities[entity] = conditions }
          else
            relation.includes_entities[arg] = {}
          end
        end

        relation
      end

      def find(id)
        where_params.merge!(id: id)
        self.first
      end

      def all
        where_params['rowCount'] ||= CiviCrm.default_row_count
        build
      end

      def first
        where_params.merge!('rowCount' => '1')
        build.first
      end

      def count
        all.size
      end

      def method_missing(name, *opts, &block)
        if Array.method_defined?(name) && !name.to_s.include?('=')
          self.all.send(name, *opts, &block)
        else
          super
        end
      end

      def url
        @klass.build_url(build_params)
      end

      private

      def build
        @klass.build_response(build_params)
      end

      def build_params
        where_params.merge(includes: includes_entities)
      end
    end
  end
end
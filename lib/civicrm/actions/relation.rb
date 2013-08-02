module CiviCrm
  module Actions
    class Relation
      attr_accessor :where_params, :includes_entities

      def initialize(klass)
        @klass = klass
        @where_params = {}
        @includes_entities = []
      end

      def where(params)
        relation = clone
        relation.where_params.merge!(params)
        relation
      end

      def includes(*args)
        relation = clone
        relation.includes_entities += args
        relation
      end

      def find(id)
        where_params.merge!(id: id)
        self.first
      end

      def all
        build
      end

      def first
        where_params.merge!('rowCount' => '1')
        build.first
      end

      def count
        all.size
      end

      private

      def build
        @klass.build_response(where_params.merge(includes: includes_entities))
      end
    end
  end
end
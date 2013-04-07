module CiviCrm
  module Actions
    module List
      module ClassMethods
        def all(params = {})
          response = CiviCrm::Client.request(:get, path, params)
          Resource.build_from(response)
        end

        def count
          all.count
        end

        def first
          all.first
        end

        def last
          all.last
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
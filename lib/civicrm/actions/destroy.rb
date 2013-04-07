module CiviCrm
  module Actions
    module Destroy
      def delete(attrs = {})
        response = CiviCrm::Client.request(:delete, path)
        refresh_from(response.to_hash)
      end
    end
  end
end
# Mock CiviCrm::Client factory used to test API call expectations
# (i.e. POST, GET, DELETE, PUT) which stubs the return using 'test_response'
# in CiviCrm::TestResponses

module CiviCrm
  class Client
    class << self
      @mock_rest_client = nil
      def mock_rest_client(mock_client)
        @mock_rest_client = mock_client
      end

      alias_method :execute!, :execute
      def execute(opts)
        get_params = (opts[:headers] || {})[:params]
        post_params = opts[:payload]
        case opts[:method]
        when :get then @mock_rest_client.get opts[:url], get_params, post_params
        when :post then @mock_rest_client.post opts[:url], get_params, post_params
        when :put then @mock_rest_client.put opts[:url], get_params, post_params
        when :delete then @mock_rest_client.delete opts[:url], get_params, post_params
        end
      end
    end
  end
end
def authorized_civicrm_client
  CiviCrm.api_key = 'civicrm'
  CiviCrm.site_key = 'civicrm'
  CiviCrm::Client.mock_rest_client(mock)
end
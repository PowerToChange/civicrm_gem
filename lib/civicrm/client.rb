module CiviCrm
  class Client
    class << self
      def request(method, path, params = {}, headers = {})
        unless CiviCrm.site_key
          raise CiviCrm::Errors::Unauthorized, "Please specify CiviCrm.site_key"
        end
        headers = {
          :user_agent => "CiviCrm RubyClient/#{CiviCrm::VERSION}"
        }.merge(headers)

        opts = {
          :method => method,
          :timeout => 80,
          :headers => headers
        }

        # build params
        case method.to_s.downcase.to_sym
        when :get, :head, :delete
          path += stringify_params(params) if params.count > 0
        else
          opts[:payload] = stringify_params(params)
        end
        opts[:url] = CiviCrm.api_url(path)
        response = execute(opts)
        body, code = response.body, response.code
        CiviCrm::XML.parse(body)
      end

      def execute(opts)
        RestClient::Request.execute(opts)
      rescue RuntimeError => e
        case e.http_code.to_i
        when 400
          raise CiviCrm::Errors::BadRequest, e.http_body
        when 401
          raise CiviCrm::Errors::Unauthorized, e.http_body
        when 403
          raise CiviCrm::Errors::Forbidden, e.http_body
        when 404
          raise CiviCrm::Errors::NotFound, e.http_body
        when 500
          raise CiviCrm::Errors::InternalError, e.http_body
        else
          raise e
        end
      end

      def uri_escape(key)
        URI.escape(key.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
      end

      def flatten_params(params, parent_key = nil)
        result = []
        params.each do |key, value|
          flatten_key = parent_key ? "#{parent_key}[#{uri_escape(key)}]" : uri_escape(key)
          result += value.is_a?(Hash) ? flatten_params(value, flatten_key) : [[flatten_key, value]]
        end
        result
      end

      def stringify_params(params)
        flatten_params(params).collect{|key, value| "#{key}=#{uri_escape(value)}"}.join('&')
      end
    end
  end
end
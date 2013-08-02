module CiviCrm
  class Client
    class << self

      def request(method, params = {})
        raise CiviCrm::Errors::Unauthorized, "Please specify CiviCrm.site_key" unless CiviCrm.site_key
        CiviCrm::JSON.parse(response(method, params))
      end

      private

      def headers
        { user_agent: "CiviCrm RubyClient/#{CiviCrm::VERSION}" }
      end

      def response(method, params)
        execute(build_opts(method, params)).body
      end

      def build_opts(method, params)
        opts = {
          method: method,
          timeout: 80,
          headers: headers
        }

        # set to return json response
        params.merge!(json: 1)

        params = build_in_json_param(params)

        # build params
        case method.to_s.downcase.to_sym
        when :get, :head, :delete
          path = params.count > 0 ? stringify_params(params) : ''
        else
          opts[:payload] = stringify_params(params)
        end
        opts[:url] = CiviCrm.api_url(path)
        opts
      end

      def build_in_json_param(params)
        json_hash ||= {}

        # We can "include" entities by chaining the result of the API call into subsequent calls.
        # E.g. if we make a request for a Contact we can include it's Activities and it's Notes by specifying the json param like this:
        #   json={"api.Activity.Get":{},"api.Note.Get":{}}
        params.delete(:includes).try(:each) do |include_entity|
          json_hash["api.#{ include_entity.to_s.singularize.camelize }.Get"] = {}
        end

        # We can return multiple entities if we know their ids by specifying the json param like this:
        #   json={"id":{"in":"1,60047,60048"}}
        if params[:id].is_a?(Array)
          ids = params.delete(:id)
          json_hash[:id] = { "in" => ids.join(',') }
        end

        params[:json] = json_hash.to_json if json_hash.present?
        params
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
module Ds
  module Cabinet

    class Api < Ds::Cabinet::Base

      def self.create_topic(widget, api_token)
        url = "api/v1/users/#{widget.client_id}/topics"
        request = {
          topic: {
            widget_type: "purchase",
            widget_options: {
              id: widget.id,
              domain: "delo-widgets-dev.sredda.ru:8082",
              path: "/purchase"
            }
          }
        }

        client = client(url, api_token)
        client.post(request.to_json)

        { code: client.response_code,
          body: client.body_str }
      end


      def self.client(url, token)
        url = "#{Rails.configuration.cabinet_url}/#{url}"
        headers = {}
        headers['Content-Type'] = 'application/json'
        headers['Accept'] = 'application/json'
        headers['Api-Version'] = '2.2'
        headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(token)

        Curl::Easy.new(url) do |curl|
          curl.headers = headers
          curl.use_ssl = 1
          curl.verbose = Rails.configuration.cabinet_curl_verbose
        end
      end

    end

  end
end

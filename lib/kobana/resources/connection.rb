# frozen_string_literal: true

module Kobana
  module Resources
    module Connection
      BASE_URI = {
        v2: {
          sandbox: "https://api-sandbox.kobana.com.br/v2",
          production: "https://api.kobana.com.br/v2",
          development: "http://localhost:5000/api/v2"
        },
        v1: {
          sandbox: "https://api-sandbox.kobana.com.br/v1",
          production: "https://api.kobana.com.br/v1",
          development: "http://localhost:5000/api/v1"
        }
      }.freeze

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def default_headers
          {
            "Authorization" => "Bearer #{Kobana.configuration.api_token}",
            "Content-Type" => "application/json"
          }
        end

        def connection
          headers = default_headers.merge(Kobana.configuration.custom_headers)
          Faraday.new(url: base_url) do |faraday|
            faraday.request :url_encoded
            faraday.adapter Faraday.default_adapter
            faraday.headers = headers
            faraday.response :logger if Kobana.configuration.debug
          end
        end

        def request(method, url, params_or_body = nil)
          response = connection.send(method, url, params_or_body)
          parse_response(response)
        end

        def parse_response(response)
          body_parsed = begin
            JSON.parse(response.body, symbolize_names: true)
          rescue JSON::ParserError
            response.body
          end

          if body_parsed.is_a?(String) || body_parsed.is_a?(Array) || !body_parsed.key?(:data)
            { status: response.status, data: body_parsed }
          else
            body_parsed
          end
        end

        def base_url
          @base_url ||= BASE_URI[api_version&.to_sym][Kobana.configuration.environment&.to_sym]
        end
      end
    end
  end
end

# frozen_string_literal: true

require "faraday"
require "json"

module Kobana
  module Resources
    class Base
      include Operations

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

      class << self
        attr_accessor :resource_endpoint

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

        def parse_response(response)
          body_parsed = JSON.parse(response.body, symbolize_names: true)

          if body_parsed.is_a?(Array) || !body_parsed.key?(:data)
            { status: response.status, data: body_parsed }
          else
            body_parsed
          end
        end

        def base_url
          @base_url ||= BASE_URI[Kobana.configuration.api_version][Kobana.configuration.environment]
        end
      end

      def base_url
        self.class.base_url
      end

      def connection
        self.class.connection
      end

      def parse_response(response)
        self.class.parse_response(response)
      end

      def resource_endpoint
        self.class.resource_endpoint
      end
    end
  end
end

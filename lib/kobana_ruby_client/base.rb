# frozen_string_literal: true

require "faraday"
require "json"

module KobanaRubyClient
  class Base
    attr_reader :base_url, :custom_headers

    BASE_URI = {
      charges: {
        sandbox: "https://api-sandbox.kobana.com.br/v2",
        production: "https://api.kobana.com.br/v2",
        development: "http://localhost:5000/api/v2"
      },
      bank_billets: {
        sandbox: "https://api-sandbox.kobana.com.br/v1",
        production: "https://api.kobana.com.br/v1",
        development: "http://localhost:5000/api/v1"
      }
    }.freeze

    def initialize(api_key, service, custom_headers = {}, environment = :development)
      @api_key = api_key
      @base_url = BASE_URI[service][environment]
      @custom_headers = custom_headers
    end

    private

    def default_headers
      {
        "Authorization" => "Bearer #{@api_key}",
        "Content-Type" => "application/json"
      }
    end

    def connection
      headers = default_headers.merge(@custom_headers)
      Faraday.new(url: @base_url) do |faraday|
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
        faraday.headers = headers
      end
    end

    def parse_response(response)
      JSON.parse(response.body)
    end
  end
end

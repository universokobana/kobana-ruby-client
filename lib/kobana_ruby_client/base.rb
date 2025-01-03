# frozen_string_literal: true

require "faraday"
require "json"

module KobanaRubyClient
  class Base
    attr_reader :base_url, :custom_headers

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

    def initialize
      config = KobanaRubyClient.configuration

      @api_key = config.api_token
      @base_url = BASE_URI[config.api_version][config.environment]
      @custom_headers = config.custom_headers
      @debug = config.debug
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
        faraday.response :logger if @debug
      end
    end

    def parse_response(response)
      JSON.parse(response.body)
    end
  end
end

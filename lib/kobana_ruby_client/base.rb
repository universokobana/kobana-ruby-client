# frozen_string_literal: true

require "faraday"
require "json"

module KobanaRubyClient
  class Base
    attr_reader :base_url, :custom_headers

    def initialize(api_key, custom_headers = {})
      @api_key = api_key
      @base_url = ENV["BASE_URL"] || "http://localhost:5000/api/v2"
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

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
        def headers
          config = client&.configuration || Kobana.configuration
          {
            "Authorization" => "Bearer #{config.api_token}",
            "Content-Type" => "application/json"
          }.merge(config.custom_headers)
        end

        def connection
          config = client&.configuration || Kobana.configuration
          # Don't cache connection when debugging to ensure logger works
          return build_connection(config) if config.debug

          @connection ||= build_connection(config)
        end

        private

        def build_connection(config)
          Faraday.new(url: base_url) do |faraday|
            faraday.request :url_encoded
            faraday.request :json
            faraday.adapter Faraday.default_adapter
            faraday.headers = headers
            faraday.response :logger, logger if config.debug
          end
        end

        public

        def multipart_connection
          config = client&.configuration || Kobana.configuration
          # Don't cache connection when debugging
          return build_multipart_connection(config) if config.debug

          @multipart_connection ||= build_multipart_connection(config)
        end

        def build_multipart_connection(config)
          Faraday.new(url: base_url) do |faraday|
            faraday.request :multipart
            faraday.request :url_encoded
            faraday.adapter :net_http
            faraday.headers = headers.merge(
              "Content-Type" => "multipart/form-data"
            )
            faraday.response :logger, logger if config.debug
          end
        end

        def logger
          logger = Logger.new($stdout)
          logger.formatter = proc do |severity, datetime, _progname, msg|
            redacted_msg = msg.gsub(/(Bearer|Token)\s+[A-Za-z0-9\-_.]+/, '\1 [REDACTED]')
            "#{severity} #{datetime}: #{redacted_msg}\n"
          end
          logger
        end

        def request(method, url, params_or_body = nil, options = {})
          self.errors = []
          response = if options[:multipart]
                       multipart_connection.send(method, url, params_or_body)
                     else
                       connection.send(method, url, params_or_body)
                     end
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
          config = client&.configuration || Kobana.configuration
          BASE_URI[api_version&.to_sym][config.environment&.to_sym]
        end
      end
    end
  end
end

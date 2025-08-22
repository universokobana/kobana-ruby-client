# frozen_string_literal: true

module Kobana
  class Error < StandardError; end

  class ConfigurationError < Error; end
  class ConnectionError < Error; end
  class ResourceNotFoundError < Error; end
  class UnauthorizedError < Error; end
  class ValidationError < Error; end

  class APIError < Error
    attr_reader :status, :response_body, :errors

    def initialize(message = nil, status: nil, response_body: nil, errors: nil)
      @status = status
      @response_body = response_body
      @errors = errors
      super(message || default_message)
    end

    private

    def default_message
      "API request failed with status #{status}"
    end
  end
end

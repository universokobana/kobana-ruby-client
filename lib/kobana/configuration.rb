# frozen_string_literal: true

module Kobana
  class Configuration
    # `open_timeout` and `timeout` are passed straight to Faraday (in seconds).
    # Both default to nil (no timeout) to preserve historical behavior; set them
    # to fail fast instead of blocking the caller when the API is slow/hanging.
    attr_accessor :api_token, :environment, :custom_headers, :debug, :api_version,
                  :open_timeout, :timeout

    def initialize
      @custom_headers = {}
      @environment = :sandbox
      # nil means "no global override" — each resource uses its own declared
      # api_version (see Resources::Base). Set this to force a version globally.
      @api_version = nil
    end

    def inspect
      default_inspect = super
      default_inspect.gsub(/api_token="(.*)"/, "api_token=\"[REDACTED]\"")
    end
  end
end

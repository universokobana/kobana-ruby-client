# frozen_string_literal: true

module Kobana
  class Configuration
    attr_accessor :api_token, :environment, :custom_headers, :debug, :api_version

    def initialize
      @custom_headers = {}
      @environment = :sandbox
      @api_version = :v2
    end

    def inspect
      default_inspect = super
      default_inspect.gsub(/api_token="(.*)"/, "api_token=\"[REDACTED]\"")
    end
  end
end

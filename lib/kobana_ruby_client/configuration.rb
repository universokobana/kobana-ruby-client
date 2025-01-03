# frozen_string_literal: true

module KobanaRubyClient
  class Configuration
    attr_accessor :api_token, :environment, :custom_headers, :api_version, :debug

    def initialize
      @custom_headers = {}
      @environment = :development
    end
  end
end

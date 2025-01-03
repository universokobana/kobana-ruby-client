# frozen_string_literal: true

module KobanaRubyClient
  class Configuration
    attr_accessor :api_token, :environment, :custom_headers, :service, :debug

    def initialize
      @custom_headers = {}
      @environment = :development
    end
  end
end

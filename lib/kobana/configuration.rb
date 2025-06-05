# frozen_string_literal: true

module Kobana
  class Configuration
    attr_accessor :api_token, :environment, :custom_headers, :debug

    def initialize
      @custom_headers = {}
      @environment = :sandbox
    end
  end
end

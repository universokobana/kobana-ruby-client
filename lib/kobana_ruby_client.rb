# frozen_string_literal: true

require "faraday"
require "json"
require "dotenv"
Dotenv.load

module KobanaRubyClient
  autoload :Base, "kobana_ruby_client/base"
  autoload :Version, "kobana_ruby_client/version"

  module Resources
    module Charge
      autoload :Pix, "kobana_ruby_client/resources/charge/pix"
    end
  end

  class << self
    attr_accessor :api_key
  end
end

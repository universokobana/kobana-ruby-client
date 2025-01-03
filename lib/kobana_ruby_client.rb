# frozen_string_literal: true

require "faraday"
require "json"
require "dotenv"
require "kobana_ruby_client/configuration"
Dotenv.load

module KobanaRubyClient
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration) if block_given?
    end
  end

  autoload :Base, "kobana_ruby_client/base"
  autoload :Version, "kobana_ruby_client/version"

  module Resources
    autoload :ResourceOperations, "kobana_ruby_client/resources/resource_operations"
    module Charge
      autoload :Pix, "kobana_ruby_client/resources/charge/pix"
      autoload :BankBillet, "kobana_ruby_client/resources/charge/bank_billet"
    end
  end
end

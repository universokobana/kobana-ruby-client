# frozen_string_literal: true

require "faraday"
require "json"
require "kobana/configuration"

module Kobana
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration) if block_given?
    end
  end

  autoload :Base, "kobana/base"
  autoload :Version, "kobana/version"

  module Resources
    autoload :ResourceOperations, "kobana/resources/resource_operations"
    module Charge
      autoload :Pix, "kobana/resources/charge/pix"
      autoload :BankBillet, "kobana/resources/charge/bank_billet"
    end

    module Financial
      autoload :Account, "kobana/resources/financial/account"
    end

    module Admin
      autoload :Subaccount, "kobana/resources/admin/subaccount"
    end
  end
end

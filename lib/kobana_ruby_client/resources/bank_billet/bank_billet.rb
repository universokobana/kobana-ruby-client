# frozen_string_literal: true

module KobanaRubyClient
  module Resources
    module BankBillet
      class BankBillet < Base
        include ResourceOperations

        @resource_endpoint = "bank_billets"

        class << self
          attr_reader :resource_endpoint
        end
      end
    end
  end
end

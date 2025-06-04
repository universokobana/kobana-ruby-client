# frozen_string_literal: true

module Kobana
  module Resources
    module Charge
      class BankBillet < Base
        self.resource_endpoint = "bank_billets"

        def cancel
          response = request(:put, "#{uri}/cancel")
          case response[:status]
          when 204
            true
          else
            false
          end
        end
      end
    end
  end
end

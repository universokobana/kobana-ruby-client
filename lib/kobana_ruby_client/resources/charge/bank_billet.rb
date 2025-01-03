# frozen_string_literal: true

module KobanaRubyClient
  module Resources
    module Charge
      class BankBillet < Base
        include ResourceOperations

        @resource_endpoint = "bank_billets"

        class << self
          attr_reader :resource_endpoint
        end

        def cancel(resource_id)
          url = "#{base_url}/#{endpoint}/#{resource_id}/cancel"
          response = connection.put(url)
          { status: response.status, data: {} }
        end
      end
    end
  end
end

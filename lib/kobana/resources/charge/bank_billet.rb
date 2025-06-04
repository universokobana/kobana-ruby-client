# frozen_string_literal: true

module Kobana
  module Resources
    module Charge
      class BankBillet < Base
        @resource_endpoint = "bank_billets"

        def cancel(resource_id)
          url = "#{base_url}/#{endpoint}/#{resource_id}/cancel"
          response = connection.put(url)
          { status: response.status, data: {} }
        end
      end
    end
  end
end

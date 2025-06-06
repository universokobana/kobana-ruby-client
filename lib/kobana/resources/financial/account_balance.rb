# frozen_string_literal: true

module Kobana
  module Resources
    module Financial
      class AccountBalance < Base
        self.resource_endpoint = "financial/accounts/{financial_account_uid}/balances"
      end
    end
  end
end

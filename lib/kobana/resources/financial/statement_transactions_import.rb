# frozen_string_literal: true

module Kobana
  module Resources
    module Financial
      class StatementTransactionsImport < Base
        self.resource_endpoint = "financial/accounts/{financial_account_uid}/statement_transactions/import"
      end
    end
  end
end

# frozen_string_literal: true

module Kobana
  module Resources
    module Financial
      class StatementTransactionsImport < Base
        self.resource_endpoint = "financial/accounts/{financial_account.uid}/statement_transactions/imports"

        def self.create(attributes = {})
          require "faraday/multipart"

          if attributes[:source].is_a?(String) && File.exist?(attributes[:source])
            attributes[:source] = Faraday::UploadIO.new(
              attributes[:source],
              attributes.delete(:source_mime_type) || "application/octet-stream",
              attributes.delete(:source_filename) || File.basename(attributes[:source])
            )
          end
          super(attributes, multipart: true)
        end
      end
    end
  end
end

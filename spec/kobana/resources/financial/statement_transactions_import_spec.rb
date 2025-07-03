# frozen_string_literal: true

require "spec_helper"

RSpec.describe Kobana::Resources::Financial::StatementTransactionsImport do
  let!(:api_token) { ENV.fetch("KOBANA_API_TOKEN", nil) }

  before do
    Kobana.configure do |config|
      config.api_token = api_token
      config.environment = :sandbox
    end
  end

  describe "resource_endpoint" do
    it {
      endpoint = "financial/accounts/{financial_account_uid}/statement_transactions/imports"
      expect(described_class.resource_endpoint).to eq(endpoint)
    }
  end

  describe "uri" do
    it do
      expect(described_class.uri).to eq("https://api-sandbox.kobana.com.br/v2/financial/accounts//statement_transactions/imports")
      described_class.default_attributes[:financial_account_uid] = "019738cc-759d-76c7-8dfd-3434397207ac"
      expect(described_class.uri).to eq("https://api-sandbox.kobana.com.br/v2/financial/accounts/019738cc-759d-76c7-8dfd-3434397207ac/statement_transactions/imports")
    end
    specify(:aggregate_failures) do
      expect(described_class.new(financial_account_uid: "019738cc-759d-76c7-8dfd-3434397207ac").uri).to eq("https://api-sandbox.kobana.com.br/v2/financial/accounts/019738cc-759d-76c7-8dfd-3434397207ac/statement_transactions/imports/")
      expect(described_class.new(financial_account_uid: "019738cc-759d-76c7-8dfd-3434397207ac",
                                 uid: "f47ac10b-58cc-4372-a567-0e02b2c3d479").uri).to eq("https://api-sandbox.kobana.com.br/v2/financial/accounts/019738cc-759d-76c7-8dfd-3434397207ac/statement_transactions/imports/f47ac10b-58cc-4372-a567-0e02b2c3d479")
    end
  end

  describe "#create", vcr: { cassette_name: "resources/financial/statement_transactions/create" } do
    let(:base_path) { File.expand_path("../../fixtures/files", __dir__) }
    let(:file_path) { File.join(base_path, "transactions.json") }
    let(:source) { file_path }
    # TODO: Trocar para 19738cc-759d-76c7-8dfd-3434397207ac quando o endpoint estiver pronto
    let(:attributes) do
      { financial_account_uid: "808", source:, source_mime_type: "application/json",
        source_filename: "specific-name.json" }
    end
    subject { described_class.create(attributes) }

    it "creates a new import" do
      expect(subject).to be_created
      expect(subject).to be_valid
    end
  end
end

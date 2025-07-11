# frozen_string_literal: true

require "spec_helper"

RSpec.describe Kobana::Resources::Financial::AccountBalance do
  let!(:api_token) { ENV.fetch("KOBANA_API_TOKEN", nil) }

  before do
    Kobana.configure do |config|
      config.api_token = api_token
      config.environment = :sandbox
    end
  end

  describe "resource_endpoint" do
    it {
      endpoint = "financial/accounts/{financial_account.uid}/balances"
      expect(described_class.resource_endpoint).to eq(endpoint)
    }
  end

  describe "uri" do
    it do
      expect(described_class.uri).to eq("https://api-sandbox.kobana.com.br/v2/financial/accounts//balances")
      described_class.default_attributes[:financial_account] = { uid: "019738cc-759d-76c7-8dfd-3434397207ac" }
      expect(described_class.uri).to eq("https://api-sandbox.kobana.com.br/v2/financial/accounts/019738cc-759d-76c7-8dfd-3434397207ac/balances")
    end
    specify(:aggregate_failures) do
      expect(described_class.new(financial_account: { uid: "019738cc-759d-76c7-8dfd-3434397207ac" }).uri).to eq("https://api-sandbox.kobana.com.br/v2/financial/accounts/019738cc-759d-76c7-8dfd-3434397207ac/balances/")
      expect(described_class.new(financial_account: { uid: "019738cc-759d-76c7-8dfd-3434397207ac" },
                                 uid: "f47ac10b-58cc-4372-a567-0e02b2c3d479").uri).to eq("https://api-sandbox.kobana.com.br/v2/financial/accounts/019738cc-759d-76c7-8dfd-3434397207ac/balances/f47ac10b-58cc-4372-a567-0e02b2c3d479")
    end
  end

  describe "#update", vcr: { cassette_name: "resources/financial/account_balance/update", record: :new_episodes } do
    let(:account_balance) do
      described_class.create(amount: 12.34, financial_account: { uid: "0197fa81-96f0-78bd-9325-9c181ce6e133" })
    end
    subject { account_balance.update({ amount: 56.78 }) }

    it "creates a new bank_billet with the correct attributes" do
      expect(subject.errors).to eq([{ title: "Not found" }])
    end
  end
end

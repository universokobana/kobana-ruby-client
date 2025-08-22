# frozen_string_literal: true

require "spec_helper"

RSpec.describe Kobana::Client do
  describe "#initialize" do
    it "creates a client with custom configuration" do
      client = described_class.new(
        api_token: "test_token_123",
        environment: :production,
        custom_headers: { "X-Custom" => "Header" },
        debug: true
      )

      expect(client.configuration.api_token).to eq("test_token_123")
      expect(client.configuration.environment).to eq(:production)
      expect(client.configuration.custom_headers).to eq({ "X-Custom" => "Header" })
      expect(client.configuration.debug).to be true
    end

    it "creates a client with default configuration" do
      client = described_class.new(api_token: "token")

      expect(client.configuration.api_token).to eq("token")
      expect(client.configuration.environment).to eq(:sandbox)
      expect(client.configuration.custom_headers).to eq({})
      expect(client.configuration.debug).to be_falsey
    end
  end

  describe "#configure" do
    it "allows configuration via block" do
      client = described_class.new

      client.configure do |config|
        config.api_token = "configured_token"
        config.environment = :development
      end

      expect(client.configuration.api_token).to eq("configured_token")
      expect(client.configuration.environment).to eq(:development)
    end
  end

  describe "resource proxies" do
    let(:client) { described_class.new(api_token: "test_token") }

    describe "#charge" do
      it "returns a ResourceProxy" do
        expect(client.charge).to be_a(Kobana::Client::ResourceProxy)
      end

      it "returns pix resource with client context" do
        pix_class = client.charge.pix
        expect(pix_class.client).to eq(client)
      end

      it "returns bank_billet resource with client context" do
        bank_billet_class = client.charge.bank_billet
        expect(bank_billet_class.client).to eq(client)
      end
    end

    describe "#financial" do
      it "returns a ResourceProxy" do
        expect(client.financial).to be_a(Kobana::Client::ResourceProxy)
      end

      it "returns account resource with client context" do
        account_class = client.financial.account
        expect(account_class.client).to eq(client)
      end

      it "returns account_balance resource with client context" do
        balance_class = client.financial.account_balance
        expect(balance_class.client).to eq(client)
      end

      it "returns statement_transactions_import resource with client context" do
        import_class = client.financial.statement_transactions_import
        expect(import_class.client).to eq(client)
      end
    end

    describe "#admin" do
      it "returns a ResourceProxy" do
        expect(client.admin).to be_a(Kobana::Client::ResourceProxy)
      end

      it "returns subaccount resource with client context" do
        subaccount_class = client.admin.subaccount
        expect(subaccount_class.client).to eq(client)
      end
    end
  end

  describe "multi-client isolation" do
    let(:client1) { described_class.new(api_token: "token1", environment: :sandbox) }
    let(:client2) { described_class.new(api_token: "token2", environment: :production) }

    it "maintains separate configurations" do
      expect(client1.configuration.api_token).to eq("token1")
      expect(client2.configuration.api_token).to eq("token2")
      expect(client1.configuration.environment).to eq(:sandbox)
      expect(client2.configuration.environment).to eq(:production)
    end

    it "creates isolated resource classes" do
      pix1 = client1.charge.pix
      pix2 = client2.charge.pix

      expect(pix1.client).to eq(client1)
      expect(pix2.client).to eq(client2)
      expect(pix1).not_to eq(pix2)
    end
  end

  describe "backward compatibility" do
    it "still allows global configuration" do
      Kobana.configure do |config|
        config.api_token = "global_token"
        config.environment = :sandbox
      end

      expect(Kobana.configuration.api_token).to eq("global_token")
      expect(Kobana.configuration.environment).to eq(:sandbox)
    end

    it "resources work without client context" do
      Kobana.configure do |config|
        config.api_token = "global_token"
      end

      # This should not raise an error
      expect { Kobana::Resources::Charge::Pix }.not_to raise_error
    end
  end
end

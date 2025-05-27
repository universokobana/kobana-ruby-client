# frozen_string_literal: true

require "spec_helper"
require "pry"

RSpec.describe Kobana::Resources::Financial::Account do
  let!(:api_key) { ENV.fetch("KOBANA_API_TOKEN", nil) }
  let(:financial_account_attributes) { attributes_for(:financial_account).deep_symbolize_keys }

  before do
    Kobana.configure do |config|
      config.api_token = api_key
      config.environment = :sandbox
      config.api_version = :v2
    end
  end

  let(:account) { described_class.new }

  context "do not exist" do
    describe "#create", vcr: { cassette_name: "resources/financial/account/create" } do
      subject { account.create(financial_account_attributes) }

      it "creates a new account" do
        expect(subject[:status]).to eq(201)

        expect(subject[:data][:agency_number]).to eq(financial_account_attributes[:agency_number])
        expect(subject[:data][:account_number]).to eq(financial_account_attributes[:account_number])
        expect(subject[:data][:financial_provider_slug]).to eq(financial_account_attributes[:financial_provider_slug])
        expect(subject[:data][:kind]).to eq(financial_account_attributes[:kind])
      end
    end
  end

  context "exist" do
    before do
      VCR.use_cassette("resources/financial/account/create_for_methods") do
        @created_account = account.create(financial_account_attributes)
      end
    end

    describe "#index", vcr: { cassette_name: "resources/financial/account/list_all" } do
      subject { account.index }

      it "checks if the first account is the one we created" do
        expect(subject[:data].first[:financial_provider_slug]).to eq(
          financial_account_attributes[:financial_provider_slug]
        )
        expect(subject[:data].first[:kind]).to eq(financial_account_attributes[:kind])
      end
    end

    describe "#find", vcr: { cassette_name: "resources/financial/account/find" } do
      subject { account.find(@created_account[:data][:uid]) }

      it "fetches the correct account" do
        expect(subject[:data][:uid]).to eq(@created_account[:data][:uid])
        expect(subject[:data][:financial_provider_slug]).to eq(financial_account_attributes[:financial_provider_slug])
        expect(subject[:data][:kind]).to eq(financial_account_attributes[:kind])
      end
    end

    describe "#list_command", vcr: { cassette_name: "resources/financial/account/list_command" } do
      subject { account.list_command(@created_account[:data][:uid]) }

      it "returns the list of commands/accounts" do
        expect(subject[:data]).not_to be_empty
        expect(subject[:data].first[:operation]).to eq("statement_sync")
        expect(subject[:data].first[:status]).to eq("pending")
      end
    end

    describe "#find_command", vcr: { cassette_name: "resources/financial/account/find_command" } do
      before do
        @commands = account.list_command(@created_account[:data][:uid])
        @command_id = @commands[:data].is_a?(Array) && @commands[:data].any? ? @commands[:data].first[:id] : nil
      end

      subject { account.find_command(@created_account[:data][:uid], @command_id) }

      it "returns the specific command/account" do
        expect(subject[:data][:id]).to eq(@command_id)
      end
    end
  end
end

# frozen_string_literal: true

require "spec_helper"

RSpec.describe Kobana::Resources::Financial::Account do
  let!(:api_token) { ENV.fetch("KOBANA_API_TOKEN", nil) }
  let(:financial_account_attributes) { attributes_for(:financial_account).deep_symbolize_keys }

  before do
    Kobana.configure do |config|
      config.api_token = api_token
      config.environment = :sandbox
    end
  end

  context "do not exist" do
    describe "#create", vcr: { cassette_name: "resources/financial/account/create" } do
      subject { described_class.create(financial_account_attributes) }

      it "creates a new account" do
        expect(subject[:agency_number]).to eq(financial_account_attributes[:agency_number])
        expect(subject[:account_number]).to eq(financial_account_attributes[:account_number])
        expect(subject[:financial_provider_slug]).to eq(financial_account_attributes[:financial_provider_slug])
        expect(subject[:kind]).to eq(financial_account_attributes[:kind])
      end
    end
  end

  context "exist" do
    let(:account) { @created_account }

    before do
      VCR.use_cassette("resources/financial/account/create") do
        @created_account = described_class.create(financial_account_attributes)
      end
    end

    describe "#index", vcr: { cassette_name: "resources/financial/account/list_all" } do
      subject { described_class.all }

      it "checks if the first account is the one we created" do
        expect(subject.first[:financial_provider_slug]).to eq(
          financial_account_attributes[:financial_provider_slug]
        )
        expect(subject.first[:kind]).to eq(financial_account_attributes[:kind])
      end
    end

    describe "#find", vcr: { cassette_name: "resources/financial/account/find" } do
      subject { described_class.find(@created_account.uid) }

      it "fetches the correct account" do
        expect(subject[:uid]).to eq(@created_account.uid)
        expect(subject[:financial_provider_slug]).to eq(financial_account_attributes[:financial_provider_slug])
        expect(subject[:kind]).to eq(financial_account_attributes[:kind])
      end
    end

    describe "#find_by_external_id", vcr: { cassette_name: "resources/financial/account/find_by_external_id" } do
      subject { described_class.find(@created_account[:external_id], field: "external_id") }

      xit "fetches the correct account" do
        expect(subject[:uid]).to eq(@created_account.uid)
        expect(subject[:financial_provider_slug]).to eq(financial_account_attributes[:financial_provider_slug])
        expect(subject[:kind]).to eq(financial_account_attributes[:kind])
      end
    end

    describe "#list_commands", vcr: { cassette_name: "resources/financial/account/list_commands" } do
      subject { account.list_commands }

      it "returns the list of commands/accounts" do
        expect(subject).to be_a(Array)
      end
    end

    describe "#find_command", vcr: { cassette_name: "resources/financial/account/find_command" } do
      before do
        @commands = account.list_commands
        @command_id = @commands.is_a?(Array) && @commands.any? ? @commands.first[:id] : nil
      end

      context "when command does not exist" do
        it "raises an error" do
          expect { account.find_command(nil) }
            .to raise_error(ArgumentError, /Command ID cannot be nil/)
        end
      end

      context "when command exists" do
        subject { account.find_command(@command_id) }

        xit "returns the specific command/account" do
          expect(subject[:data][:id]).to eq(@command_id)
        end
      end
    end
  end
end

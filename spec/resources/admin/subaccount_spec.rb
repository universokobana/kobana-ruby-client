# frozen_string_literal: true

require "spec_helper"

RSpec.describe Kobana::Resources::Admin::Subaccount do
  let!(:api_token) { ENV.fetch("KOBANA_API_TOKEN", nil) }
  let(:admin_subaccount_attributes) { attributes_for(:admin_subaccount).deep_symbolize_keys }

  before do
    Kobana.configure do |config|
      config.api_token = api_token
      config.environment = :sandbox
      config.api_version = :v2
    end
  end

  context "do not exist" do
    describe "#create", vcr: { cassette_name: "resources/admin/subaccount/create" } do
      subject { described_class.create(admin_subaccount_attributes) }

      it "creates a new subaccount with the correct attributes" do
        expect(subject[:email]).to include("@kobana.com.br")
        expect(subject[:account_type]).to eq(admin_subaccount_attributes[:account_type])
        expect(subject[:business_legal_name]).to eq(admin_subaccount_attributes[:business_legal_name])
        expect(subject[:business_cnpj]).to eq(admin_subaccount_attributes[:business_cnpj])
        expect(subject[:nickname]).to eq(admin_subaccount_attributes[:nickname])
      end
    end
  end

  context "exist" do
    let(:subaccount) { @created_subaccount }

    before do
      VCR.use_cassette("resources/admin/subaccount/create") do
        @created_subaccount = described_class.create(admin_subaccount_attributes)
      end
    end

    describe "#index", vcr: { cassette_name: "resources/admin/subaccount/list_all" } do
      subject { described_class.all }

      it "returns an array of subaccounts" do
        expect(subject).to be_an_instance_of(Array)
        expect(subject)
          .to(be_any do |item|
            item[:email].include?("@kobana.com.br")
          end)
      end
    end

    describe "#find", vcr: { cassette_name: "resources/admin/subaccount/find" } do
      before do
        @subaccounts = described_class.all
        data = @subaccounts
        @subaccount_id = data.is_a?(Array) && data.any? ? data.first[:id] : nil
      end
      subject { described_class.find(@subaccount_id) }

      it "fetches the correct subaccount" do
        expect(subject.id).to eq(@subaccount_id)
        expect(subject[:email]).to include("@kobana.com.br")
      end
    end

    describe "#list_commands", vcr: { cassette_name: "resources/admin/subaccount/list_commands_error" } do
      subject { subaccount.list_commands }

      it do
        expect(subject).to be_nil
      end
    end

    describe "#find_command", vcr: { cassette_name: "resources/admin/subaccount/find_command_error" } do
      subject { subaccount.find_command("fake-command-id") }

      it do
        expect(subject).to be_nil
      end
    end
  end
end

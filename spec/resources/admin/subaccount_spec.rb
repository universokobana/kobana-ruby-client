# frozen_string_literal: true

require "spec_helper"
require "pry"

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

  let(:subaccount) { described_class.new }

  context "do not exist" do
    describe "#create", vcr: { cassette_name: "resources/admin/subaccount/create" } do
      subject { subaccount.create(admin_subaccount_attributes) }

      it "creates a new subaccount with the correct attributes" do
        expect(subject[:status]).to eq(201)
        expect(subject[:data][:email]).to eq(admin_subaccount_attributes[:email])
        expect(subject[:data][:account_type]).to eq(admin_subaccount_attributes[:account_type])
        expect(subject[:data][:business_legal_name]).to eq(admin_subaccount_attributes[:business_legal_name])
        expect(subject[:data][:business_cnpj]).to eq(admin_subaccount_attributes[:business_cnpj])
        expect(subject[:data][:nickname]).to eq(admin_subaccount_attributes[:nickname])
      end
    end
  end

  context "exist" do
    before do
      VCR.use_cassette("resources/admin/subaccount/create_for_test") do
        @created_subaccount = subaccount.create(admin_subaccount_attributes)[:data]
      end
    end

    describe "#index", vcr: { cassette_name: "resources/admin/subaccount/list_all" } do
      subject { subaccount.index }

      it "returns an array of subaccounts" do
        expect(subject[:data]).to be_an_instance_of(Array)
      end

      it "checks if the list contains the subaccount we created" do
        expect(subject[:data])
          .to(be_any do |item|
            item[:email] == admin_subaccount_attributes[:email]
          end)
      end
    end

    describe "#find", vcr: { cassette_name: "resources/admin/subaccount/find" } do
      before do
        @subaccounts = subaccount.index
        data = @subaccounts[:data]
        @subaccount_id = data.is_a?(Array) && data.any? ? data.first[:id] : nil
      end
      subject { subaccount.find(@subaccount_id) }

      it "fetches the correct subaccount" do
        expect(subject[:data][:id]).to eq(@subaccount_id)
        expect(subject[:data][:email]).to eq(admin_subaccount_attributes[:email])
      end
    end

    describe "#list_command", vcr: { cassette_name: "resources/admin/subaccount/list_command_error" } do
      subject { subaccount.list_command(@created_subaccount[:id]) }

      it "fails with 403, 404 or 422 because command endpoint is not available for admin_subaccount" do
        expect([403, 404, 422]).to include(subject[:status])
      end
    end

    describe "#find_command", vcr: { cassette_name: "resources/admin/subaccount/find_command_error" } do
      subject { subaccount.find_command(@created_subaccount[:id], "fake-command-id") }

      it "fails with 403, 404 or 422 because command endpoint is not available for admin_subaccount" do
        expect([403, 404, 422]).to include(subject[:status])
      end
    end
  end
end

# frozen_string_literal: true

require "spec_helper"

RSpec.describe Kobana::Resources::Charge::BankBillet do
  let!(:api_token) { ENV.fetch("KOBANA_API_TOKEN", nil) }
  let(:bank_billet_attributes) { attributes_for(:bank_billet).deep_symbolize_keys }

  before do
    Kobana.configure do |config|
      config.api_token = ENV.fetch("KOBANA_API_TOKEN", nil)
      config.environment = :sandbox
      config.api_version = :v1
    end
  end

  let(:bank_billet) { described_class.new }

  context "do not exist" do
    describe "#create", vcr: { cassette_name: "resources/charge/bank_billet/create" } do
      subject { described_class.create(bank_billet_attributes) }

      it "creates a new bank_billet with the correct attributes" do
        expect(subject[:data][:amount]).to eq(bank_billet_attributes[:amount])
        expect(subject[:data][:description]).to eq(bank_billet_attributes[:description])
        expect(subject[:data][:customer_address]).to eq(bank_billet_attributes[:customer_address])
        expect(subject[:data][:customer_address_complement]).to eq(bank_billet_attributes[:customer_address_complement])
        expect(subject[:data][:customer_address_number]).to eq(bank_billet_attributes[:customer_address_number])
        expect(subject[:data][:customer_city_name]).to eq(bank_billet_attributes[:customer_city_name])
        expect(subject[:data][:customer_cnpj_cpf]).to eq(bank_billet_attributes[:customer_cnpj_cpf])
        expect(subject[:data][:customer_email]).to eq(bank_billet_attributes[:customer_email])
        expect(subject[:data][:customer_neighborhood]).to eq(bank_billet_attributes[:customer_neighborhood])
        expect(subject[:data][:customer_person_name]).to eq(bank_billet_attributes[:customer_person_name])
        expect(subject[:data][:customer_phone_number]).to eq(bank_billet_attributes[:customer_phone_number])
        expect(subject[:data][:customer_state]).to eq(bank_billet_attributes[:customer_state])
      end
    end
  end

  context "exist" do
    before do
      VCR.use_cassette("resources/charge/bank_billet/create_for_test") do
        @created_bank_billet = described_class.create(bank_billet_attributes)[:data]
      end
    end

    describe "#index", vcr: { cassette_name: "resources/charge/bank_billet/list_all" } do
      subject { described_class.all }

      it "returns an array of bank_billets" do
        expect(subject[:data]).to be_an_instance_of(Array)
      end

      it "checks if the list contains the bank_billet we created" do
        expect(subject[:data])
          .to(be_any do |billet|
            billet[:amount] == bank_billet_attributes[:amount] &&
            billet[:customer_cnpj_cpf] == bank_billet_attributes[:customer_cnpj_cpf]
          end)
      end
    end

    describe "#find", vcr: { cassette_name: "resources/charge/bank_billet/find" } do
      subject { described_class.find(@created_bank_billet[:id]) }

      it "fetches the correct bank billet" do
        expect(subject[:data][:id]).to eq(@created_bank_billet[:id])
      end
    end

    describe "#cancel", vcr: { cassette_name: "resources/charge/bank_billet/cancel" } do
      subject { bank_billet.cancel(@created_bank_billet[:id]) }

      it "cancel the correct bank billet" do
        expect(subject[:status]).to eq(204)
        expect(subject[:data]).to eq({})
      end
    end

    describe "#list_command", vcr: { cassette_name: "resources/charge/bank_billet/list_command_error" } do
      subject { bank_billet.list_command(@created_bank_billet[:id]) }

      it "fails with 404 or 422 because command endpoint is not available for bank_billets" do
        expect([404, 422]).to include(subject[:status])
      end
    end

    describe "#find_command", vcr: { cassette_name: "resources/charge/bank_billet/find_command_error" } do
      subject { bank_billet.find_command(@created_bank_billet[:id], "fake-command-id") }

      it "fails with 404 or 422 because command endpoint is not available for bank_billets" do
        expect([404, 422]).to include(subject[:status])
      end
    end
  end
end

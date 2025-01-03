# frozen_string_literal: true

require "spec_helper"

RSpec.describe KobanaRubyClient::Resources::BankBillet::BankBillet do
  let!(:api_key) { ENV["KOBANA_API_TOKEN"] }
  let(:bank_billet_attributes) { attributes_for(:bank_billet) }

  describe "methods" do
    before do
      KobanaRubyClient.configure do |config|
        config.api_token = ENV["KOBANA_API_TOKEN"]
        config.environment = :sandbox
        config.api_version = :v1
      end

      VCR.use_cassette("resources/bank_billet/bank_billet/create_for_methods") do
        @created_bank_billet = bank_billet.create(bank_billet_attributes)
      end
    end

    let!(:bank_billet) { described_class.new }

    describe "#create", vcr: { cassette_name: "resources/bank_billet/bank_billet/create" } do
      subject { bank_billet.create(bank_billet_attributes) }

      it "creates a new bank_billet with the correct attributes" do
        expect(subject["amount"]).to eq(bank_billet_attributes[:amount])
        expect(subject["description"]).to eq(bank_billet_attributes[:description])
        expect(subject["customer_address"]).to eq(bank_billet_attributes[:customer_address])
        expect(subject["customer_address_complement"]).to eq(bank_billet_attributes[:customer_address_complement])
        expect(subject["customer_address_number"]).to eq(bank_billet_attributes[:customer_address_number])
        expect(subject["customer_city_name"]).to eq(bank_billet_attributes[:customer_city_name])
        expect(subject["customer_cnpj_cpf"]).to eq(bank_billet_attributes[:customer_cnpj_cpf])
        expect(subject["customer_email"]).to eq(bank_billet_attributes[:customer_email])
        expect(subject["customer_neighborhood"]).to eq(bank_billet_attributes[:customer_neighborhood])
        expect(subject["customer_person_name"]).to eq(bank_billet_attributes[:customer_person_name])
        expect(subject["customer_phone_number"]).to eq(bank_billet_attributes[:customer_phone_number])
        expect(subject["customer_state"]).to eq(bank_billet_attributes[:customer_state])
      end
    end

    describe "#find", vcr: { cassette_name: "resources/bank_billet/bank_billet/find" } do
      subject { bank_billet.find(@created_bank_billet["id"]) }

      it "fetches the correct bank billet" do
        expect(subject["id"]).to eq(@created_bank_billet["id"])
      end
    end

    describe "#index", vcr: { cassette_name: "resources/bank_billet/bank_billet/list_all" } do
      subject { bank_billet.index }

      it "returns an array of bank_billets" do
        expect(subject).to be_an_instance_of(Array)
      end

      it "checks if the list contains the bank_billet we created" do
        expect(subject)
          .to(be_any do |billet|
            billet["amount"] == bank_billet_attributes[:amount] &&
            billet["customer_cnpj_cpf"] == bank_billet_attributes[:customer_cnpj_cpf]
          end)
      end
    end
  end
end

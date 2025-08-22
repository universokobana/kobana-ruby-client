# frozen_string_literal: true

require "spec_helper"

RSpec.describe Kobana::Resources::Charge::BankBillet do
  let!(:api_token) { ENV.fetch("KOBANA_API_TOKEN", nil) }
  let(:bank_billet_attributes) { attributes_for(:bank_billet).deep_symbolize_keys }

  before do
    Kobana.configure do |config|
      config.api_token = ENV.fetch("KOBANA_API_TOKEN", nil)
      config.environment = :sandbox
    end
  end

  describe "api_version" do
    it { expect(described_class.api_version).to eq(:v1) }
  end

  context "do not exist" do
    describe "#create", vcr: { cassette_name: "resources/charge/bank_billet/create" } do
      subject { described_class.create(bank_billet_attributes) }

      it "creates a new bank_billet with the correct attributes" do
        expect(subject[:amount]).to eq(bank_billet_attributes[:amount])
        expect(subject[:description]).to eq(bank_billet_attributes[:description])
        expect(subject[:customer_address]).to eq(bank_billet_attributes[:customer_address])
        expect(subject[:customer_address_complement]).to eq(bank_billet_attributes[:customer_address_complement])
        expect(subject[:customer_address_number]).to eq(bank_billet_attributes[:customer_address_number])
        expect(subject[:customer_city_name]).to eq(bank_billet_attributes[:customer_city_name])
        expect(subject[:customer_cnpj_cpf]).to eq(bank_billet_attributes[:customer_cnpj_cpf])
        expect(subject[:customer_email]).to eq(bank_billet_attributes[:customer_email])
        expect(subject[:customer_neighborhood]).to eq(bank_billet_attributes[:customer_neighborhood])
        expect(subject[:customer_person_name]).to eq(bank_billet_attributes[:customer_person_name])
        expect(subject[:customer_phone_number]).to eq(bank_billet_attributes[:customer_phone_number])
        expect(subject[:customer_state]).to eq(bank_billet_attributes[:customer_state])
        expect(subject).to be_created
        expect(subject).to be_valid
      end
    end
  end

  context "exist" do
    let(:bank_billet) { @created_bank_billet }

    before do
      VCR.use_cassette("resources/charge/bank_billet/create_for_test") do
        @created_bank_billet = described_class.create(bank_billet_attributes)
      end
    end

    describe "#index", vcr: { cassette_name: "resources/charge/bank_billet/list_all" } do
      subject { described_class.all }

      it "returns an array of bank_billets" do
        expect(subject).to be_an_instance_of(Array)
        expect(subject)
          .to(be_any do |billet|
            billet[:amount] == bank_billet_attributes[:amount] &&
            billet[:customer_cnpj_cpf] == bank_billet_attributes[:customer_cnpj_cpf]
          end)
      end
    end

    describe "#find", vcr: { cassette_name: "resources/charge/bank_billet/find" } do
      subject { described_class.find(@created_bank_billet[:id]) }

      it "fetches the correct bank billet" do
        expect(subject.id).to eq(@created_bank_billet[:id])
      end
    end

    describe "#cancel", vcr: { cassette_name: "resources/charge/bank_billet/cancel" } do
      subject { bank_billet.cancel }

      it "cancel the correct bank billet" do
        expect(subject).to eq(true)
      end
    end

    describe "#list_commands", vcr: { cassette_name: "resources/charge/bank_billet/list_commands_error" } do
      subject { bank_billet.list_commands }

      it do
        expect(subject).to be_empty
        expect(described_class.errors).to eq([{ title: "Not found" }])
      end
    end

    describe "#find_command", vcr: { cassette_name: "resources/charge/bank_billet/find_command_error" } do
      subject { bank_billet.find_command("fake-command-id") }

      it do
        expect(subject).to be_nil
        expect(described_class.errors).to eq([{ title: "Not found" }])
      end
    end
  end
end

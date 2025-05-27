# frozen_string_literal: true

require "spec_helper"

RSpec.describe Kobana::Resources::Charge::Pix do
  let!(:api_key) { ENV.fetch("KOBANA_API_TOKEN", nil) }
  let(:charge_pix_attributes) { attributes_for(:charge_pix).deep_symbolize_keys }

  before do
    Kobana.configure do |config|
      config.api_token = ENV.fetch("KOBANA_API_TOKEN", nil)
      config.environment = :sandbox
      config.api_version = :v2
    end
  end

  let(:pix) { described_class.new }

  context "do not exist" do
    describe "#create", vcr: { cassette_name: "resources/charge/pix/create" } do
      subject { pix.create(charge_pix_attributes) }

      it "creates a new charge" do
        expect(subject[:status]).to eq(201)
        expect(subject[:data]).to include(charge_pix_attributes)
      end
    end
  end

  context "exist" do
    before do
      VCR.use_cassette("resources/charge/pix/create_for_methods") do
        @created_pix = pix.create(charge_pix_attributes)
      end
    end

    describe "#index", vcr: { cassette_name: "resources/charge/pix/list_all" } do
      subject { pix.index }

      it "checks if the first charge is the one we created" do
        transformed_attributes = charge_pix_attributes
        expect(subject[:data].first).to include(transformed_attributes)
      end
    end

    describe "#find", vcr: { cassette_name: "resources/charge/pix/find" } do
      subject { pix.find(@created_pix[:data][:id]) }

      it "fetches the correct charge" do
        expect(subject[:data][:id]).to eq(@created_pix[:data][:id])
        expect(subject[:data]).to include(charge_pix_attributes)
      end
    end
    describe "#list_command", vcr: { cassette_name: "resources/charge/pix/list_command" } do
      subject { pix.list_command(@created_pix[:data][:uid]) }

      it "returns the list of commands/charge/pix" do
        expect(subject[:data]).not_to be_empty
        expect(subject[:data].first[:operation]).to eq("update")
        expect(subject[:data].first[:status]).to eq("pending")
      end
    end

    describe "#find_command", vcr: { cassette_name: "resources/charge/pix/find_command" } do
      before do
        @commands = pix.list_command(@created_pix[:data][:uid])
        @command_id = @commands[:data].is_a?(Array) && @commands[:data].any? ? @commands[:data].first[:id] : nil
      end

      subject { pix.find_command(@created_pix[:data][:uid], @command_id) }

      it "returns the specific command/charge/pix" do
        expect(subject[:data][:id]).to eq(@command_id)
      end
    end
  end
end

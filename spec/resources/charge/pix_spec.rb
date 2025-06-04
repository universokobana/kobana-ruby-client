# frozen_string_literal: true

require "spec_helper"

RSpec.describe Kobana::Resources::Charge::Pix do
  let!(:api_token) { ENV.fetch("KOBANA_API_TOKEN", nil) }
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
      subject { described_class.create(charge_pix_attributes) }

      it "creates a new charge" do
        expect(subject.attributes).to include(charge_pix_attributes)
      end
    end
  end

  context "exist" do
    before do
      VCR.use_cassette("resources/charge/pix/create_for_methods") do
        @created_pix = described_class.create(charge_pix_attributes)
      end
    end

    describe "#index", vcr: { cassette_name: "resources/charge/pix/list_all" } do
      subject { described_class.all }

      it "checks if the first charge is the one we created" do
        transformed_attributes = charge_pix_attributes
        expect(subject.first.attributes).to include(transformed_attributes)
      end
    end

    describe "#find", vcr: { cassette_name: "resources/charge/pix/find" } do
      subject { described_class.find(@created_pix.id) }

      it "fetches the correct charge" do
        expect(subject.id).to eq(@created_pix.id)
        expect(subject.attributes).to include(charge_pix_attributes)
      end
    end
    describe "#list_commands", vcr: { cassette_name: "resources/charge/pix/list_commands" } do
      subject { pix.list_commands }

      it "returns the list of commands/charge/pix" do
        expect(subject.first[:operation]).to eq("update")
        expect(subject.first[:status]).to eq("pending")
      end
    end

    describe "#find_command", vcr: { cassette_name: "resources/charge/pix/find_command" } do
      before do
        @commands = pix.list_commands
        @command_id = @commands[:data].is_a?(Array) && @commands[:data].any? ? @commands[:data].first[:id] : nil
      end

      subject { pix.find_command(@command_id) }

      xit "returns the specific command/charge/pix" do
        expect(subject[:data][:id]).to eq(@command_id)
      end
    end
  end
end

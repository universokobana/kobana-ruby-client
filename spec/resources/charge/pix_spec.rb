# frozen_string_literal: true

require "spec_helper"

RSpec.describe KobanaRubyClient::Resources::Charge::Pix do
  let!(:api_key) { ENV["KOBANA_API_TOKEN"] }
  let(:charge_pix_attributes) { attributes_for(:charge_pix) }

  describe "methods" do
    before do
      KobanaRubyClient.configure do |config|
        config.api_token = ENV["KOBANA_API_TOKEN"]
        config.environment = :sandbox
        config.api_version = :v2
      end

      VCR.use_cassette("resources/charge/pix/create_for_methods") do
        @created_pix = pix.create(charge_pix_attributes)
      end
    end

    let!(:pix) { described_class.new }

    describe "#create", vcr: { cassette_name: "resources/charge/pix/create" } do
      subject { pix.create(charge_pix_attributes) }

      it "creates a new charge" do
        expect(subject["status"]).to eq(201)
        expect(subject["data"]).to include(charge_pix_attributes.deep_stringify_keys)
      end
    end

    describe "#find", vcr: { cassette_name: "resources/charge/pix/find" } do
      subject { pix.find(@created_pix["data"]["id"]) }

      it "fetches the correct charge" do
        expect(subject["data"]["id"]).to eq(@created_pix["data"]["id"])
        expect(subject["data"]).to include(charge_pix_attributes.deep_stringify_keys)
      end
    end

    describe "#index", vcr: { cassette_name: "resources/charge/pix/list_all" } do
      subject { pix.index }

      it "checks if the first charge is the one we created" do
        transformed_attributes = charge_pix_attributes.deep_stringify_keys
        expect(subject["data"].first).to include(transformed_attributes)
      end
    end
  end
end

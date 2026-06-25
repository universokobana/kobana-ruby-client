# frozen_string_literal: true

require "spec_helper"

RSpec.describe Kobana::Configuration do
  let!(:api_token) { "ANYTOKEN" }

  before do
    Kobana.configure do |config|
      config.api_token = api_token
      config.environment = :sandbox
      config.debug = true
    end
  end

  describe "#inspect" do
    it {
      expect(Kobana.configuration.inspect).to include("@api_token=\"[REDACTED]\"")
    }
  end

  describe "custom_headers" do
    it "initializes with an empty hash" do
      expect(Kobana.configuration.custom_headers).to eq({})
    end

    it "allows setting custom headers" do
      Kobana.configuration.custom_headers = { "X-Custom-Header" => "CustomValue" }
      expect(Kobana.configuration.custom_headers).to eq({ "X-Custom-Header" => "CustomValue" })
    end

    it "allows setting custom headers" do
      Kobana.configuration.custom_headers["X-Custom-Header"] = "CustomValue"
      expect(Kobana.configuration.custom_headers).to eq({ "X-Custom-Header" => "CustomValue" })
    end
  end

  describe "HTTP timeouts" do
    it "default to nil" do
      config = described_class.new

      expect(config.open_timeout).to be_nil
      expect(config.timeout).to be_nil
    end

    it "are assignable" do
      config = described_class.new
      config.open_timeout = 2
      config.timeout = 8

      expect(config.open_timeout).to eq(2)
      expect(config.timeout).to eq(8)
    end
  end
end

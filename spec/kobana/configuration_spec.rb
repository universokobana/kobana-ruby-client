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

  describe 'custom_headers' do
    it 'initializes with an empty hash' do
      expect(Kobana.configuration.custom_headers).to eq({})
    end

    it 'allows setting custom headers' do
      Kobana.configuration.custom_headers = { "X-Custom-Header" => "CustomValue" }
      expect(Kobana.configuration.custom_headers).to eq({ "X-Custom-Header" => "CustomValue" })
    end

    it 'allows setting custom headers' do
      Kobana.configuration.custom_headers["X-Custom-Header"] = "CustomValue"
      expect(Kobana.configuration.custom_headers).to eq({ "X-Custom-Header" => "CustomValue" })
    end
  end
end

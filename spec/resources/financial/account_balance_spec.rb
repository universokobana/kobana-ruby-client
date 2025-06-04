# frozen_string_literal: true

require "spec_helper"

RSpec.describe Kobana::Resources::Financial::AccountBalance do
  let!(:api_token) { ENV.fetch("KOBANA_API_TOKEN", nil) }

  before do
    Kobana.configure do |config|
      config.api_token = api_token
      config.environment = :sandbox
    end
  end

  describe "resource_endpoint" do
    it { expect(described_class.resource_endpoint).to eq("financial/account_balances") }
  end

end

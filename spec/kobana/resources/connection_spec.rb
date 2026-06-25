# frozen_string_literal: true

require "spec_helper"

# The :multipart middleware is required lazily by upload resources; load it here
# so build_multipart_connection can be exercised in isolation.
require "faraday/multipart"

RSpec.describe Kobana::Resources::Connection do
  # Any resource includes Connection; use a concrete one to reach the builders.
  let(:resource_class) { Kobana::Resources::Charge::Pix }

  let(:config) do
    Kobana::Configuration.new.tap do |c|
      c.api_token = "ANYTOKEN"
      c.environment = :sandbox
    end
  end

  def build_connection(cfg)
    resource_class.send(:build_connection, cfg)
  end

  def build_multipart_connection(cfg)
    resource_class.send(:build_multipart_connection, cfg)
  end

  describe "HTTP timeouts" do
    it "are nil by default (no behavior change)" do
      conn = build_connection(config)

      expect(conn.options.open_timeout).to be_nil
      expect(conn.options.timeout).to be_nil
    end

    it "are applied to the connection when configured" do
      config.open_timeout = 2
      config.timeout = 8

      conn = build_connection(config)

      expect(conn.options.open_timeout).to eq(2)
      expect(conn.options.timeout).to eq(8)
    end

    it "are applied to the multipart connection when configured" do
      config.open_timeout = 3
      config.timeout = 9

      conn = build_multipart_connection(config)

      expect(conn.options.open_timeout).to eq(3)
      expect(conn.options.timeout).to eq(9)
    end
  end
end

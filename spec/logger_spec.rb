# frozen_string_literal: true

require "spec_helper"

require "stringio"

def capture_stdout
  original_stdout = $stdout
  captured = StringIO.new
  $stdout = captured
  yield
  captured.string
ensure
  $stdout = original_stdout
end

RSpec.describe "Logger" do
  let!(:api_token) { ENV.fetch("KOBANA_API_TOKEN", nil) }

  before do
    Kobana.configure do |config|
      config.api_token = api_token
      config.environment = :sandbox
      config.debug = true
    end
  end

  describe "#create", vcr: { cassette_name: "resources/admin/subaccount/all" } do
    it {
      output = capture_stdout do
        Kobana::Resources::Admin::Subaccount.all
      end
      expect(output).to include('Authorization: "Bearer [REDACTED]"')
    }
  end
end

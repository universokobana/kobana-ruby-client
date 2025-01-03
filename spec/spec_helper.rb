# frozen_string_literal: true

require "kobana_ruby_client"
require "webmock/rspec"
require "vcr"
require "factory_bot"

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!

  config.before_record do |interaction|
    interaction.response.body.force_encoding("UTF-8")
  end

  config.filter_sensitive_data("<KOBANA_API_TOKEN>") { ENV.fetch("KOBANA_API_TOKEN", nil) }
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  # Disable random specs test
  config.order = :defined

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

FactoryBot.find_definitions

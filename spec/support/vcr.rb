# frozen_string_literal: true

VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  c.hook_into :faraday
  c.allow_http_connections_when_no_cassette = false
  c.configure_rspec_metadata!

  c.before_record do |interaction|
    interaction.response.body.force_encoding("UTF-8")
  end

  c.ignore_request do |request|
    request.uri.include?("datadoghq")
  end

  c.debug_logger = $stderr if ENV.fetch("VCR_DEBUG_ENABLED", false)

  ENV.each_pair do |key, value|
    next unless %w[ACCESS AUTH CHAVE KEY PASSWORD PWD PRIVATE SALT SECRET SENHA TOKEN URL].any? { |s| key.include?(s) }

    puts "Filtering sensitive data from VCR cassettes: #{key}"
    c.filter_sensitive_data("<#{key}>") { value }
  end

  c.filter_sensitive_data("<KOBANA_API_TOKEN>") { ENV.fetch("KOBANA_API_TOKEN", nil) }
end

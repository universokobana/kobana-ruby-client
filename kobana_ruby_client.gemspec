# frozen_string_literal: true

require_relative "lib/kobana_ruby_client/version"

Gem::Specification.new do |spec|
  spec.name = "kobana"
  spec.version = KobanaRubyClient::VERSION
  spec.authors = ["Kivanio Barbosa"]
  spec.email   = ["kivanio@gmail.com"]
  spec.summary = "Kobana API Client"
  spec.description = "Kobana API Client"
  spec.homepage = "https://www.kobana.com.br/"
  spec.required_ruby_version = ">= 3.2.6"

  spec.files = Dir["Rakefile", "{lib}/**/*", "README*", "LICENSE*", "CHANGELOG*"]

  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", ">= 1.4", "< 3.0"
  spec.add_dependency "json"

  spec.metadata = {
    "homepage_uri" => "https://github.com/universokobana/kobana-ruby-client",
    "changelog_uri" => "https://github.com/universokobana/kobana-ruby-client/releases",
    "source_code_uri" => "https://github.com/universokobana/kobana-ruby-client",
    "bug_tracker_uri" => "https://github.com/universokobana/kobana-ruby-client/issues",
    "documentation_uri" => "https://github.com/universokobana/kobana-ruby-client/wiki",
    "rubygems_mfa_required" => "true"
  }
end

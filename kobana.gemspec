# frozen_string_literal: true

require_relative "lib/kobana/version"

Gem::Specification.new do |spec|
  spec.name = "kobana"
  spec.version = Kobana::VERSION
  spec.authors = ["Kivanio Barbosa", "Rafael Lima"]
  spec.email   = ["kivanio@gmail.com", "rafael.lima@kobana.com.br"]
  spec.summary = "Kobana API Client"
  spec.description = "Kobana API Client"
  spec.homepage = "https://www.kobana.com.br/"
  spec.required_ruby_version = ">= 3.3"
  spec.platform = Gem::Platform::RUBY
  spec.license = "MIT"

  spec.files = Dir["Rakefile", "{lib}/**/*", "README*", "LICENSE*", "CHANGELOG*"]

  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", ">= 1.4", "< 3.0"
  spec.add_dependency "faraday-multipart"
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

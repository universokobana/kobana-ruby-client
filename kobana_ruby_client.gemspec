# frozen_string_literal: true

require_relative "lib/kobana_ruby_client/version"

Gem::Specification.new do |spec|
  spec.name = "kobana_ruby_client"
  spec.version = KobanaRubyClient::VERSION
  spec.authors = ["kobana"]

  spec.summary = "kobana ruby client"
  spec.description = "."
  spec.homepage = "https://www.kobana.com.br/"
  spec.required_ruby_version = ">= 3.2.6"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile]) ||
        f.end_with?(".gem")
    end
  end

  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dotenv"
  spec.add_dependency "factory_bot"
  spec.add_dependency "faraday", ">= 1.4", "< 3.0"
  spec.add_dependency "json"
  spec.add_dependency "lefthook"
  spec.add_dependency "rack"
  spec.add_dependency "rubocop"
  spec.add_dependency "vcr"
  spec.add_dependency "webmock"
  spec.metadata["rubygems_mfa_required"] = "true"
end

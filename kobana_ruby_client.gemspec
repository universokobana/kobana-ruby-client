# frozen_string_literal: true

require_relative "lib/kobana_ruby_client/version"

Gem::Specification.new do |spec|
  spec.name = "kobana_ruby_client"
  spec.version = KobanaRubyClient::VERSION
  spec.authors = ["kobana"]

  spec.summary = "kobana ruby client"
  spec.description = "."
  spec.homepage = "https://www.kobana.com.br/"
  spec.required_ruby_version = ">= 2.6.0"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile]) ||
        f.end_with?(".gem")
    end
  end

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dotenv"
  spec.add_dependency "factory_bot", "~> 6.2"
  spec.add_dependency "faraday", "~> 1.4"
  spec.add_dependency "json", "~> 2.5"
  spec.add_dependency "lefthook", "~> 0.7"
  spec.add_dependency "rack", ">= 2.2", "< 4.0"
  spec.add_dependency "rubocop"
  spec.add_dependency "vcr", "~> 6.0"
  spec.add_dependency "webmock", "~> 3.13"

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end

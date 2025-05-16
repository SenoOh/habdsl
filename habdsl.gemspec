# frozen_string_literal: true

require_relative "lib/habdsl/version"

Gem::Specification.new do |spec|
  spec.name          = "habdsl"
  spec.version       = Habdsl::VERSION
  spec.authors       = ["Nomura Laboratory"]
  spec.email         = [""]

  spec.summary       = "A DSL for generating openHAB-compatible config from Excel."
  spec.description   = "HABDSL is a DSL tool that reads Excel files and outputs openHAB-compatible DSL configuration."
  spec.homepage      = "https://github.com/nomlab/habdsl"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*", "bin/*", "README.md"]
  spec.bindir        = "bin"
  spec.executables   = ["habdsl_cli"]
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 3.3.0"

  spec.add_dependency "json", "~> 2.6.3"
  spec.add_dependency "roo", "~> 2.10.1"

  spec.add_development_dependency "rake", "~> 13.2.1"
  spec.add_development_dependency "rspec", "~> 3.13.0"
  spec.add_development_dependency "rubocop", "~> 1.75.5"
  spec.metadata["rubygems_mfa_required"] = "true"
end

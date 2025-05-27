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

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) {|f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 3.3.0"

  spec.add_dependency "json", "~> 2.6.3"
  spec.add_dependency "roo", "~> 2.10.1"
  spec.metadata["rubygems_mfa_required"] = "true"
end

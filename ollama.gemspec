# frozen_string_literal: true

require_relative "lib/ollama/version"

Gem::Specification.new do |spec|
  spec.name    = "ollama"
  spec.version = Ollama::VERSION
  spec.authors = ['Kane Hooper']
  spec.email   = ['kane.hooper@reinteractive.com']

  spec.summary       = %q{Ollama API Wrapper}
  spec.description   = %q{This gem provides a Ruby interface for interacting with the Ollama API.}
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Specify runtime dependencies here
  spec.add_runtime_dependency 'httparty', '~> 0.21.0'
  spec.add_runtime_dependency 'dry-schema', '~> 1.13.3'

  # Specify development dependencies here
  spec.add_development_dependency 'bundler', '2.5.7'
  spec.add_development_dependency 'pry-byebug', '3.10.1'
end

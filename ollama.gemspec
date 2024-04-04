Gem::Specification.new do |spec|
  spec.name          = 'ollama'
  spec.version       = '0.1.0'
  spec.authors       = ['Kane Hooper']
  spec.email         = ['kane.hooper@reinteractive.com']

  spec.summary       = %q{Ollama API Wrapper}
  spec.description   = %q{This gem provides a Ruby interface for interacting with the Ollama API.}
  spec.license       = 'MIT' 

  spec.files         = `git ls-files -z`.split("\x0").select do |f|
    f.match(%r{^(lib/|ollama.rb|LICENSE|README.md)})
  end
  spec.require_paths = ['lib']

  # Specify runtime dependencies here
  spec.add_runtime_dependency 'httparty', '~> 0.21.0'
  spec.add_runtime_dependency 'dry-schema', '~> 1.13.3'
  # spec.add_dependency 'dependency_name', '~> version'

  # Specify development dependencies here
  # spec.add_development_dependency 'rake', '~> 13.0'
end

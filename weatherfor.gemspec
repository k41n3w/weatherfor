require_relative 'lib/weatherfor/version'

Gem::Specification.new do |spec|
  spec.name          = "weatherfor"
  spec.version       = Weatherfor::VERSION
  spec.authors       = ["Caio Ramos"]
  spec.email         = ["kaineo@hotmai.l."]

  spec.summary       = 'Api to check the average weather forecast for the next five days'
  spec.description   = 'Sumario'
  spec.homepage      = "https://github.com/k41n3w/weatherfor"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end

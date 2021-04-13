# frozen_string_literal: true

require_relative 'lib/weatherfor/version'

Gem::Specification.new do |spec|
  spec.name          = 'weatherfor'
  spec.version       = Weatherfor::VERSION
  spec.authors       = ['Caio Ramos']
  spec.email         = ['kaineo@hotmai.l.']

  spec.summary       = 'Api to check the average weather forecast for the next five days'
  spec.description   = 'Sumario'
  spec.homepage      = 'https://github.com/k41n3w/weatherfor'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.4.0'

  spec.metadata['homepage_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end

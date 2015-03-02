# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lifx/http/version'

Gem::Specification.new do |spec|
  spec.name          = 'lifx-http'
  spec.version       = LIFX::HTTP::VERSION
  spec.authors       = ['Tate Johnson']
  spec.email         = ['tate@tatey.com']
  spec.summary       = %q{A nice Ruby client for the LIFX HTTP API}
  spec.description   = %q{A nice Ruby client for the LIFX HTTP API}
  spec.homepage      = 'https://github.com/tatey/lifx-http-client-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'pry', '~> 0.10.1 '
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2.0'
  spec.add_development_dependency 'vcr', '~> 2.9.3'
  spec.add_development_dependency 'webmock', '~> 1.20.4'
end

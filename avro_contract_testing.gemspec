# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'avro_contract_testing/version'

Gem::Specification.new do |spec|
  spec.name          = 'avro_contract_testing'
  spec.version       = AvroContractTesting::VERSION
  spec.authors       = ['Tania Abdollahi']
  spec.email         = ['tania.abdollahi@vts.com']
  spec.summary       = 'Provides utilities for running contract tests against avro schemas'
  spec.homepage      = 'https://github.com/tabdollahi/avro_contract_testing'
  spec.license       = 'MIT'
  spec.require_paths = ['lib']

  spec.add_dependency 'avro-patches', '~> 0.4'
  spec.add_dependency 'avro_turf', '~> 0.0'
  spec.add_dependency 'fog-aws', '~> 3.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'pry', '~> 0.12.2'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end

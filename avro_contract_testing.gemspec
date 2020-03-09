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
  spec.homepage      = 'https://github.com/viewthespace/avro_contract_testing'
  spec.license       = 'MIT'
  spec.require_paths = ['lib']

  spec.add_dependency 'avro', '~> 1.9.0'
  spec.add_dependency 'avro_turf', '~> 0.9'
  spec.add_dependency 'fog-aws', '~> 3.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rspec'
end

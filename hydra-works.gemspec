# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hydra/works/version'

Gem::Specification.new do |spec|
  spec.name          = 'hydra-works'
  spec.version       = Hydra::Works::VERSION
  spec.authors       = ['Justin Coyne']
  spec.email         = ['justin@curationexperts.com']
  spec.summary       = %q{Fundamental repository data model for hydra}
  spec.description   = %q{Using this data model should enable easy collaboration amongst hydra projects.}
  spec.homepage      = 'https://github.com/projecthydra-labs/hydra-works'
  spec.license       = 'APACHE2'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'hydra-pcdm', '>= 0.9'
  spec.add_dependency 'hydra-derivatives', '~> 3.0'
  spec.add_dependency 'hydra-file_characterization', '~> 0.3', '>= 0.3.3'
  spec.add_dependency 'om', '~> 3.1'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec-rails', '~> 3.1'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'solr_wrapper', '~> 0.4'
  spec.add_development_dependency 'fcrepo_wrapper', '~> 0.1'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'rspec'
end

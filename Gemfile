source 'https://rubygems.org'

# Specify your gem's dependencies in hydra-works.gemspec
gemspec

gem 'activefedora-aggregation', github: 'projecthydra-labs/activefedora-aggregation', ref: 'master'
gem 'hydra-pcdm', github: 'projecthydra-labs/hydra-pcdm', ref: 'master'
gem 'hydra-derivatives', github: 'projecthydra/hydra-derivatives', ref: '7a8377c'
gem 'slop', '~> 3.6' # For byebug

unless ENV['CI']
  gem 'pry'
  gem 'pry-byebug'
  gem 'byebug'
end

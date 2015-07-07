source 'https://rubygems.org'

# Specify your gem's dependencies in hydra-works.gemspec
gemspec

gem 'activefedora-aggregation', github: 'projecthydra-labs/activefedora-aggregation', ref: '0dfe4f4'
gem 'active-fedora', github: 'projecthydra/active_fedora', ref: 'caadc73'
gem 'hydra-pcdm', github: 'projecthydra-labs/hydra-pcdm', ref: '11f46014'
gem 'slop', '~> 3.6' # For byebug

unless ENV['CI']
  gem 'pry'
  gem 'pry-byebug'
  gem 'byebug'
end
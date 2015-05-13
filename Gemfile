source 'https://rubygems.org'

# Specify your gem's dependencies in hydra-works.gemspec
gemspec

gem 'activefedora-aggregation', github: 'projecthydra-labs/activefedora-aggregation'
gem 'active-fedora', github: 'projecthydra/active_fedora'
gem 'hydra-pcdm', github: 'projecthydra-labs/hydra-pcdm'
gem 'slop', '~> 3.6' # For byebug

unless ENV['CI']
  gem 'pry'
  gem 'pry-byebug'
  gem 'byebug'
end
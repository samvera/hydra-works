source 'https://rubygems.org'

gem 'activefedora-aggregation', github: 'projecthydra-labs/activefedora-aggregation',  branch: 'delete_ordered'

# Specify your gem's dependencies in hydra-works.gemspec
gemspec

gem 'slop', '~> 3.6' # For byebug

group :development, :test do
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'pry' unless ENV['CI']
  gem 'pry-byebug' unless ENV['CI']
end

source 'https://rubygems.org'

# Specify your gem's dependencies in hydra-works.gemspec
gemspec

gem 'slop', '~> 3.6' # For byebug

group :development, :test do
  gem 'hydra-pcdm', github: 'projecthydra-labs/hydra-pcdm', branch: 'namespace_vocabs'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'pry' unless ENV['CI']
  gem 'pry-byebug' unless ENV['CI']
end

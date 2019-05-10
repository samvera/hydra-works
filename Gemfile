source 'https://rubygems.org'

# Specify your gem's dependencies in hydra-works.gemspec
gemspec

gem 'slop', '~> 3.6' # For byebug

group :development, :test do
  gem 'rubocop', '~> 0.47.0', require: false
  gem 'rubocop-rspec', '~> 1.13.0', require: false
  gem 'pry' unless ENV['CI']
  gem 'pry-byebug' unless ENV['CI']
end

if ENV['RAILS_VERSION']
  if ENV['RAILS_VERSION'] == 'edge'
    gem 'rails', github: 'rails/rails'
  else
    gem 'rails', ENV['RAILS_VERSION']
  end
end

source 'https://rubygems.org'

# Specify your gem's dependencies in hydra-works.gemspec
gemspec

gem 'active-fedora', git: 'https://github.com/jrgriffiniii/active_fedora.git', branch: 'rails6-update'
gem 'hydra-derivatives', git: 'https://github.com/jrgriffiniii/hydra-derivatives.git', branch: 'rails6-update'
gem 'slop', '~> 3.6' # For byebug

group :development, :test do
  # gem 'rubocop', '~> 0.47.0', require: false
  gem 'rubocop', require: false
  # gem 'rubocop-rspec', '~> 1.13.0', require: false
  gem 'rubocop-rspec', require: false
  gem 'pry' unless ENV['CI']
  gem 'pry-byebug' unless ENV['CI']
  gem 'clamby'
end

if ENV['RAILS_VERSION']
  if ENV['RAILS_VERSION'] == 'edge'
    gem 'rails', github: 'rails/rails'
  else
    gem 'rails', ENV['RAILS_VERSION']
  end
else
  gem 'actionpack', '5.1.7'
  gem 'activemodel', '5.1.7'
  gem 'rails', '5.1.7'
end

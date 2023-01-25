source 'https://rubygems.org'

# Specify your gem's dependencies in hydra-works.gemspec
gemspec

gem 'active-triples', git: 'https://gitlab.com/cjcolvar/activetriples.git', branch: 'ruby3'
gem 'active-fedora', git: 'https://github.com/samvera/active_fedora.git', branch: 'ruby3'
gem 'hydra-derivatives', git: 'https://github.com/samvera/hydra-derivatives.git', branch: 'upgrade-ruby3.0-rails7'
gem 'hydra-file_characterization', git: 'https://github.com/samvera/hydra-file_characterization.git', branch: 'cjcolvar-patch-1'
gem 'hydra-pcdm', git: 'https://github.com/samvera/hydra-pcdm.git', branch: 'ruby3'

gem 'slop', '~> 3.6' # For byebug

group :development, :test do
  gem 'clamby'
  gem 'pry-byebug' unless ENV['CI']
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
end

if ENV['RAILS_VERSION']
  if ENV['RAILS_VERSION'] == 'edge'
    gem 'rails', github: 'rails/rails'
  else
    gem 'rails', ENV['RAILS_VERSION']
  end
end

require "bundler/gem_tasks"
require 'jettywrapper'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'engine_cart/rake_task'

RSpec::Core::RakeTask.new(:spec)
Jettywrapper.hydra_jetty_version = "master"

desc 'Spin up hydra-jetty and run specs'
task ci: ['jetty:clean'] do
  puts 'running continuous integration'
  jetty_params = Jettywrapper.load_config
  jetty_params[:startup_wait]= 90
  error = Jettywrapper.wrap(jetty_params) do
    Rake::Task['spec'].invoke
  end
  raise "test failures: #{error}" if error
end

task default: :ci



require 'bundler/gem_tasks'
require 'jettywrapper'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'engine_cart/rake_task'
require 'rubocop/rake_task'

desc 'Run style checker'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.requires << 'rubocop-rspec'
  task.fail_on_error = true
end

desc 'Run test suite and style checker'
task :spec do
  Rake::Task['rubocop'].invoke
  RSpec::Core::RakeTask.new(:spec)
end

desc 'Spin up hydra-jetty and run specs'
task ci: ['jetty:clean'] do
  puts 'running continuous integration'
  jetty_params = Jettywrapper.load_config
  jetty_params[:startup_wait] = 90
  error = Jettywrapper.wrap(jetty_params) do
    Rake::Task['spec'].invoke
  end
  fail "test failures: #{error}" if error
end

task default: :ci

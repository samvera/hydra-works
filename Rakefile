require 'bundler/gem_tasks'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'solr_wrapper'
require 'fcrepo_wrapper'

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

desc 'Spin up Solr & Fedora and run the test suite'
task :ci do
  solr_params = { port: 8985, verbose: true, managed: true }
  fcrepo_params = { port: 8986, verbose: true, managed: true }
  SolrWrapper.wrap(solr_params) do |solr|
    solr.with_collection(name: 'hydra-test', dir: File.join(File.expand_path('.', File.dirname(__FILE__)), 'solr', 'config')) do
      FcrepoWrapper.wrap(fcrepo_params) do
        Rake::Task['spec'].invoke
      end
    end
  end
end

task default: :ci

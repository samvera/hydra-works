require "bundler/gem_tasks"
require 'rubocop/rake_task'
require 'rake'
require 'rspec/core/rake_task'

desc "Run all rspec files"
RSpec::Core::RakeTask.new("spec")

RuboCop::RakeTask.new do |t|
  t.options << '--config=./.hound.yml'
end

task default: [:spec, :rubocop]

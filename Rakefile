require "bundler/gem_tasks"

require 'rspec/core/rake_task'
require 'ci/reporter/rake/rspec'

RSpec::Core::RakeTask.new(:spec)
task :default => :spec

task jenkins: ['ci:setup:rspec', :spec]

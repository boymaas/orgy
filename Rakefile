require "bundler/gem_tasks"

require 'rspec/core/rake_task'
require 'cucumber/rake/task'

desc 'Default: run specs'

# XXX: enable cucumber to run also in default test-suite.
# Travis cannot find ruby when executing `bin/org-mode`
task :default => :spec

desc "Run specs"
RSpec::Core::RakeTask.new

desc "Run cucumber features"
Cucumber::Rake::Task.new


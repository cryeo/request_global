require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rake/extensiontask"

task :build => :compile

Rake::ExtensionTask.new("request_global") do |ext|
  ext.lib_dir = "lib/request_global"
end

task :default => [:clobber, :compile, :spec]

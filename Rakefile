require "bundler/gem_tasks"
require "rake/testtask"
require "client"

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Run tests"
task :default => :test
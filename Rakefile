require 'bundler'
require 'rdoc/task'
require 'rake/testtask'

task :default => :test

Bundler::GemHelper.install_tasks

RDoc::Task.new do |task|
  task.rdoc_dir = 'doc'
  task.title    = 'BufferedTokenizer'
  task.rdoc_files.include('lib/**/*.rb')
end

Rake::TestTask.new :test do |t|
  t.libs << 'lib'
  t.test_files = FileList['test/**/*.rb']
end

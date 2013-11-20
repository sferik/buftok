require 'bundler'
require 'rdoc/task'

Bundler::GemHelper.install_tasks

RDoc::Task.new do |task|
  task.rdoc_dir = 'doc'
  task.title    = 'BufferedTokenizer'
  task.rdoc_files.include('lib/**/*.rb')
end

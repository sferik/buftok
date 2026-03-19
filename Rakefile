# frozen_string_literal: true

require "bundler"
require "rake/testtask"
require "rubocop/rake_task"
require "standard/rake"
require "yard"
require "yardstick/rake/measurement"
require "yardstick/rake/verify"

task default: %i[test lint steep yard verify_measurements mutant]

Yardstick::Rake::Measurement.new
Yardstick::Rake::Verify.new do |verify|
  verify.threshold = 100
end

RuboCop::RakeTask.new

desc "Run RuboCop and Standard"
task lint: %i[rubocop standard]

desc "Type check with Steep"
task :steep do
  sh "steep check"
end

desc "Run mutation testing"
task :mutant do
  sh "mutant run"
end

Bundler::GemHelper.install_tasks

YARD::Rake::YardocTask.new

Rake::TestTask.new :test do |t|
  t.libs << "lib"
  t.test_files = FileList["test/**/*.rb"]
end

desc "Benchmark the current implementation"
task :bench do
  require "benchmark"
  require File.expand_path("lib/buftok", __dir__)

  n = 50_000
  delimiter = "\n\n"

  frequency1 = 1000
  puts "generating #{n} strings, with #{delimiter.inspect} every #{frequency1} strings..."
  data1 = (0...n).map do |i|
    (((i % frequency1 == 1) ? "\n" : "") +
      ("s" * i) +
      ((i % frequency1).zero? ? "\n" : "")).freeze
  end

  frequency2 = 10
  puts "generating #{n} strings, with #{delimiter.inspect} every #{frequency2} strings..."
  data2 = (0...n).map do |i|
    (((i % frequency2 == 1) ? "\n" : "") +
      ("s" * i) +
      ((i % frequency2).zero? ? "\n" : "")).freeze
  end

  Benchmark.bmbm do |x|
    x.report("1 char, freq: #{frequency1}") do
      bt1 = BufferedTokenizer.new
      n.times { |i| bt1.extract(data1[i]) }
    end

    x.report("2 char, freq: #{frequency1}") do
      bt2 = BufferedTokenizer.new(delimiter)
      n.times { |i| bt2.extract(data1[i]) }
    end

    x.report("1 char, freq: #{frequency2}") do
      bt3 = BufferedTokenizer.new
      n.times { |i| bt3.extract(data2[i]) }
    end

    x.report("2 char, freq: #{frequency2}") do
      bt4 = BufferedTokenizer.new(delimiter)
      n.times { |i| bt4.extract(data2[i]) }
    end
  end
end

# frozen_string_literal: true

unless ENV["MUTANT"]
  require "simplecov"
  SimpleCov.start do
    enable_coverage :branch
    minimum_coverage line: 100, branch: 100
  end
end

require "minitest/autorun"
require "mutant/minitest/coverage"
require "buftok"

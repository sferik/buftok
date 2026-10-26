# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "minitest", "~> 6"
gem "mutant"
gem "mutant-minitest"
gem "rake", ">= 13"
gem "rubocop"
gem "rubocop-minitest"
gem "rubocop-performance"
gem "rubocop-rake"
gem "simplecov"
gem "standard"
gem "standard-performance"
gem "steep", ">= 2.1" if RUBY_VERSION >= "3.3" # Steep 2.1 requires Ruby 3.3+
gem "yard"
gem "yardstick"

group :development do
  # Duel requires Ruby 3.4 or later
  gem "duel", ">= 0.1.1" if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4")
  gem "stackprof", platforms: :mri
end

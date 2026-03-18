# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.version = "0.3.0"

  spec.authors = ["Tony Arcieri", "Martin Emde", "Erik Berlin"]
  spec.summary = "BufferedTokenizer extracts token delimited entities from a sequence of string inputs"
  spec.description = spec.summary
  spec.email = ["sferik@gmail.com", "martin.emde@gmail.com"]
  spec.files = %w[CONTRIBUTING.md LICENSE.txt README.md buftok.gemspec] + Dir["lib/**/*.rb"]
  spec.homepage = "https://github.com/sferik/buftok"
  spec.licenses = ["MIT"]
  spec.name = "buftok"
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 3.2"
  spec.required_rubygems_version = ">= 3.0"

  spec.metadata = {
    "allowed_push_host" => "https://rubygems.org",
    "bug_tracker_uri" => "#{spec.homepage}/issues",
    "changelog_uri" => "#{spec.homepage}/blob/master/CHANGELOG.md",
    "documentation_uri" => "https://rubydoc.info/gems/buftok/",
    "funding_uri" => "https://github.com/sponsors/sferik/",
    "homepage_uri" => spec.homepage,
    "rubygems_mfa_required" => "true",
    "source_code_uri" => spec.homepage
  }
end

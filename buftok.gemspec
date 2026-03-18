Gem::Specification.new do |spec|
  spec.version       = "0.3.0"

  spec.authors       = ["Tony Arcieri", "Martin Emde", "Erik Michaels-Ober"]
  spec.summary       = %q{BufferedTokenizer extracts token delimited entities from a sequence of string inputs}
  spec.description   = spec.summary
  spec.email         = ["sferik@gmail.com", "martin.emde@gmail.com"]
  spec.files         = %w(CONTRIBUTING.md LICENSE.txt README.md buftok.gemspec) + Dir["lib/**/*.rb"]
  spec.homepage      = "https://github.com/sferik/buftok"
  spec.licenses      = ["MIT"]
  spec.name          = "buftok"
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 3.2"
  spec.required_rubygems_version = ">= 3.0"

  spec.metadata = {
    "source_code_uri" => "https://github.com/sferik/buftok",
    "bug_tracker_uri" => "https://github.com/sferik/buftok/issues",
    "changelog_uri" => "https://github.com/sferik/buftok/blob/master/CHANGELOG.md",
  }
end

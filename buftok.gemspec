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
  spec.required_rubygems_version = ">= 1.3.5"

  spec.add_development_dependency "bundler", ">= 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rdoc"
  spec.add_development_dependency "test-unit"
end

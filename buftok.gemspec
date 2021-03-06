Gem::Specification.new do |spec|
  spec.add_development_dependency 'bundler', '~> 1.0'
  spec.authors       = ["Tony Arcieri", "Martin Emde", "Erik Michaels-Ober"]
  spec.description   = %q{BufferedTokenizer extracts token delimited entities from a sequence of arbitrary inputs}
  spec.email         = "sferik@gmail.com"
  spec.files         = %w(CONTRIBUTING.md LICENSE.md README.md buftok.gemspec) + Dir["lib/**/*.rb"]
  spec.homepage      = "https://github.com/sferik/buftok"
  spec.licenses      = ['MIT']
  spec.name          = "buftok"
  spec.require_paths = ["lib"]
  spec.required_rubygems_version = '>= 1.3.5'
  spec.summary       = spec.description
  spec.version       = "0.2.0"
end

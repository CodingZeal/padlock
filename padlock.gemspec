# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'padlock/version'

Gem::Specification.new do |spec|
  spec.name          = "padlock"
  spec.version       = Padlock::VERSION
  spec.authors       = ["Coding Zeal", "Adam Cuppy"]
  spec.email         = ["acuppy@gmail.com"]
  spec.description   = %q{Concurent editing collision prevention}
  spec.homepage      = "https://github.com/CodingZeal/padlock"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14.1"
  spec.add_development_dependency "generator_spec"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "activerecord", "~> 4.0.0"
end

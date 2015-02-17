# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'moki_ruby/version'

Gem::Specification.new do |spec|
  spec.name          = "moki_ruby"
  spec.version       = MokiRuby::VERSION
  spec.authors       = ["Trey Springer"]
  spec.email         = ["tspringer@bellycard.com"]
  spec.summary       = %q{A gem for interacting with the Moki Total Control API.}
  spec.description   = %q{Manage your MDM-controlled devices with Moki and the moki_ruby gem.}
  spec.homepage      = "https://www.github.com/bellycard/moki_ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'faraday'
  spec.add_dependency 'faraday_middleware'
  spec.add_dependency 'celluloid'
  spec.add_dependency 'celluloid-io'
  spec.add_dependency 'hashie'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end

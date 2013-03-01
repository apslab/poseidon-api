# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'poseidon-api/version'

Gem::Specification.new do |gem|
  gem.name          = "poseidon-api"
  gem.version       = Poseidon::Api::VERSION
  gem.authors       = ["Maximiliano Dello Russo"]
  gem.email         = ["maxidr@gmail.com"]
  gem.description   = %q{An API to interact with the Poseidon system}
  gem.summary       = %q{API client for Poseidon system}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end

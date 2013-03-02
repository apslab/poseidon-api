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

  gem.add_development_dependency('protest', '0.4.0')
  gem.add_development_dependency('vcr', '2.4.0')
  gem.add_development_dependency('webmock', '1.9.3')
  gem.add_dependency('curb', '0.8.3')
  
end

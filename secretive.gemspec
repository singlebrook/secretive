# -*- encoding: utf-8 -*-
require File.expand_path('../lib/secretive/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Singlebrook Technology"]
  gem.email         = ["info@singlebrook.com"]
  gem.description   = %q{Secretive converts variables in a YAML file into ENV vars. It's useful for storing API keys and other sensitive information.}
  gem.summary       = %q{Convert variables in a YAML file into ENV vars.}

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "secretive"
  gem.require_paths = ["lib"]
  gem.version       = Secretive::VERSION

  gem.add_dependency 'activesupport', '~> 3.2.0'
  gem.add_dependency 'heroku', '~> 2.0'
  gem.add_development_dependency 'rspec', '~> 2.9.0'
end

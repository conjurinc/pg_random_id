# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pg_random_id/version'

Gem::Specification.new do |gem|
  gem.name          = "pg_random_id"
  gem.version       = PgRandomId::VERSION
  gem.authors       = ["Rafał Rzepecki"]
  gem.email         = ["divided.mind@gmail.com"]
  gem.description   = %q{Easily use randomized keys instead of sequential values for your record surrogate ids.}
  gem.summary       = %q{Pseudo-random record ids in Postgres}
  gem.homepage      = "https://github.com/inscitiv/pg_random_id"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_development_dependency 'activerecord', '~>3.2'
  gem.add_development_dependency 'rspec', '~>2.12'
  gem.add_development_dependency 'sequel', '~>3.44'
  gem.add_development_dependency 'pg', '~>0.14'
  gem.add_development_dependency 'ci_reporter', '~>1.8'
  gem.add_development_dependency 'rake', '~>10.0'
end

# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pg_random_id/version'

Gem::Specification.new do |gem|
  gem.name          = "pg_random_id"
  gem.version       = PgRandomId::VERSION
  gem.authors       = ["Rafał Rzepecki"]
  gem.email         = ["divided.mind@gmail.com"]
  gem.description   = %q{Easily use randomized integers instead of sequential values for your record surrogate ids.}
  gem.summary       = %q{Pseudo-random record ids in Postgres}
  gem.homepage      = "https://github.com/dividedmind/pg_random_id"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  %w(activerecord rspec).each do |g|
    gem.add_development_dependency g
  end
end

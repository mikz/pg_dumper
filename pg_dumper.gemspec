# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "pg_dumper/version"

Gem::Specification.new do |s|
  s.name        = "pg_dumper"
  s.version     = PgDumper::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["mikz"]
  s.email       = ["mikz@o2h.cz"]
  s.homepage    = ""
  s.summary     = %q{Adds Rake tasks to easily dump postgresql database with or without data}
  s.description = %q{Provides abstraction layer between pg_dump utility and ruby. Also adds rake task to easily dump database with or without data.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rspec', '~> 2.7'
end

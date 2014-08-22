# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sidekiq-bossman/version'

Gem::Specification.new do |gem|
  gem.name          = "sidekiq-bossman"
  gem.version       = Sidekiq::Bossman::VERSION
  gem.authors       = ["Nick Zalabak"]
  gem.email         = ["techwhizbang@gmail.com"]
  gem.description   = %q{A Sidekiq utility that takes a programmatic approach to starting|stopping Sidekiq workers}
  gem.summary       = %q{Start|stop your Sidekiq workers with ease}
  gem.homepage      = "https://github.com/techwhizbang/sidekiq-bossman"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency(%q<sidekiq>, [">= 2.12.0"])
  gem.add_development_dependency(%q<rspec>, ["~> 2.12.0"])
  gem.add_development_dependency(%q<rake>, ["~> 10.0.3"])
end

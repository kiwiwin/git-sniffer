# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git_sniffer/version'

Gem::Specification.new do |gem|
  gem.name          = "git_sniffer"
  gem.version       = GitSniffer::VERSION
  gem.authors       = ["kiwi"]
  gem.email         = ["kiwi.swhite.coder@gmail.com"]
  gem.description   = %q{git is a widely used version control system. with this gem, we can analysis the git repository to get useful information.}
  gem.summary       = %q{gem for analysis git repository information.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end

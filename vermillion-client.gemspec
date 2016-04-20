require './lib/version'

Gem::Specification.new do |s|
  s.name          = 'vermillion-client'
  s.version       = Vermillion::VERSION
  s.date          = '2015-07-03'
  s.summary       = 'Client for communicating with vermillion-server'
  s.description   = 'Deploy, rebuild, rollback git-managed websites'
  s.authors       = ['Ryan Priebe']
  s.email         = 'hello@ryanpriebe.com'
  s.files         = `git ls-files`.split($\)
  s.homepage      = 'http://rubygems.org/gems/vermillion-client'
  s.license       = 'MIT'
  s.executables   = 'vermillion'

  s.add_runtime_dependency 'notifaction'
  s.add_runtime_dependency 'mime-types'

  s.add_development_dependency "bundler", "~> 1.10"
  s.add_development_dependency "rake", "~> 10.0"
end
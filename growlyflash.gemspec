# encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "growlyflash/version"

Gem::Specification.new do |spec|
  spec.name          = 'growlyflash'
  spec.version       = Growlyflash::VERSION
  spec.authors       = ['Tõnis Simo']
  spec.email         = ['anton.estum@gmail.com']
  spec.summary       = %q{Growl-styled flash messages for Ruby on Rails with Bootstrap.}
  spec.description   = %q{Growl-styled flash messages for Ruby on Rails with Bootstrap. For XHR requests flash messages are transfering in 'X-Messages' headers, otherwise they are storing in js variables.}
  spec.homepage      = 'https://github.com/estum/growlyflash'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 1.9.3"

  spec.add_dependency 'railties', '>= 3.2', '< 5.0'
  spec.add_dependency 'coffee-rails', '>= 3.2.1'
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end

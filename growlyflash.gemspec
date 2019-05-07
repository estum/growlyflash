# encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "growlyflash/version"

Gem::Specification.new do |spec|
  spec.name          = 'growlyflash'
  spec.version       = Growlyflash::VERSION
  spec.authors       = ['Tõnis Simo']
  spec.email         = ['anton.estum@gmail.com']
  spec.summary       = %q{Popup ActionDispatch::Flash within Bootstrap alert in Rails app like a growl notification.}
  spec.description   = %q{This gem popups Rails' ActionDispatch::Flash within Bootstrap alert like a growl notification. It serves messages with both of AJAX (XHR) and regular requests inside HTTP headers.}
  spec.homepage      = 'https://github.com/estum/growlyflash'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 1.9.3"

  spec.add_dependency 'railties', '>= 3.2'
  spec.add_dependency 'coffee-rails', '>= 3.2.1'
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end

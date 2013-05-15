# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'growlyflash/version'

Gem::Specification.new do |spec|
  spec.name          = "growlyflash"
  spec.version       = Growlyflash::VERSION
  spec.authors       = ["Tõnis Simo"]
  spec.email         = ["anton.estum@gmail.com"]
  spec.homepage      = "https://github.com/tonissimo/growlyflash"
  spec.summary       = %q{Tiny gem which provides growl-styled flash messages for Ruby on Rails with Bootstrap.}
  spec.description   = %q{Tiny gem which provides growl-styled flash messages for Ruby on Rails with Bootstrap. For XHR requests flash messages are transfering in 'X-Messages' headers, otherwise they are storing in js variables.}

  spec.files         = `git ls-files`.split($/)
  spec.require_paths = %w(lib vendor)
  
  spec.add_dependency "railties", "~> 3.1"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rails",        '>= 3.2.0'
  spec.add_development_dependency 'coffee-rails', '~> 3.2.1'
  spec.add_development_dependency "bundler",      "~> 1.3"
end

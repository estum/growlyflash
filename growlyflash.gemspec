# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "growlyflash"
  spec.version       = "0.5.0"
  spec.authors       = ["Tõnis Simo"]
  spec.email         = ["anton.estum@gmail.com"]
  spec.homepage      = "https://github.com/estum/growlyflash"
  spec.summary       = %q{Tiny gem which provides growl-styled flash messages for Ruby on Rails with Bootstrap.}
  spec.description   = %q{Tiny gem which provides growl-styled flash messages for Ruby on Rails with Bootstrap. For XHR requests flash messages are transfering in 'X-Messages' headers, otherwise they are storing in js variables.}
  spec.license       = "MIT"
  
  spec.files         = `git ls-files`.split($/)
  spec.require_paths = %w[app lib]
  
  spec.add_dependency "railties", ">= 3.2", "< 5.0"
  spec.add_dependency 'coffee-rails', ">= 3.2.1"
end
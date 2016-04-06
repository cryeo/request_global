# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'request_global/version'

Gem::Specification.new do |spec|
  spec.name          = "request_global"
  spec.version       = RequestGlobal::VERSION
  spec.authors       = ["Chaerim Yeo"]
  spec.email         = ["yeochaerim@gmail.com"]

  spec.summary       = "Global storage per request for Rails"
  spec.description   = "RequestGlobal provides global storage per request for Rails"
  spec.homepage      = "http://github.com/cryeo/request_global"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.extensions    = ["ext/request_global/extconf.rb"]

  spec.required_ruby_version = '>= 2.1.5'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rake-compiler", "~> 0"
  spec.add_development_dependency "rspec", "~> 3.0"
end

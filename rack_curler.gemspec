# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack_curler/version'

Gem::Specification.new do |spec|
  spec.name          = "rack_curler"
  spec.version       = RackCurler::VERSION
  spec.authors       = ["Nathan Speed"]
  spec.email         = ["speedarius@gmail.com"]
  spec.description   = %q{Generate curl commands that approximate rack requests.}
  spec.summary       = %q{Given a rack env, generate a prettified curl command that approximates the request, including headers and request body. Suitable for debugging.}
  spec.homepage      = "https://github.com/speedarius/rack_curler"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rack"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.6"
end

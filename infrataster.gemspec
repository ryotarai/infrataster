# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'infrataster/version'

Gem::Specification.new do |spec|
  spec.name          = "infrataster"
  spec.version       = Infrataster::VERSION
  spec.authors       = ["Ryota Arai"]
  spec.email         = ["ryota.arai@gmail.com"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rspec"
  spec.add_runtime_dependency "net-ssh"
  spec.add_runtime_dependency "net-ssh-gateway"
  spec.add_runtime_dependency "mysql2"
  spec.add_runtime_dependency "capybara"
  spec.add_runtime_dependency "selenium-webdriver"
  spec.add_runtime_dependency "browsermob-proxy"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end

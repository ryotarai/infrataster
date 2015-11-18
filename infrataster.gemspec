# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'infrataster/version'

Gem::Specification.new do |spec|
  spec.name          = "infrataster"
  spec.version       = Infrataster::VERSION
  spec.authors       = ["Ryota Arai"]
  spec.email         = ["ryota.arai@gmail.com"]
  spec.summary       = %q{Infrastructure Behavior Testing Framework}
  spec.homepage      = "https://github.com/ryotarai/infrataster"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").delete_if do |path|
    path.start_with?('example/') ||
      path.start_with?('ci/')
  end
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rspec", ['>= 2.0', '< 4.0']
  spec.add_runtime_dependency "net-ssh"
  spec.add_runtime_dependency "net-ssh-gateway"
  spec.add_runtime_dependency "capybara"
  spec.add_runtime_dependency "poltergeist"
  spec.add_runtime_dependency "faraday"
  spec.add_runtime_dependency "faraday_middleware", '>= 0.10.0'
  spec.add_runtime_dependency "thor"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "itamae"
end

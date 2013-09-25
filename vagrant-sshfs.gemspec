# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-sshfs/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-sshfs"
  spec.version       = Vagrant::SshFs::VERSION
  spec.authors       = ["fabiokr"]
  spec.email         = ["fabiokr@gmail.com"]
  spec.description   = "A Vagrant plugin that mounts sshfs in the host machine."
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/fabiokr/vagrant-sshfs"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end

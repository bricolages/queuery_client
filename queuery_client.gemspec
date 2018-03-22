# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'queuery_client/version'

Gem::Specification.new do |spec|
  spec.name          = "queuery_client"
  spec.version       = QueueryClient::VERSION
  spec.authors       = ["Hidekazu Kobayashi"]
  spec.email         = ["hidekazu-kobayashi@cookpad.com"]
  spec.license       = "MIT"

  spec.summary       = "Client library for Queuery Redshift HTTP API"
  spec.homepage      = "https://github.com/bricolages/queuery_client"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'garage_client'
  spec.add_dependency "redshift-connector-data_file", ">= 7.1"
  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
end

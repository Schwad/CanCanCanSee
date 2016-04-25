# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'CanCanCanSee/version'

Gem::Specification.new do |spec|
  spec.name          = "CanCanCanSee"
  spec.version       = CanCanCanSee::VERSION
  spec.authors       = ["Nick Schwaderer"]
  spec.email         = ["nicholas.schwaderer@gmail.com"]

  spec.summary       = %q{Allows user to access read-only list of roles and abilities in controller and view}
  spec.description   = %q{Allows user to access read-only list of roles and abilities in controller and vie}
  spec.homepage      = "https://github.com/schwad/cancancansee"
  spec.license       = "SCHWAD LICENSE"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = Dir['lib/**/*.rb']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

end

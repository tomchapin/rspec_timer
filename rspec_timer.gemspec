# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec_timer/version'

Gem::Specification.new do |spec|
  spec.name    = "rspec_timer"
  spec.version = RspecTimer::VERSION
  spec.authors = ["Tom Chapin"]
  spec.email   = ["tchapin@gmail.com"]

  spec.summary     = %q{Measure how long each of your RSpec tests take}
  spec.description = <<-QUOTE.gsub(/^    /, '')
    RSpecTimer will track the amount of time each of your tests take to complete,
    and when it's done, can save the data to a YAML file.
  QUOTE
  spec.date     = Time.now.utc.strftime("%Y-%m-%d")
  spec.homepage = "http://github.com/tomchapin/rspec_timer"
  spec.license  = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0'
  spec.add_runtime_dependency 'method_source', '~> 0.8', '>= 0.8.2'
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end

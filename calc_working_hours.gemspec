# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'calc_working_hours/version'

Gem::Specification.new do |spec|
  spec.name          = "calc_working_hours"
  spec.version       = CalcWorkingHours::VERSION
  spec.authors       = ["Takashi_U"]
  spec.email         = [""]
  spec.description   = %q{例えば、173:08のような表記の時間を計算するライブラリです}
  spec.summary       = %q{時間計算}
  spec.homepage      = "http://uchibe.net"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

#  spec.add_runtime_dependency "activesupport"
end

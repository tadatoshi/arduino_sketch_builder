# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arduino_sketch_builder/version'

Gem::Specification.new do |gem|
  gem.name          = "arduino_sketch_builder"
  gem.version       = ArduinoSketchBuilder::VERSION
  gem.authors       = ["Tadatoshi Takahashi"]
  gem.email         = ["tadatoshi@gmail.com"]
  gem.description   = "Builds Arduino sketch"
  gem.summary       = "Performs calling the code to compile Arduino sketch and upload it to Arduino by Ruby, instead of using Arduino IDE."
  gem.homepage      = "https://github.com/tadatoshi/arduino_sketch_builder"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "activesupport"
  gem.add_development_dependency "rspec"  
end

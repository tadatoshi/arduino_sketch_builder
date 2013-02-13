# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arduino_sketch_builder/version'

Gem::Specification.new do |gem|
  gem.name          = "arduino_sketch_builder"
  gem.version       = ArduinoSketchBuilder::VERSION
  gem.authors       = ["Tadatoshi Takahashi"]
  gem.email         = ["tadatoshi@gmail.com"]
  gem.description   = %q{Builds Arduino sketch}
  gem.summary       = %q{Performs calling the code to compile Arduino sketch and upload it to Arduino by Ruby, instead of using Arduino IDE.}
  gem.homepage      = "https://github.com/tadatoshi/arduino_sketch_builder"

  gem.files         = `git ls-files`.split($/)
  # gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "activesupport"
  gem.add_development_dependency "rspec"  

  # The following code is a modified code based on http://somethingaboutcode.wordpress.com/2012/09/27/include-files-from-git-submodules-when-building-a-ruby-gem/
  # get an array of submodule dirs by executing 'pwd' inside each submodule
  `git submodule --quiet foreach pwd`.split($\).each do |submodule_path|

    relative_submodule_path = submodule_path.gsub(Dir.pwd, '')

    # for each submodule, change working directory to that submodule
    Dir.chdir(submodule_path) do
 
      # issue git ls-files in submodule's directory
      submodule_files = `git ls-files`.split($\)
 
      # prepend the submodule path relative to the gem's root dir to create file paths
      submodule_files_paths = submodule_files.map do |filename|
        File.join(relative_submodule_path, filename)
      end
 
      # add relative paths to gem.files
      gem.files += submodule_files_paths
    end
  end  
end

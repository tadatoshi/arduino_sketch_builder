# ArduinoSketchBuilder

Performs calling the code to compile Arduino sketch and upload it to Arduino
by Ruby, instead of using Arduino IDE.

## Installation

Add this line to your application's Gemfile:

    gem 'arduino_sketch_builder'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install arduino_sketch_builder

## Requirements

Ruby 2.0.0 or more. 

 * If ARDUINO_DEFAULT_BOARD and ARDUINO_DEFAULT_PORT are used to specify the board ID (e.g uno) and the port (e.g. /dev/tty.usbmodem411) instead of passing them to the method in Ruby code, works with Ruby 1.9.3, too. 
 * Strongly recommended to use Ruby 2.0.0 since this gem is intended to use its benefits and Ruby 2.0.0 is compatible with Ruby 1.9.3 if you need to run other code written for Ruby 1.9.3 with this gem. 

Arduino SDK version 0.19 or higher. 

cmake - http://www.cmake.org/cmake/resources/software.html

### Arduino CMake

This gem uses the code from **Arduino CMake** (https://github.com/queezythegreat/arduino-cmake). 

Originally, **Arduino CMake** was included as GIT submodule in this gem. 
But there was a problem so now the necessary **Arduino CMake** codes are copied in this gem (arduino-cmake directory). 

## Usage

### Directory structure

This is based on the directory structure by **Arduino CMake** with modification to make the directory structure for each Arduino sketch indepedent from each other. Also GIT related files (such as .gitignore and .gitkeep) are automatically added (but doesn't execute GIT commands so if GIT is not used, those files can be simply ignored). 

The default directory structure is 

    (root directory)
      |- cmake
      |    |- ArduinoToolchain.cmake
      |    |- Platform
      |        |- Arduino.cmake  
      |- (name of Arduino sketch underlined)
           |--build
           |--src
           |   |--(name of Arduino sketch)
           |        |--(Arduino sketch file)
           |   |--CMakeLists.txt
           |--CMakeLists.txt  

example:

    ~/.arduino_sketches  
      |- cmake
      |    |- ArduinoToolchain.cmake
      |    |- Platform
      |        |- Arduino.cmake  
      |- blink_customized
           |--build
           |--src
           |   |--BlinkCustomized
           |        |--BlinkCustomized.ino
           |   |--CMakeLists.txt
           |--CMakeLists.txt    

### Arduino board type and port to access the board

The default board ID: uno

The default port: /dev/tty.usbmodem411

You can change them by setting ARDUINO_DEFAULT_BOARD and ARDUINO_DEFAULT_PORT environment variables. 

### Code example

#### Setting up the directory structure - like the one above under cmake directory

    require "arduino_sketch_builder"

    setup = ArduinoSketchBuilder::Setup.new

    # Configuring ArduinoSketchBuilder (copies cmake directory under the specified root_directory):
    root_directory = File.expand_path('~/.arduino_sketches')
    setup.configure(root_directory)  

#### Setting up the sketch specific directory structure and files - like the one above under (name of Arduino sketch underlined) directory

    require "arduino_sketch_builder"

    setup = ArduinoSketchBuilder::Setup.new

    # Configuring ArduinoSketchBuilder (copies cmake directory under the specified root_directory):
    root_directory = File.expand_path('~/.arduino_sketches')
    arduino_sketch_file_path = File.expand_path('~/temp/BlinkCustomized.ino')
    setup.setup(root_directory, arduino_sketch_file_path)  

#### Executing cmake commands - compile, make, and make upload

    require "arduino_sketch_builder"

    arduino_cmake_build = ArduinoSketchBuilder::ArduinoCmakeBuild.new

    main_directory = File.expand_path('~/.arduino_sketches/blink_customized')
    build_directory = File.join(main_directory, "build")

    # Execute cmake
    #   raises error if state at the point of execution is not :initial    
    #   Success: state == :cmake_complete
    #   Failure: state == :cmake_incomplete
    #   arduino_cmake_build.message gives message such as error message in case of failure. 
    state = arduino_cmake_build.cmake(build_directory, main_directory)

    # Execute make
    #   raises error if state at the point of execution is not :cmake_complete    
    #   Success: state == :make_complete
    #   Failure: state == :make_incomplete
    #   arduino_cmake_build.message gives message such as error message in case of failure. 
    state = arduino_cmake_build.make(build_directory)    

    # Execute make upload
    #   raises error if state at the point of execution is not :make_complete    
    #   Success: state == :make_upload_complete
    #   Failure: state == :make_upload_incomplete
    #   arduino_cmake_build.message gives message such as error message in case of failure. 
    state = arduino_cmake_build.make_upload(build_directory)     

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

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

Arduino SDK version 0.19 or higher. 

cmake - http://www.cmake.org/cmake/resources/software.html

### Arduino CMake

This gem uses the code from **Arduino CMake** (https://github.com/queezythegreat/arduino-cmake). 

Originally, **Arduino CMake** was included as GIT submodule in this gem. 
But there was a problem so now the necessary **Arduino CMake** codes are copied in this gem (arduino-cmake directory). 

## Usage

### Directory structure

This is based on the directory structure by **Arduino CMake** with modification to make the directory structure for each Arduino sketch indepedent from each other. 

It is also for not putting cmake related files in the default Arduino directory used by Arduino IDE. 

This directory structure can be set up the code from this gem (See "Code example" below). 

Also GIT related files (such as .gitignore and .gitkeep) are automatically added (but doesn't execute GIT commands so if GIT is not used, those files can be simply ignored). 

The default directory structure is 

    (root directory)
      |- cmake
      |    |- ArduinoToolchain.cmake
      |    |- Platform
      |        |- Arduino.cmake 
      |- libraries 
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
      |- libraries 
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

You can specify them through ArduinoSketchBuilder::Setup.new.setup method (See "Code example" section below). 

You can also change them by setting ARDUINO_DEFAULT_BOARD and ARDUINO_DEFAULT_PORT environment variables at runtime. 

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
    # Path to the sketch to be put under the directory structure:
    arduino_sketch_file_path = File.expand_path('~/temp/BlinkCustomized.ino')
    setup.setup(root_directory, arduino_sketch_file_path)  

If Arduino board type and port are different from the default, 

    require "arduino_sketch_builder"

    setup = ArduinoSketchBuilder::Setup.new

    # Configuring ArduinoSketchBuilder (copies cmake directory under the specified root_directory):
    root_directory = File.expand_path('~/.arduino_sketches')
    # Path to the sketch to be put under the directory structure:
    arduino_sketch_file_path = File.expand_path('~/temp/BlinkCustomized.ino')
    setup.setup(root_directory, arduino_sketch_file_path, board_type: "diecimila", board_port: "/dev/cu.usbmodem411")

#### Building and uploading the sketch

    require "arduino_sketch_builder"

    main_directory = File.expand_path('~/.arduino_sketches/blink_customized')
    build_directory = File.join(main_directory, "build")

    # Instantiate ArduinoCmakeBuild with state == :initial (It's a state machine):
    arduino_cmake_build = ArduinoSketchBuilder::ArduinoCmakeBuild.new(main_directory, build_directory)

    # Build and upload
    #   raises error if state at the point of execution is not :initial (i.e. precondition: state == :initial)  
    #   Success: state == :make_upload_complete
    #   Failure: state == :cmake_incomplete, :make_incomplete, or :make_upload_incomplete depending on the step at the time of the failure
    #   arduino_cmake_build.message gives message such as error message in case of failure. 
    state = arduino_cmake_build.build_and_upload      

#### (Optional: individual steps for "Building and uploading the sketch" above): Executing cmake commands - compile, make, and make upload

    require "arduino_sketch_builder"

    main_directory = File.expand_path('~/.arduino_sketches/blink_customized')
    build_directory = File.join(main_directory, "build")

    # Instantiate ArduinoCmakeBuild with state == :initial (It's a state machine):
    arduino_cmake_build = ArduinoSketchBuilder::ArduinoCmakeBuild.new(main_directory, build_directory)

    # Execute cmake
    #   raises error if state at the point of execution is not :initial (i.e. precondition: state == :initial)
    #   Success: state == :cmake_complete
    #   Failure: state == :cmake_incomplete
    #   arduino_cmake_build.message gives message such as error message in case of failure. 
    state = arduino_cmake_build.cmake

    # Execute make
    #   raises error if state at the point of execution is not :cmake_complete (i.e. precondition: state == :cmake_complete)
    #   Success: state == :make_complete
    #   Failure: state == :make_incomplete
    #   arduino_cmake_build.message gives message such as error message in case of failure. 
    state = arduino_cmake_build.make    

    # Execute make upload
    #   raises error if state at the point of execution is not :make_complete (i.e. precondition: state == :make_complete)  
    #   Success: state == :make_upload_complete
    #   Failure: state == :make_upload_incomplete
    #   arduino_cmake_build.message gives message such as error message in case of failure. 
    state = arduino_cmake_build.make_upload     

## TODOS

 - The library should be able to be put under (root directory)/libraries

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

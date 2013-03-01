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

Works with Ruby 1.9.3 and Ruby 2.0.0 (Tested with them). 

Arduino SDK version 0.19 or higher. 

### Arduino CMake

This gem uses the code from **Arduino CMake** (https://github.com/queezythegreat/arduino-cmake). 

Originally, **Arduino CMake** was included as GIT submodule in this gem. 
But there was a problem so now the necessary **Arduino CMake** codes are copied in this gem (arduino-cmake directory). 

## Usage

### Directory structure

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

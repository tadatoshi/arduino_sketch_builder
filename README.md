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

## Usage

### Arduino CMake

This section describes the usage for the portion based on **Arduino CMake** (https://github.com/queezythegreat/arduino-cmake)

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
~/.uploaded_arduino_sketches  
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

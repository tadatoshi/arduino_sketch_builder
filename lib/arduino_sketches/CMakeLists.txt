#=============================================================================#
# Author: Tadatoshi Takahashi                                                 #
# Date:   30.01.2013                                                          #
#                                                                             #
# Description: Arduino CMake for arduino_sketch_builder                       #
#                                                                             #
#=============================================================================#
set(CMAKE_TOOLCHAIN_FILE ../../arduino-cmake/cmake/ArduinoToolchain.cmake) # Arduino Toolchain


cmake_minimum_required(VERSION 2.8)
#====================================================================#
#  Setup Project                                                     #
#====================================================================#
project(ArduinoSketchBuilder C CXX)

print_board_list()
print_programmer_list()

add_subdirectory(src)   #add the src directory (lib/arduino_sketches/src) into build

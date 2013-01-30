# This configuration file outlines some of the ways Arduino CMake
# can be used. For a detailed explenation of all the options please
# reade README.rst.

set(ARDUINO_DEFAULT_BOARD uno) # Default Board ID, when not specified
set(ARDUINO_DEFAULT_PORT /dev/tty.usbmodem411) # Default Port, when not specified

#====================================================================#
# BlinkCustomized
#====================================================================#
generate_arduino_firmware(blink_customized
    SKETCH BlinkCustomized
    PROGRAMMER tadatoshi
    NO_AUTOLIBS)
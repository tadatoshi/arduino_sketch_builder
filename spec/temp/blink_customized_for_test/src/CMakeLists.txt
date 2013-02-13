set(ARDUINO_DEFAULT_BOARD uno) # Default Board ID, when not specified
set(ARDUINO_DEFAULT_PORT /dev/tty.usbmodem411) # Default Port, when not specified

#====================================================================#
# BlinkCustomizedForTest
#====================================================================#
generate_arduino_firmware(blink_customized_for_test
    SKETCH BlinkCustomizedForTest
    PROGRAMMER arduino_sketch_builder
    NO_AUTOLIBS)
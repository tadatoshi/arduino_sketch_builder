// automatically generated by arduino-cmake
#line 1 "/Users/tadatoshi/Documents/development/projects/arduino_sketch_builder/spec/arduino_sketches_fixture/src/BlinkCustomizedForTest/BlinkCustomizedForTest.ino"
/*
  BlinkCustomizedForTest
  Turns on an LED on for two second, then off for two second, repeatedly.
 
  This code is used for testing arduino_sketch_builder gem.
 */

#line 10 "/Users/tadatoshi/Documents/development/projects/arduino_sketch_builder/spec/arduino_sketches_fixture/build/src/blink_customized_for_test_BlinkCustomizedForTest.cpp"
#include "Arduino.h"

//=== START Forward: /Users/tadatoshi/Documents/development/projects/arduino_sketch_builder/spec/arduino_sketches_fixture/src/BlinkCustomizedForTest/BlinkCustomizedForTest.ino
 void setup() ;
 void setup() ;
 void loop() ;
 void loop() ;
//=== END Forward: /Users/tadatoshi/Documents/development/projects/arduino_sketch_builder/spec/arduino_sketches_fixture/src/BlinkCustomizedForTest/BlinkCustomizedForTest.ino
#line 6 "/Users/tadatoshi/Documents/development/projects/arduino_sketch_builder/spec/arduino_sketches_fixture/src/BlinkCustomizedForTest/BlinkCustomizedForTest.ino"


void setup() {                
  // initialize the digital pin as an output.
  // Pin 13 has an LED connected on most Arduino boards:
  pinMode(13, OUTPUT);     
}

void loop() {
  digitalWrite(13, HIGH);   // set the LED on
  delay(2000);              // wait for a second
  digitalWrite(13, LOW);    // set the LED off
  delay(2000);              // wait for a second
}

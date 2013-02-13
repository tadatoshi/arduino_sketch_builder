require 'spec_helper'

describe ArduinoSketchBuilder::Setup do

  FIXTURES_DIRECTORY = File.expand_path('../../fixtures', __FILE__)
  ARDUINO_SKETCHES_FIXTURE_DIRECTORY = File.expand_path('../../arduino_sketches_fixture', __FILE__)
  ARDUINO_SKETCH_FILE_PATH = File.expand_path(File.join(ARDUINO_SKETCHES_FIXTURE_DIRECTORY, 'src/BlinkCustomizedForTest/BlinkCustomizedForTest.ino'), __FILE__)
  TEMP_DIRECTORY = File.expand_path('../../temp', __FILE__)

  before(:each) do
  	FileUtils.rm_rf(Dir.glob("#{TEMP_DIRECTORY}/*"))
    @setup = ArduinoSketchBuilder::Setup.new
  end

  it "should configure the root directory by putting cmake directory and its contents from arduino-cmake submodule"

  it "should create a directory structure for an Arduino sketch" do

    @setup.setup(TEMP_DIRECTORY, ARDUINO_SKETCH_FILE_PATH)

    Dir.exists?(File.join(TEMP_DIRECTORY, "blink_customized_for_test")).should be_true
    File.exists?(File.join(TEMP_DIRECTORY, "blink_customized_for_test", "CMakeLists.txt")).should be_true
    Dir.exists?(File.join(TEMP_DIRECTORY, "blink_customized_for_test", "src")).should be_true
    File.exists?(File.join(TEMP_DIRECTORY, "blink_customized_for_test", "src", "CMakeLists.txt")).should be_true
    Dir.exists?(File.join(TEMP_DIRECTORY, "blink_customized_for_test", "src", "BlinkCustomizedForTest")).should be_true
    File.exists?(File.join(TEMP_DIRECTORY, "blink_customized_for_test", "src", "BlinkCustomizedForTest", "BlinkCustomizedForTest.ino")).should be_true
    Dir.exists?(File.join(TEMP_DIRECTORY, "blink_customized_for_test", "build")).should be_true

    # The following checks the generated file with the full path, hence, system specific (e.g. /Users/tadatoshi). 
    # Hence, it's considered that the unit test for c_make_lists_file_generator covers it. 
    # File.read(File.join(TEMP_DIRECTORY, "blink_customized_for_test", "CMakeLists.txt")).should == File.read(File.join(FIXTURES_DIRECTORY, "MainCMakeLists.txt"))
    # This one also, it's considered that the unit test for c_make_lists_file_generator covers it.
    # File.read(File.join(TEMP_DIRECTORY, "blink_customized_for_test", "src", "CMakeLists.txt")).should == File.read(File.join(FIXTURES_DIRECTORY, "CMakeListsForTestSketch.txt"))
    File.read(File.join(TEMP_DIRECTORY, "blink_customized_for_test", "src", "BlinkCustomizedForTest", "BlinkCustomizedForTest.ino")).should == File.read(File.join(ARDUINO_SKETCHES_FIXTURE_DIRECTORY, "src", "BlinkCustomizedForTest", "BlinkCustomizedForTest.ino"))    

  end


end
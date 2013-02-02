require 'spec_helper'

describe ArduinoSketchBuilder::ArduinoCmakeBuild do

  MAIN_DIRECTORY = File.expand_path('../../arduino_sketches_fixture', __FILE__)
  BUILD_DIRECTORY = "#{MAIN_DIRECTORY}/build"

  before(:each) do
  	FileUtils.rm_rf(Dir.glob(File.expand_path('../../arduino_sketches_fixture/build/*', __FILE__)))
    @arduino_cmake_build = ArduinoSketchBuilder::ArduinoCmakeBuild.new
  end

  after(:each) do
    FileUtils.rm_rf(Dir.glob(File.expand_path('../../arduino_sketches_fixture/build/*', __FILE__)))
  end  

  it "should execute cmake and make in sequence in build directory" do

    @arduino_cmake_build.state.should == :initial
    File.exists?("#{BUILD_DIRECTORY}/Makefile").should be_false

    @arduino_cmake_build.cmake(BUILD_DIRECTORY, MAIN_DIRECTORY)

    @arduino_cmake_build.state.should == :cmake_complete
    File.exists?("#{BUILD_DIRECTORY}/Makefile").should be_true

    File.exists?("#{BUILD_DIRECTORY}/src/blink_customized_for_test.hex").should be_false

    @arduino_cmake_build.make(BUILD_DIRECTORY)

    @arduino_cmake_build.state.should == :make_complete
    File.exists?("#{BUILD_DIRECTORY}/src/blink_customized_for_test.hex").should be_true

  end

end
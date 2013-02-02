require 'spec_helper'

describe ArduinoSketchBuilder::ArduinoCmakeBuild do

  before(:each) do
  	FileUtils.rm_rf(Dir.glob(File.expand_path('../../arduino_sketches_fixture/build/*', __FILE__)))
    @arduino_cmake_build = ArduinoSketchBuilder::ArduinoCmakeBuild.new
  end

  it "should execute cmake in build directory" do

    @arduino_cmake_build.state.should == :initial
    File.exists?(File.expand_path('../../arduino_sketches_fixture/build/Makefile', __FILE__)).should be_false

    @arduino_cmake_build.cmake(File.expand_path('../../arduino_sketches_fixture/build', __FILE__), File.expand_path('../../arduino_sketches_fixture', __FILE__))

    @arduino_cmake_build.state.should == :cmake_complete

    puts "File.expand_path('../../arduino_sketches_fixture/build/Makefile', __FILE__): #{File.expand_path('../../arduino_sketches_fixture/build/Makefile', __FILE__)}"

    File.exists?(File.expand_path('../../arduino_sketches_fixture/build/Makefile', __FILE__)).should be_true

  end

  it "should execute make in build directory" do

    pending

    @arduino_cmake_build.state.should == :cmake_complete
    File.exists?(File.expand_path('../../arduino_sketches_fixture/build/src/blink_customized_for_test.hex', __FILE__)).should be_false

    @arduino_cmake_build.make(File.expand_path('../../arduino_sketches_fixture/build', __FILE__))

    @arduino_cmake_build.state.should == :make_complete
    File.exists?(File.expand_path('../../arduino_sketches_fixture/build/src/blink_customized_for_test.hex', __FILE__)).should be_true

  end

end
require 'spec_helper'

describe ArduinoSketchBuilder::Base do

  before(:each) do
  	FileUtils.rm_rf(Dir.glob("#{TEMP_DIRECTORY}/*"))

  	@root_directory = TEMP_DIRECTORY
    ArduinoSketchBuilder::Setup.configure(@root_directory)

    arduino_sketch_file_path = File.join(ARDUINO_SKETCHES_FIXTURE_DIRECTORY, 'src/BlinkCustomizedForTest/BlinkCustomizedForTest.ino')	
    @build_directory = File.join(TEMP_DIRECTORY, "blink_customized_for_test", "build")
    @arduino_sketch_builder = ArduinoSketchBuilder::Base.new(@root_directory, arduino_sketch_file_path)
  end

  it "should set up, build and upload Arduino sketch" do

    @arduino_sketch_builder.setup_sketch
    Dir.exists?(File.join(@root_directory, "blink_customized_for_test")).should be_true

    @arduino_sketch_builder.state.should == :initial
    File.exists?(File.join(@build_directory, "Makefile")).should be_false
    File.exists?(File.join(@build_directory, "src", "blink_customized_for_test.hex")).should be_false

    @arduino_sketch_builder.build_and_upload.should == :complete

    @arduino_sketch_builder.state.should == :complete 

    File.exists?(File.join(@build_directory, "Makefile")).should be_true
    File.exists?(File.join(@build_directory, "src", "blink_customized_for_test.hex")).should be_true

  end

end
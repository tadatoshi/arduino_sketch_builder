require 'spec_helper'

describe ArduinoSketchBuilder::CMakeListsFileGenerator do

  FIXTURES_DIRECTORY = File.expand_path('../../fixtures', __FILE__)
  TEMP_DIRECTORY = File.expand_path('../../temp', __FILE__)

  before(:each) do
  	FileUtils.rm_rf(Dir.glob("#{TEMP_DIRECTORY}/*"))
    @c_make_lists_file_generator = ArduinoSketchBuilder::CMakeListsFileGenerator.new
  end

  it "should generate main CMakeLists.txt file" do

    File.exists?(File.join(TEMP_DIRECTORY, "CMakeLists.txt")).should be_false

    @c_make_lists_file_generator.generate_main("~/temp", TEMP_DIRECTORY)

    File.exists?(File.join(TEMP_DIRECTORY, "CMakeLists.txt")).should be_true
    File.read(File.join(TEMP_DIRECTORY, "CMakeLists.txt")).should == File.read(File.join(FIXTURES_DIRECTORY, "MainCMakeLists.txt"))    

  end

  it "should generate CMakeLists.txt file for a given Arduino sketch name" do

  	File.exists?(File.join(TEMP_DIRECTORY, "CMakeLists.txt")).should be_false

    @c_make_lists_file_generator.generate_sketch_specific("TestSketch", TEMP_DIRECTORY)

    File.exists?(File.join(TEMP_DIRECTORY, "CMakeLists.txt")).should be_true
    File.read(File.join(TEMP_DIRECTORY, "CMakeLists.txt")).should == File.read(File.join(FIXTURES_DIRECTORY, "CMakeListsForTestSketch.txt"))

  end

end
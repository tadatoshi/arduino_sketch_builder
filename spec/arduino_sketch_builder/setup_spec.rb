require 'spec_helper'

describe ArduinoSketchBuilder::Setup do

  ARDUINO_CMAKE_DIRECTORY = File.expand_path('../../../arduino-cmake', __FILE__)
  ARDUINO_SKETCH_FILE_PATH = File.join(ARDUINO_SKETCHES_FIXTURE_DIRECTORY, 'src/BlinkCustomizedForTest/BlinkCustomizedForTest.ino')
  TEMPLATES_DIRECTORY = File.expand_path('../../../templates', __FILE__)

  before(:each) do
  	FileUtils.rm_rf(Dir.glob("#{TEMP_DIRECTORY}/*"))
  end

  context "configure" do

    it "should configure the root directory by putting cmake directory and its contents from arduino-cmake directory" do

      root_directory = TEMP_DIRECTORY

      ArduinoSketchBuilder::Setup.configure(root_directory)

      Dir.exists?(File.join(root_directory, "cmake")).should be_true 
      File.exists?(File.join(root_directory, "cmake", "ArduinoToolchain.cmake")).should be_true
      Dir.exists?(File.join(root_directory, "cmake", "Platform")).should be_true 
      File.exists?(File.join(root_directory, "cmake", "Platform", "Arduino.cmake")).should be_true  
      
      File.read(File.join(root_directory, "cmake", "ArduinoToolchain.cmake")).should == File.read(File.join(ARDUINO_CMAKE_DIRECTORY, "cmake", "ArduinoToolchain.cmake"))    
      File.read(File.join(root_directory, "cmake", "Platform", "Arduino.cmake")).should == File.read(File.join(ARDUINO_CMAKE_DIRECTORY, "cmake", "Platform", "Arduino.cmake"))    

    end

    it "should configure the root directory by putting libraries directory" do

      root_directory = TEMP_DIRECTORY

      ArduinoSketchBuilder::Setup.configure(root_directory)

      Dir.exists?(File.join(root_directory, "libraries")).should be_true 
      File.exists?(File.join(root_directory, "libraries", ".gitkeep")).should be_true

    end 

    it "should configure the root directory by putting .gitignore file" do

      root_directory = TEMP_DIRECTORY

      ArduinoSketchBuilder::Setup.configure(root_directory)

      File.exists?(File.join(root_directory, ".gitignore")).should be_true
      File.read(File.join(root_directory, ".gitignore")).should == File.read(File.join(TEMPLATES_DIRECTORY, "root_gitignore_template"))                

    end   

  end

  context "setup" do

    before(:each) do
      @setup = ArduinoSketchBuilder::Setup.new
    end    

    it "should create a directory structure for an Arduino sketch" do

      root_directory = TEMP_DIRECTORY

      @setup.setup(root_directory, ARDUINO_SKETCH_FILE_PATH)

      Dir.exists?(File.join(root_directory, "blink_customized_for_test")).should be_true
      File.exists?(File.join(root_directory, "blink_customized_for_test", "CMakeLists.txt")).should be_true
      Dir.exists?(File.join(root_directory, "blink_customized_for_test", "src")).should be_true
      File.exists?(File.join(root_directory, "blink_customized_for_test", "src", "CMakeLists.txt")).should be_true
      Dir.exists?(File.join(root_directory, "blink_customized_for_test", "src", "BlinkCustomizedForTest")).should be_true
      File.exists?(File.join(root_directory, "blink_customized_for_test", "src", "BlinkCustomizedForTest", "BlinkCustomizedForTest.ino")).should be_true
      Dir.exists?(File.join(root_directory, "blink_customized_for_test", "build")).should be_true

      # The following checks the generated file with the full path, hence, system specific (e.g. /Users/). 
      # Hence, it's considered that the unit test for c_make_lists_file_generator covers it. 
      # File.read(File.join(root_directory, "blink_customized_for_test", "CMakeLists.txt")).should == File.read(File.join(FIXTURES_DIRECTORY, "MainCMakeLists.txt"))
      # This one also, it's considered that the unit test for c_make_lists_file_generator covers it.
      # File.read(File.join(root_directory, "blink_customized_for_test", "src", "CMakeLists.txt")).should == File.read(File.join(FIXTURES_DIRECTORY, "CMakeListsForTestSketch.txt"))
      File.read(File.join(root_directory, "blink_customized_for_test", "src", "BlinkCustomizedForTest", "BlinkCustomizedForTest.ino")).should == File.read(File.join(ARDUINO_SKETCHES_FIXTURE_DIRECTORY, "src", "BlinkCustomizedForTest", "BlinkCustomizedForTest.ino"))    

    end

    context "Arduino board type and port" do    

      it "should create a directory structure for an Arduino sketch with specified board ID and port" do

        root_directory = TEMP_DIRECTORY

        @setup.setup(root_directory, ARDUINO_SKETCH_FILE_PATH, board_type: "diecimila", board_port: "/dev/cu.usbmodem411")

        Dir.exists?(File.join(root_directory, "blink_customized_for_test")).should be_true
        File.exists?(File.join(root_directory, "blink_customized_for_test", "CMakeLists.txt")).should be_true
        Dir.exists?(File.join(root_directory, "blink_customized_for_test", "src")).should be_true
        File.exists?(File.join(root_directory, "blink_customized_for_test", "src", "CMakeLists.txt")).should be_true
        Dir.exists?(File.join(root_directory, "blink_customized_for_test", "src", "BlinkCustomizedForTest")).should be_true
        File.exists?(File.join(root_directory, "blink_customized_for_test", "src", "BlinkCustomizedForTest", "BlinkCustomizedForTest.ino")).should be_true
        Dir.exists?(File.join(root_directory, "blink_customized_for_test", "build")).should be_true

        # The following checks the generated file with the full path, hence, system specific (e.g. /Users/). 
        # Hence, it's considered that the unit test for c_make_lists_file_generator covers it. 
        # File.read(File.join(root_directory, "blink_customized_for_test", "CMakeLists.txt")).should == File.read(File.join(FIXTURES_DIRECTORY, "MainCMakeLists.txt"))
        # This one also, it's considered that the unit test for c_make_lists_file_generator covers it.
        # File.read(File.join(root_directory, "blink_customized_for_test", "src", "CMakeLists.txt")).should == File.read(File.join(FIXTURES_DIRECTORY, "CMakeListsForTestSketch2.txt"))
        File.read(File.join(root_directory, "blink_customized_for_test", "src", "BlinkCustomizedForTest", "BlinkCustomizedForTest.ino")).should == File.read(File.join(ARDUINO_SKETCHES_FIXTURE_DIRECTORY, "src", "BlinkCustomizedForTest", "BlinkCustomizedForTest.ino"))    

      end      

    end

  end

end
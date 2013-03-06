require 'spec_helper'

describe ArduinoSketchBuilder::ArduinoCmakeBuild do

  MAIN_DIRECTORY = ARDUINO_SKETCHES_FIXTURE_DIRECTORY
  BUILD_DIRECTORY = File.join(MAIN_DIRECTORY, "build")

  before(:each) do
  	FileUtils.rm_rf(Dir.glob("#{BUILD_DIRECTORY}/*"))
    @arduino_cmake_build = ArduinoSketchBuilder::ArduinoCmakeBuild.new(MAIN_DIRECTORY, BUILD_DIRECTORY)
  end

  after(:each) do
    FileUtils.rm_rf(Dir.glob("#{BUILD_DIRECTORY}/*"))
  end  

  it "should execute cmake and make in sequence in build directory" do

    @arduino_cmake_build.state.should == :initial
    File.exists?(File.join(BUILD_DIRECTORY, "Makefile")).should be_false

    @arduino_cmake_build.cmake.should == :cmake_complete

    @arduino_cmake_build.state.should == :cmake_complete
    File.exists?(File.join(BUILD_DIRECTORY, "Makefile")).should be_true

    File.exists?(File.join(BUILD_DIRECTORY, "src", "blink_customized_for_test.hex")).should be_false

    @arduino_cmake_build.make.should == :make_complete

    @arduino_cmake_build.state.should == :make_complete
    File.exists?(File.join(BUILD_DIRECTORY, "src", "blink_customized_for_test.hex")).should be_true

    @arduino_cmake_build.make_upload.should == :make_upload_complete

    @arduino_cmake_build.state.should == :make_upload_complete

  end

  it "should execute cmake only when the state is initial" do

    @arduino_cmake_build.instance_eval("@state=CMAKE_COMPLETE")
    expect { @arduino_cmake_build.cmake }
      .to raise_error("Wrong state 'cmake_complete': can't call cmake when the state is not 'initial'")
    
    @arduino_cmake_build.instance_eval("@state=MAKE_COMPLETE")
    expect { @arduino_cmake_build.cmake }
      .to raise_error("Wrong state 'make_complete': can't call cmake when the state is not 'initial'")  

    @arduino_cmake_build.instance_eval("@state=MAKE_UPLOAD_COMPLETE")
    expect { @arduino_cmake_build.cmake }
      .to raise_error("Wrong state 'make_upload_complete': can't call cmake when the state is not 'initial'") 

    @arduino_cmake_build.instance_eval("@state=INITIAL")
    expect { @arduino_cmake_build.cmake }
      .to_not raise_error 

  end

  it "should execute make only when the state is cmake_complete" do

    @arduino_cmake_build.instance_eval("@state=INITIAL")
    expect { @arduino_cmake_build.make }
      .to raise_error("Wrong state 'initial': can't call make when the state is not 'cmake_complete'")
    
    @arduino_cmake_build.instance_eval("@state=MAKE_COMPLETE")
    expect { @arduino_cmake_build.make }
      .to raise_error("Wrong state 'make_complete': can't call make when the state is not 'cmake_complete'")  

    @arduino_cmake_build.instance_eval("@state=MAKE_UPLOAD_COMPLETE")
    expect { @arduino_cmake_build.make }
      .to raise_error("Wrong state 'make_upload_complete': can't call make when the state is not 'cmake_complete'") 

    @arduino_cmake_build.instance_eval("@state=INITIAL")
    @arduino_cmake_build.cmake
    @arduino_cmake_build.state.should == :cmake_complete
    expect { @arduino_cmake_build.make }
      .to_not raise_error 

  end  

  it "should execute make_upload only when the state is make_complete" do

    @arduino_cmake_build.instance_eval("@state=INITIAL")
    expect { @arduino_cmake_build.make_upload }
      .to raise_error("Wrong state 'initial': can't call make_upload when the state is not 'make_complete'")
    
    @arduino_cmake_build.instance_eval("@state=CMAKE_COMPLETE")
    expect { @arduino_cmake_build.make_upload }
      .to raise_error("Wrong state 'cmake_complete': can't call make_upload when the state is not 'make_complete'")  

    @arduino_cmake_build.instance_eval("@state=MAKE_UPLOAD_COMPLETE")
    expect { @arduino_cmake_build.make_upload }
      .to raise_error("Wrong state 'make_upload_complete': can't call make_upload when the state is not 'make_complete'") 

    @arduino_cmake_build.instance_eval("@state=INITIAL")
    @arduino_cmake_build.cmake
    @arduino_cmake_build.make
    @arduino_cmake_build.state.should == :make_complete
    expect { @arduino_cmake_build.make_upload }
      .to_not raise_error 

  end    

  context "one method to do cmake, make and make upload" do

    it "should execute cmake, make and make upload" do

      @arduino_cmake_build.state.should == :initial
      File.exists?(File.join(BUILD_DIRECTORY, "Makefile")).should be_false
      File.exists?(File.join(BUILD_DIRECTORY, "src", "blink_customized_for_test.hex")).should be_false

      @arduino_cmake_build.build_and_upload.should == :complete

      @arduino_cmake_build.state.should == :complete 

      File.exists?(File.join(BUILD_DIRECTORY, "Makefile")).should be_true
      File.exists?(File.join(BUILD_DIRECTORY, "src", "blink_customized_for_test.hex")).should be_true

    end

  end

  context "reset" do

    it "should clean up build directory and reset the state to :initial" do

      @arduino_cmake_build.state.should == :initial
      @arduino_cmake_build.cmake.should == :cmake_complete

      File.exists?(File.join(BUILD_DIRECTORY, "Makefile")).should be_true

      @arduino_cmake_build.reset.should == :initial

      Dir.entries(BUILD_DIRECTORY).should == [".", "..", ".gitkeep"]

    end

  end

end
require 'spec_helper'

describe ArduinoSketchBuilder::ArduinoCmakeBuild do

  MAIN_DIRECTORY = File.expand_path('../../arduino_sketches_fixture', __FILE__)
  BUILD_DIRECTORY = "#{MAIN_DIRECTORY}/build"

  before(:each) do
  	FileUtils.rm_rf(Dir.glob("#{BUILD_DIRECTORY}/*"))
    @arduino_cmake_build = ArduinoSketchBuilder::ArduinoCmakeBuild.new
  end

  after(:each) do
    FileUtils.rm_rf(Dir.glob("#{BUILD_DIRECTORY}/*"))
  end  

  it "should execute cmake and make in sequence in build directory" do

    @arduino_cmake_build.state.should == :initial
    File.exists?("#{BUILD_DIRECTORY}/Makefile").should be_false

    @arduino_cmake_build.cmake(BUILD_DIRECTORY, MAIN_DIRECTORY).should == :cmake_complete

    @arduino_cmake_build.state.should == :cmake_complete
    File.exists?("#{BUILD_DIRECTORY}/Makefile").should be_true

    File.exists?("#{BUILD_DIRECTORY}/src/blink_customized_for_test.hex").should be_false

    @arduino_cmake_build.make(BUILD_DIRECTORY).should == :make_complete

    @arduino_cmake_build.state.should == :make_complete
    File.exists?("#{BUILD_DIRECTORY}/src/blink_customized_for_test.hex").should be_true

    @arduino_cmake_build.make_upload(BUILD_DIRECTORY).should == :make_upload_complete

    @arduino_cmake_build.state.should == :make_upload_complete

  end

  it "should execute cmake only when the state is initial" do

    @arduino_cmake_build.instance_eval("@state=CMAKE_COMPLETE")
    expect { @arduino_cmake_build.cmake(BUILD_DIRECTORY, MAIN_DIRECTORY) }
      .to raise_error("Wrong state 'cmake_complete': can't call cmake when the state is not 'initial'")
    
    @arduino_cmake_build.instance_eval("@state=MAKE_COMPLETE")
    expect { @arduino_cmake_build.cmake(BUILD_DIRECTORY, MAIN_DIRECTORY) }
      .to raise_error("Wrong state 'make_complete': can't call cmake when the state is not 'initial'")  

    @arduino_cmake_build.instance_eval("@state=MAKE_UPLOAD_COMPLETE")
    expect { @arduino_cmake_build.cmake(BUILD_DIRECTORY, MAIN_DIRECTORY) }
      .to raise_error("Wrong state 'make_upload_complete': can't call cmake when the state is not 'initial'") 

    @arduino_cmake_build.instance_eval("@state=INITIAL")
    expect { @arduino_cmake_build.cmake(BUILD_DIRECTORY, MAIN_DIRECTORY) }
      .to_not raise_error 

  end

  it "should execute make only when the state is cmake_complete" do

    @arduino_cmake_build.instance_eval("@state=INITIAL")
    expect { @arduino_cmake_build.make(BUILD_DIRECTORY) }
      .to raise_error("Wrong state 'initial': can't call make when the state is not 'cmake_complete'")
    
    @arduino_cmake_build.instance_eval("@state=MAKE_COMPLETE")
    expect { @arduino_cmake_build.make(BUILD_DIRECTORY) }
      .to raise_error("Wrong state 'make_complete': can't call make when the state is not 'cmake_complete'")  

    @arduino_cmake_build.instance_eval("@state=MAKE_UPLOAD_COMPLETE")
    expect { @arduino_cmake_build.make(BUILD_DIRECTORY) }
      .to raise_error("Wrong state 'make_upload_complete': can't call make when the state is not 'cmake_complete'") 

    @arduino_cmake_build.instance_eval("@state=INITIAL")
    @arduino_cmake_build.cmake(BUILD_DIRECTORY, MAIN_DIRECTORY)
    @arduino_cmake_build.state.should == :cmake_complete
    expect { @arduino_cmake_build.make(BUILD_DIRECTORY) }
      .to_not raise_error 

  end  

  it "should execute make_upload only when the state is make_complete" do

    @arduino_cmake_build.instance_eval("@state=INITIAL")
    expect { @arduino_cmake_build.make_upload(BUILD_DIRECTORY) }
      .to raise_error("Wrong state 'initial': can't call make_upload when the state is not 'make_complete'")
    
    @arduino_cmake_build.instance_eval("@state=CMAKE_COMPLETE")
    expect { @arduino_cmake_build.make_upload(BUILD_DIRECTORY) }
      .to raise_error("Wrong state 'cmake_complete': can't call make_upload when the state is not 'make_complete'")  

    @arduino_cmake_build.instance_eval("@state=MAKE_UPLOAD_COMPLETE")
    expect { @arduino_cmake_build.make_upload(BUILD_DIRECTORY) }
      .to raise_error("Wrong state 'make_upload_complete': can't call make_upload when the state is not 'make_complete'") 

    @arduino_cmake_build.instance_eval("@state=INITIAL")
    @arduino_cmake_build.cmake(BUILD_DIRECTORY, MAIN_DIRECTORY)
    @arduino_cmake_build.make(BUILD_DIRECTORY)
    @arduino_cmake_build.state.should == :make_complete
    expect { @arduino_cmake_build.make_upload(BUILD_DIRECTORY) }
      .to_not raise_error 

  end    

end
require 'active_support/core_ext/string/inflections'

class ArduinoSketchBuilder::Base

  def initialize(root_directory, sketch_file_path, board_type: "uno", board_port: "/dev/tty.usbmodem411")
    @root_directory = File.expand_path(root_directory)
    @sketch_file_path = File.expand_path(sketch_file_path)
    @board_type = board_type
    @board_port = board_port

    main_directory_name = File.basename(@sketch_file_path).split('.').first.underscore
    main_directory = File.join(@root_directory, main_directory_name) 
    build_directory = File.join(main_directory, "build")    
    @arduino_cmake_build = ArduinoSketchBuilder::ArduinoCmakeBuild.new(main_directory, build_directory)
  end

  def state
    @arduino_cmake_build.state
  end

  def message
    @arduino_cmake_build.message
  end

  def setup_sketch
    ArduinoSketchBuilder::Setup.new.setup(@root_directory, @sketch_file_path, board_type: @board_type, board_port: @board_port)
  end

  def build_and_upload
    @arduino_cmake_build.build_and_upload
  end

  def reset
    @arduino_cmake_build.reset
  end

end
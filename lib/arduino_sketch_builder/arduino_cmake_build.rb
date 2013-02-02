require "open3"

class ArduinoSketchBuilder::ArduinoCmakeBuild

  STATES = [:initial, :cmake_complete, :make_complete, :make_upload_complete]

  attr_accessor :state

  def initialize
    @state = :initial
  end

  def cmake(build_directory, main_directory)

    Dir.chdir(build_directory)

    Open3.popen3("cmake #{main_directory}") do |stdin, stdout, stderr, wait_thread|
      pid = wait_thread.pid
      exit_status = wait_thread.value
      @state = :cmake_complete if exit_status.success?
    end

  end

  def make(build_directory)

    Dir.chdir(build_directory)

    Open3.popen3("make") do |stdin, stdout, stderr, wait_thread|
      pid = wait_thread.pid
      exit_status = wait_thread.value
      @state = :make_complete if exit_status.success?
    end    

  end

end
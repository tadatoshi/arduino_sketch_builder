require "open3"

class ArduinoSketchBuilder::ArduinoCmakeBuild

  STATES = [:initial, :cmake_complete, :make_complete, :make_upload_complete]

  attr_accessor :state

  def initialize
    @state = :initial
  end

  def cmake(build_directory, main_directory)

  	# current_directory = Dir.pwd
    Dir.chdir(build_directory)

    Open3.popen3("cmake #{main_directory}") do |stdin, stdout, stderr, wait_thread|
      pid = wait_thread.pid

      # puts "pid: #{pid}"
 
      exit_status = wait_thread.value # Process::Status object returned.

      # puts "exit_status.success?: #{exit_status.success?}"
      # puts "exit_status: #{exit_status}"

      @state = :cmake_complete if exit_status.success?
    end

    # Dir.chdir(current_directory)

  end

  def make(build_directory)

  end

end
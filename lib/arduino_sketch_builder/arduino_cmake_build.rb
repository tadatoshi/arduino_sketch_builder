require "open3"

class ArduinoSketchBuilder::ArduinoCmakeBuild

  State = Struct.new(:value, :message)

  INITIAL = State.new(:initial, "ready") 
  CMAKE_COMPLETE = State.new(:cmake_complete, "success") 
  MAKE_COMPLETE = State.new(:make_complete, "success")
  MAKE_UPLOAD_COMPLETE = State.new(:make_upload_complete, "success")

  def initialize
    @state = INITIAL
  end

  def state
    @state.value
  end

  def message
    @state.message
  end

  def cmake(build_directory, main_directory)

    unless @state == INITIAL
      raise "Wrong state '#{self.state}': can't call cmake when the state is not '#{INITIAL.value}'"
    end

    Dir.chdir(build_directory)

    Open3.popen3("cmake #{main_directory}") do |stdin, stdout, stderr, wait_thread|
      pid = wait_thread.pid
      exit_status = wait_thread.value
      if exit_status.success?
        @state = CMAKE_COMPLETE
      else
        @state = State.new(:cmake_incomplete, stderr.gets)
      end
    end

    self.state

  end

  def make(build_directory)

    unless @state == CMAKE_COMPLETE
      raise "Wrong state '#{self.state}': can't call make when the state is not '#{CMAKE_COMPLETE.value}'"
    end    

    Dir.chdir(build_directory)

    Open3.popen3("make") do |stdin, stdout, stderr, wait_thread|
      pid = wait_thread.pid
      exit_status = wait_thread.value
      if exit_status.success?
        @state = MAKE_COMPLETE
      else
        @state = State.new(:make_incomplete, stderr.gets)
      end
    end    

    self.state

  end

  def make_upload(build_directory)

    unless @state == MAKE_COMPLETE
      raise "Wrong state '#{self.state}': can't call make_upload when the state is not '#{MAKE_COMPLETE.value}'"
    end    

    Dir.chdir(build_directory)

    Open3.popen3("make upload") do |stdin, stdout, stderr, wait_thread|
      pid = wait_thread.pid
      exit_status = wait_thread.value
      if exit_status.success?
        @state = MAKE_UPLOAD_COMPLETE
      else
        @state = State.new(:make_upload_incomplete, stderr.gets)
        puts "error message: #{self.message}"
      end
    end    

    self.state

  end  

end
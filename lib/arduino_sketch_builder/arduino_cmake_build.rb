require "open3"

class ArduinoSketchBuilder::ArduinoCmakeBuild

  State = Struct.new(:value, :message)

  INITIAL = State.new(:initial, "ready") 
  CMAKE_COMPLETE = State.new(:cmake_complete, "success") 
  MAKE_COMPLETE = State.new(:make_complete, "success")
  MAKE_UPLOAD_COMPLETE = State.new(:make_upload_complete, "success")

  STATE_SEQUENCE = [INITIAL, CMAKE_COMPLETE, MAKE_COMPLETE, MAKE_UPLOAD_COMPLETE]

  def initialize
    @state = INITIAL
  end

  def state
    @state.value
  end

  def message
    @state.message
  end

  [:cmake, :make, :make_upload].each_with_index do |method_name, index|
    
    define_method(method_name) do |build_directory, main_directory=nil|

      unless @state == STATE_SEQUENCE[index]
        raise "Wrong state '#{self.state}': can't call #{method_name} when the state is not '#{STATE_SEQUENCE[index].value}'"
      end

      Dir.chdir(build_directory)

      Open3.popen3("#{method_name.to_s.sub('_',' ')} #{main_directory ? main_directory : ''}") do |stdin, stdout, stderr, wait_thread|
        pid = wait_thread.pid
        exit_status = wait_thread.value
        if exit_status.success?
          @state = STATE_SEQUENCE[index+1]
        else
          @state = State.new("#{method_name}_incomplete".to_sym, stderr.gets)
        end
      end

      self.state

    end

  end

  # def cmake(build_directory, main_directory)

  #   unless @state == INITIAL
  #     raise "Wrong state '#{self.state}': can't call cmake when the state is not '#{INITIAL.value}'"
  #   end

  #   Dir.chdir(build_directory)

  #   Open3.popen3("cmake #{main_directory}") do |stdin, stdout, stderr, wait_thread|
  #     pid = wait_thread.pid
  #     exit_status = wait_thread.value
  #     if exit_status.success?
  #       @state = CMAKE_COMPLETE
  #     else
  #       @state = State.new(:cmake_incomplete, stderr.gets)
  #     end
  #   end

  #   self.state

  # end

  # def make(build_directory)

  #   unless @state == CMAKE_COMPLETE
  #     raise "Wrong state '#{self.state}': can't call make when the state is not '#{CMAKE_COMPLETE.value}'"
  #   end    

  #   Dir.chdir(build_directory)

  #   Open3.popen3("make") do |stdin, stdout, stderr, wait_thread|
  #     pid = wait_thread.pid
  #     exit_status = wait_thread.value
  #     if exit_status.success?
  #       @state = MAKE_COMPLETE
  #     else
  #       @state = State.new(:make_incomplete, stderr.gets)
  #     end
  #   end    

  #   self.state

  # end

  # def make_upload(build_directory)

  #   unless @state == MAKE_COMPLETE
  #     raise "Wrong state '#{self.state}': can't call make_upload when the state is not '#{MAKE_COMPLETE.value}'"
  #   end    

  #   Dir.chdir(build_directory)

  #   Open3.popen3("make upload") do |stdin, stdout, stderr, wait_thread|
  #     pid = wait_thread.pid
  #     exit_status = wait_thread.value
  #     if exit_status.success?
  #       @state = MAKE_UPLOAD_COMPLETE
  #     else
  #       @state = State.new(:make_upload_incomplete, stderr.gets)
  #       puts "error message: #{self.message}"
  #     end
  #   end    

  #   self.state

  # end  

end
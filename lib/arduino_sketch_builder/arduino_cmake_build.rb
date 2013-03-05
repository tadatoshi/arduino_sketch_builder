require "open3"

class ArduinoSketchBuilder::ArduinoCmakeBuild

  State = Struct.new(:value, :message)

  INITIAL = State.new(:initial, "ready") 
  CMAKE_COMPLETE = State.new(:cmake_complete, "success") 
  MAKE_COMPLETE = State.new(:make_complete, "success")
  MAKE_UPLOAD_COMPLETE = State.new(:make_upload_complete, "success")

  STATE_SEQUENCE = [INITIAL, CMAKE_COMPLETE, MAKE_COMPLETE, MAKE_UPLOAD_COMPLETE]

  def initialize(main_directory, build_directory)
    @main_directory = main_directory
    @build_directory = build_directory
    @state = INITIAL
  end

  def state
    @state.value
  end

  def message
    @state.message
  end

  def build_and_upload
    self.cmake
    return self.state unless self.state == :cmake_complete
    self.make
    return self.state unless self.state == :make_complete
    self.make_upload
  end

  [:cmake, :make, :make_upload].each_with_index do |method_name, index|
    
    define_method(method_name) do

      unless @state == STATE_SEQUENCE[index]
        raise "Wrong state '#{self.state}': can't call #{method_name} when the state is not '#{STATE_SEQUENCE[index].value}'"
      end

      Dir.chdir(@build_directory)

      Open3.popen3("#{method_name.to_s.sub('_',' ')} #{method_name == :cmake ? @main_directory : ''}") do |stdin, stdout, stderr, wait_thread|
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

end
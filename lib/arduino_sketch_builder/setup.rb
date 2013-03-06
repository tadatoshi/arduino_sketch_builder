require 'fileutils'
require 'active_support/core_ext/string/inflections'

class ArduinoSketchBuilder::Setup

  ARDUINO_CMAKE_DIRECTORY = File.expand_path('../../../arduino-cmake', __FILE__)
  TEMPLATES_DIRECTORY = File.expand_path('../../../templates', __FILE__)

  def self.configure(root_directory)

    FileUtils.cp_r(File.join(ARDUINO_CMAKE_DIRECTORY, 'cmake'), root_directory)

    FileUtils.chmod_R('og-rwx', File.join(root_directory, 'cmake'))

    FileUtils.mkdir_p(File.join(root_directory, 'libraries'))
    FileUtils.cp(File.join(TEMPLATES_DIRECTORY, 'gitkeep_template'), File.join(root_directory, 'libraries', '.gitkeep'))

    FileUtils.chmod_R('og-rwx', File.join(root_directory, 'libraries'))
    FileUtils.chmod('og-rwx', File.join(root_directory, 'libraries', '.gitkeep'))

    FileUtils.cp(File.join(TEMPLATES_DIRECTORY, 'root_gitignore_template'), File.join(root_directory, '.gitignore'))    
    FileUtils.chmod('og-rwx', File.join(root_directory, '.gitignore'))

  end

  def setup(root_directory, sketch_file_path, board_type: "uno", board_port: "/dev/tty.usbmodem411")

    sketch_file_name = File.basename(sketch_file_path)
  	sketch_name = sketch_file_name.split('.').first
  	main_directory_name = sketch_name.underscore
    
    FileUtils.mkdir_p([File.join(root_directory, main_directory_name), 
    	                 File.join(root_directory, main_directory_name, 'src'), 
    	                 File.join(root_directory, main_directory_name, 'build'), 
    	                 File.join(root_directory, main_directory_name, 'src', sketch_name)])

    c_make_lists_file_generator = ArduinoSketchBuilder::CMakeListsFileGenerator.new
    c_make_lists_file_generator.generate_main(root_directory, File.join(root_directory, main_directory_name))
    c_make_lists_file_generator.generate_sketch_specific(sketch_name, File.join(root_directory, main_directory_name, 'src'), board_type: board_type, board_port: board_port)

    File.write(File.join(root_directory, main_directory_name, 'src', sketch_name, sketch_file_name), File.read(sketch_file_path))    

    FileUtils.chmod_R('og-rwx', File.join(root_directory, main_directory_name))

  end

end
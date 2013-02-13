require 'active_support/core_ext/string/inflections'

class ArduinoSketchBuilder::Setup

  ARDUINO_CMAKE_DIRECTORY = File.expand_path('../../../arduino-cmake', __FILE__)

  def configure(root_directory)

    FileUtils.mkdir_p(File.join(root_directory, 'cmake', 'Platform'))

    File.write(File.join(root_directory, 'cmake', 'ArduinoToolchain.cmake'), File.read(File.join(ARDUINO_CMAKE_DIRECTORY, 'cmake', 'ArduinoToolchain.cmake')))    
    File.write(File.join(root_directory, 'cmake', 'Platform', 'Arduino.cmake'), File.read(File.join(ARDUINO_CMAKE_DIRECTORY, 'cmake', 'Platform', 'Arduino.cmake')))            

    FileUtils.chmod_R('og-rwx', File.join(root_directory, 'cmake'))

  end

  def setup(root_directory, sketch_file_path)

    sketch_file_name = File.basename(sketch_file_path)
  	sketch_name = sketch_file_name.split('.').first
  	main_directory_name = sketch_name.underscore
    
    FileUtils.mkdir_p([File.join(root_directory, main_directory_name), 
    	                 File.join(root_directory, main_directory_name, 'src'), 
    	                 File.join(root_directory, main_directory_name, 'build'), 
    	                 File.join(root_directory, main_directory_name, 'src', sketch_name)])

    c_make_lists_file_generator = ArduinoSketchBuilder::CMakeListsFileGenerator.new
    c_make_lists_file_generator.generate_main(root_directory, File.join(root_directory, main_directory_name))
    c_make_lists_file_generator.generate_sketch_specific(sketch_name, File.join(root_directory, main_directory_name, 'src'))

    File.write(File.join(root_directory, main_directory_name, 'src', sketch_name, sketch_file_name), File.read(sketch_file_path))    

    FileUtils.chmod_R('og-rwx', File.join(root_directory, main_directory_name))

  end

end
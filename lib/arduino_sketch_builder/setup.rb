require 'active_support/core_ext/string/inflections'

class ArduinoSketchBuilder::Setup

  def setup(root_directory, sketch_file_path)

    sketch_file_name = File.basename(sketch_file_path)
  	sketch_name = sketch_file_name.split('.').first
  	main_directory_name = sketch_name.underscore
    
    FileUtils.mkdir_p([File.join(root_directory, main_directory_name), 
    	               File.join(root_directory, main_directory_name, 'src'), 
    	               File.join(root_directory, main_directory_name, 'build'), 
    	               File.join(root_directory, main_directory_name, 'src', sketch_name) ])

    c_make_lists_file_generator = ArduinoSketchBuilder::CMakeListsFileGenerator.new
    c_make_lists_file_generator.generate_main(root_directory, File.join(root_directory, main_directory_name))
    c_make_lists_file_generator.generate_sketch_specific(sketch_name, File.join(root_directory, main_directory_name, 'src'))

    File.write(File.join(root_directory, main_directory_name, 'src', sketch_name, sketch_file_name), File.read(sketch_file_path))    

  end

end
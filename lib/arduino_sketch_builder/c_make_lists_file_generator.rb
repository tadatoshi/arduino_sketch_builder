require 'active_support/core_ext/string/inflections'

class ArduinoSketchBuilder::CMakeListsFileGenerator

  TEMPLATES_DIRECTORY = File.expand_path('../../../templates', __FILE__)	

  attr_reader :root_directory
  attr_reader :sketch_name

  def generate_main(root_directory, c_make_lists_file_directory)

    @root_directory = root_directory

    erb = ERB.new(File.read("#{TEMPLATES_DIRECTORY}/MainCMakeListsTemplate.txt.erb"))

    generated_content = erb.result(binding)

    File.write(File.join(c_make_lists_file_directory, "CMakeLists.txt"), generated_content)    

  end

  def generate_sketch_specific(sketch_name, c_make_lists_file_directory)

  	@sketch_name = sketch_name

    erb = ERB.new(File.read("#{TEMPLATES_DIRECTORY}/SourceCMakeListsTemplate.txt.erb"))

    generated_content = erb.result(binding)

    File.write(File.join(c_make_lists_file_directory, "CMakeLists.txt"), generated_content)

  end

end
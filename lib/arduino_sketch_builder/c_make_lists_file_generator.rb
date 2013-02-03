require 'active_support/core_ext/string/inflections'

class ArduinoSketchBuilder::CMakeListsFileGenerator

  TEMPLATES_DIRECTORY = File.expand_path('../../../templates', __FILE__)	

  attr_reader :sketch_name

  def generate(sketch_name, c_make_lists_file_directory)

  	@sketch_name = sketch_name

    erb = ERB.new(File.read("#{TEMPLATES_DIRECTORY}/SourceCMakeListsTemplate.txt.erb"))

    generated_content = erb.result(binding)

    File.write("#{c_make_lists_file_directory}/CMakeLists.txt", generated_content)

  end

end
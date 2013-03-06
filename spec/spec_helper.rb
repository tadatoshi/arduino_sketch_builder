require 'arduino_sketch_builder'

FIXTURES_DIRECTORY = File.expand_path('../fixtures', __FILE__)
TEMP_DIRECTORY = File.expand_path('../temp', __FILE__)
ARDUINO_SKETCHES_FIXTURE_DIRECTORY = File.expand_path('../arduino_sketches_fixture', __FILE__)

RSpec.configure do |config|

  config.before(:suite) do
  end

  config.before(:each) do
  end

  config.after(:each) do
  end

end
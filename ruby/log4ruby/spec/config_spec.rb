require_relative '../lib/log4ruby/config'
require 'yaml'

describe Log4Ruby::Config do

  before :each do
    
  end

  describe "#set_up" do
    it "should not be empty after class creation" do
      expect(Log4Ruby::Config.settings.empty?).to be false
    end

    it "should be equal with the default configuration" do
      file_name = 'default_config.yaml'
      config_path = File.join(Log4Ruby::Config::CONFIG_PATH, file_name)
      config = YAML::load_file(config_path)
      expect(Log4Ruby::Config.settings.size). to eq config.size
    end

  end

end

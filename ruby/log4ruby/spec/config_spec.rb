require_relative '../lib/log4ruby/config'
require 'yaml'

describe Log4Ruby::Config do

  before :each do
    Log4Ruby::Config.set_up
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

  describe "#update" do
    it "updates the configuration from a yaml file" do
      new_config = {'message_formatters' => {test: 'result'}}
      old_message_formatters = Log4Ruby::Config.message_formatters
      Log4Ruby::Config.update_from_yaml(YAML.dump(new_config))
      expect(Log4Ruby::Config.message_formatters[:test]).to eq 'result'
    end

    it "does not erase not changed configurations" do
      new_config = {"message_formatters" => {default: 7}}
      old_config = Log4Ruby::Config.message_formatters[:console]
      Log4Ruby::Config.update_from_yaml(YAML.dump(new_config))
      expect(Log4Ruby::Config.message_formatters[:console]).to eq old_config
    end
  end

  describe "#method_missing" do
    it "creates methods for each first level hash key" do
      expect(Log4Ruby::Config.methods.include?(:db)).to be true
      new_config = {'new_method' => {}}
      Log4Ruby::Config.update_from_yaml(YAML.dump(new_config))
      expect(Log4Ruby::Config.methods.include?(:new_method)).to be false
      Log4Ruby::Config.new_method
      expect(Log4Ruby::Config.methods.include?(:new_method)).to be true
    end
  end

end

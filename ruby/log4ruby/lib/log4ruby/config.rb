require 'yaml'

#Simple configuration class
#Usage: Log4Ruby::Config.key_name
#Example: Log4Ruby::Config.time_formatters
module Log4Ruby
  #A holder module for all the logging configurations
  module Config
    extend self
    attr_accessor :settings

    CONFIG_PATH = File.join(File.dirname(__FILE__), 'config')

    @settings = {}

    def set_up
      config_path = File.join(CONFIG_PATH, 'default_config.yaml')
      update(File.expand_path(config_path))
      @settings.each do |method_name, value|
        define_method(method_name) { @settings[method_name.to_sym] }
      end
    end

    def update(file_path)
      config_data = YAML::load_file(file_path)
      deep_merge(config_data)
    end

    def update_from_yaml(yaml)
      deep_merge(YAML.load(yaml))
    end

    def method_missing(name, *args, &block)
      if (@settings[name.to_sym])
        define_method(name) { @settings[name.to_sym] }
        @settings[name.to_sym]
      else
        super
      end
    end

    private

    def deep_merge(data)
      merger = ->(key, v1, v2) do
        (Hash === v1 and Hash === v2) ? v1.merge(v2, &merger) : v2
      end
      data = symbolize_hash(data)
      data = add_defaults(data)
      @settings.merge!(data, &merger)
    end

    #symbolizes the hash keys
    def symbolize_hash(hash)
      eval(hash.to_s.gsub(/\"(\w+)\"(?==>)/, ':\1'))
    end

    def add_defaults(hash)
      hash.each do |key, value|
        value.default = value[:default] if (value.respond_to?(:default))
      end
    end

  end
end

Log4Ruby::Config.set_up

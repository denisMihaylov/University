require 'yaml'

module Log4Ruby
  module Config
    extend self
    attr_accessor :settings

    @settings = {}

    def set_up
      config_path = File.join(File.dirname(__FILE__), 'default_config.yaml')
      update(File.expand_path(config_path))
      @settings.each do |method_name, value|
        define_method(method_name) { value }
      end
    end

    def update(file_path)
      config_data = YAML::load_file(file_path)
      deep_merge(config_data)
    end

    def method_missing(name, *args, &block)
      if (@settings[name.to_sym])
        define_method(name) {@settings[name.to_sym]}
        @settings[name.to_sym]
      else
        super
      end
    end

    private

    def deep_merge(data)
      merger = ->(key, v1, v2) do
        Hash === v1 and Hash === v2 ? v1.merge(v2, &merger) : v2
      end
      data = symbolize_hash(data)
      @settings.merge!(data, &merger)
    end

    #symbolizes the hash keys
    def symbolize_hash(hash)
      eval(hash.to_s.gsub(/\"(\w+)\"(?==>)/, ':\1'))
    end

  end
end

Log4Ruby::Config.set_up

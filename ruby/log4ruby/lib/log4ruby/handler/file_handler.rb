require 'fileutils'
require 'yaml'
require_relative '../handler'
require_relative '../config'

module Log4Ruby
  class FileHandler < Handler
    attr_accessor :rolling

    SIZE_UNIT_RATIO = {
      byte: 1,
      kbyte: 1024,
      mbyte: 1024 ** 2,
      gbyte: 1024 ** 3,
    }

    TIME_UNIT_RATIO = {
      millis: 0.001,
      sec: 1,
      min: 60,
      hour: 60 * 60,
      day: 24 * 60 * 60,
      week: 7 * 24 * 60 * 60,
      month: 30 * 7 * 24 * 60 * 60,
    }

    def initialize
      @rolling, @type = Config.file[:rolling], :file
      file_path = Config.file[:file_path]
      FileUtils.mkdir_p(file_path) unless Dir.exists?(file_path)
      read_file_stats
    end

    def read_file_stats
      @file_stats = if File.exists?(get_stats_path)
        YAML.load_file(get_stats_path)
      else
        {lines: 0, created_on: Time.now, file_index: 0}
      end
    end

    def get_stats_path
      File.join(Config.file[:file_path], '.stats.yaml')
    end

    def log_message(message)
      file_name = get_file_name
      File.open(file_name, 'a+') do |file|
        file.puts(message.parse)
      end
      perform_post_log_actions(file_name) if @rolling
    end

    def get_file_name
      "#{Config.file[:file_path]}/log_trace.log"
    end

    private

    def save_file_stats
      File.open(get_stats_path, 'w') {|file| file.write @file_stats.to_yaml}
    end

    def perform_post_log_actions(file_name)
      @file_stats[:created_on] = Time.now if @file_stats[:lines] == 0
      @file_stats[:lines] += 1
      perform_roll(file_name)
      save_file_stats
    end

    def perform_roll(file_name)
      if lines_limit? || time_limit? || size_limit?
        file_index = @file_stats[:file_index]
        roll_files(file_name, file_index)
        @file_stats = {lines: 0, created_on: Time.now}
        @file_stats[:file_index] = file_index + 1
      end
    end

    def roll_files(file_name, file_index)
      file_index.downto(1) do |index|
        system("mv #{file_name}#{index} #{file_name}#{index + 1}")
      end
      system("mv #{file_name} #{file_name}1")
    end

    def reset_file_stats
      @file_stats = {lines: 0, created_on: Time.now}
    end

    def lines_limit?
      @file_stats[:lines] >= Config.file[:limits][:message_count]
    end

    def time_limit?
      ratio = TIME_UNIT_RATIO[Config.file[:limits][:time_unit]]
      difference = (Time.now - @file_stats[:created_on]) / ratio
      difference > Config.file[:limits][:time]
    end

    def size_limit?
      ratio = SIZE_UNIT_RATIO[Config.file[:limits][:size_unit]]
      File.stat(get_file_name).size / ratio > Config.file[:limits][:file_size]
    end

  end
end

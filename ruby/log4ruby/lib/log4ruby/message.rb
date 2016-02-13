require_relative 'config'
require 'time'

module Log4Ruby
  class LogMessage
    attr_accessor :message, :level, :type, :logger_id
    attr_reader :exception, :backtrace

    def initialize
      @time = Time.now
      instance_eval(&(proc)) if block_given?
    end

    def self.build(hash)
      self.new do
        @message, @level, = hash[:message], hash[:level]
        @logger_id = hash[:logger_id]
        @exception, @backtrace = hash[:exception], hash[:backtrace]
        @time = Time.parse(hash[:time])
      end
    end

    def satisfy?(filter_hash)
      filter_hash.empty? || filter_hash.any? do |key, value|
        if key === :time_range
          value.cover?(@time)
        else
          compare_values(send(key), value)
        end 
      end 
    end 

    def parse
      formatter = Config.message_formatters[@type]
      formatter[:parts].map do |log_part|
        send(log_part)
      end.compact.join(formatter[:delimiter])
    end

    def exception=(exception)
      @exception = exception
      if (exception.backtrace and @type)
        depth = Config.message_formatters[@type][:backtrace_depth]
        @backtrace = exception.backtrace.take(depth)
      end
    end

    def time_date
      @time
    end

    def level
      @level.to_s.upcase
    end

    def time
      @time.strftime(Config.time_formatters[@type])
    end

    private

    def compare_values(message_value, filter_value)
      filter_value === message_value ||
      message_value.to_s.downcase.include?(filter_value.to_s.downcase)
    end

  end
end

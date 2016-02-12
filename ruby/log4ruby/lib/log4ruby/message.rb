require_relative 'config'

module Log4Ruby
  class LogMessage
    attr_accessor :message, :level
    attr_reader :time, :exception, :logger_id, :type, :backtrace

    def initialize
      @time = Time.now
      instance_eval(&(proc)) if block_given?
    end

    def parse
      @time = @time.strftime(Config.time_formatters[@type])
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

  end
end

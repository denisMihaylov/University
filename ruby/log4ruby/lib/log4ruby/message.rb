require_relative 'config'

module Log4Ruby
  class LogMessage
    attr_accessor :message, :level, :type
    attr_reader :exception, :logger_id, :backtrace

    def initialize
      @time = Time.now
      instance_eval(&(proc)) if block_given?
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

    def time
      @time.strftime(Config.time_formatters[@type])
    end

  end
end

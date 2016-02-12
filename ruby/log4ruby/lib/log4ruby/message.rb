module Log4Ruby
  class LogMessage
    attr_accessor :logger_id, :time, :type, 
      :message, :level, :exception, :backtrace

    def initialize(logger_id, level, message, type, exception)
      @type, @level, @message = type, level.upcase, message
      @logger_id, @time = logger_id, Time.now
      if exception
        @exception = exception
      end
    end

    def parse
      @time = @time.strftime(Config.time_formatters[@type])
      formatter = Config.message_formatters[@type]
      formatter[:parts].map do |log_part|
        send(log_part)
      end.compact.join(formatter[:delimiter])
    end

  end
end

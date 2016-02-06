module Log4Ruby
  class LogMessage
    attr_accessor :logger_id, :time, :type, 
      :message, :level, :exception, :backtrace

    def initialize(logger_id, level, message, type = :file, exception)
      @type, @level, @message = type, level.upcase, message
      @logger_id, @time = logger_id, Time.now
      if exception
        @exception = exception
      end
    end

  end
end

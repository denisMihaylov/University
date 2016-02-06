module Log4Ruby
  class LogMessage
    attr_accessor :time, :type, :message, :level, :exception

    def initialize(level, message, type = :file, exception)
      @type, @level, @message = type, level.upcase, message
      @time = Time.now
      if exception
        @exception = exception
      end
    end

  end
end

module Log4Ruby
  class LogMessage
    attr_reader :type, :message, :level, :exception

    def initialize(level, message, type = :file, exception)
      @type, @level, @message, @exception = type, level, message, exception
      @time = Time.now
    end

    def to_s
      level = @level.to_s.upcase
      "#{level}|#@time|#@message"
    end

  end
end

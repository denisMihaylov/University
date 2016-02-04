module Log4Ruby
  class LogMessage

    def initialize(level, message, type = :file, exception)
      @time, @level, @message, @exception = Time.now, level, message, exception
    end

    def to_s
      level = @level.to_s.upcase
      "#{level}|#@time|#@message"
    end

  end
end

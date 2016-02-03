module Log4Ruby
  class LogMessage
  #attr_accessor :level, :time, :message

  def initialize(level, message, type = :file)
    @time, @level, @message = Time.now, level, message
  end

  def to_s
    level = @level.to_s.capitalize
    "#{level}|#@time|#@message"
  end

end

module Log4Ruby
  class ConsoleHandler < Handler

  def initialize
    @type = :console
  end

  def log_message(message)
    puts parse_message(message)
  end

  end
end

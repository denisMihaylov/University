module Log4Ruby
  class ConsoleHandler < Handler

  def log_message(message)
    puts parse_message(message, :console)
  end

  end
end

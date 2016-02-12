module Log4Ruby
  class ConsoleHandler < Handler

  def log_message(message)
    puts message.parse
  end

  end
end

module Log4Ruby
  class ConsoleHandler < Handler

  def log_message(message)
    puts message.to_s
  end

  end
end

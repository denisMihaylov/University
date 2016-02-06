module Log4Ruby
  class DBHandler < Handler

    def log_message(message)
      @queue << format_message(message)
      if (@queue.size >= Config.db[:sqlite][:threshold])
        persist_messages
      end
    end

  end
end

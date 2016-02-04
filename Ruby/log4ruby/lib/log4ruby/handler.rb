module Log4Ruby
  class Handler

    def log_message
      message = Store.instance.pop
      puts message.to_s
    end

  end
end

require_relative 'handler/console_handler'

module Log4Ruby
  class Handler
    HANDLERS = {
      console: ConsoleHandler.new,

    }
  end
end

module Log4Ruby
  class Handler

    def self.start_logging
      loop do
        message = Store.instance.pop
        HANDLERS[message.type].log_message(message)
      end
    end

  end
end

require_relative 'handler/console_handler'
require_relative 'handler/file_handler'

module Log4Ruby
  class Handler
    HANDLERS = {
      console: ConsoleHandler.new,
      file: FileHandler.new,
    }
  end
end
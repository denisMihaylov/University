module Log4Ruby
  class Handler

    def self.start_logging
      loop do
        message = Store.instance.pop
        HANDLERS[message.type].log_message(message)
      end
    end

    private

    def parse_message(message, logger_type)
      message.time = message.time.strftime(Config.time_formatters[logger_type])
      formatter = Config.message_formatters[logger_type]
      formatter[:parts].map do |log_part|
        message.send(log_part)
      end.compact.join(formatter[:delimiter])
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

require_relative 'handler/console_handler'
require_relative 'handler/file_handler'

module Log4Ruby
  class HandlerRegistry

    class << self

      def start_logging
        init_handlers
        loop do
          message = Store.instance.pop
          @@handlers[message.type].log_message(message)
        end
      end

      def init_handlers
        @@handlers = {
          console: ConsoleHandler.new,
          file: FileHandler.new,
        }
      end

    end

  end
end

require_relative 'handler/console_handler'
require_relative 'handler/file_handler'

module Log4Ruby
  class HandlerRegistry

    class << self

      def start_logging
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

      def register(logger_type, handler)
        unless @@handlers[logger_type]
          @@handlers[logger_type] = handler
        end
      end

      def register!(logger_type, hanlder)
        if @@handlers[logger_type]
          raise HandlerRegistryError, "Handler for '#{logger_type}' already "\
            "registered. Use Log4Ruby::HandlerRegistry#update_handler instead."
        end
        @@hanlders[logger_type] = handler
      end

      def update_handler(logger_type, handler)
        @@handlers[logger_type] = handler
      end

      def handlers
        @@handlers
      end

      def deregister(logger_type)
        @handlers.delete(logger_type)
      end

    end

  end
end

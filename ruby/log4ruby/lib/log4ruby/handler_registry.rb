require_relative 'handler/console_handler'
require_relative 'handler/file_handler'
require_relative 'handler/syslog_handler'
require_relative 'handler/remote_syslog_handler'

module Log4Ruby
  class HandlerRegistry

    class << self

      def log_message(message)
        @@handlers[message.type].log_message(message)
      end

      def init_handlers
        @@handlers = {
          console: ConsoleHandler.new,
          file: FileHandler.new,
          syslog: SyslogHandler.new,
          remote: RemoteSyslogHandler.new,
        }
      end

      def register(logger_type, handler, define_method = true)
        unless @@handlers[logger_type]
          @@handlers[logger_type] = handler
        end
        define_logger_provider_method(logger_type) if define_method
      end

      def register!(logger_type, hanlder, define_method = true)
        if @@handlers[logger_type]
          raise HandlerRegistryError, "Handler for '#{logger_type}' already "\
            "registered. Use Log4Ruby::HandlerRegistry#update_handler instead."
        end
        register(logger_type, handler, define_method)
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

      private

      def define_logger_provider_method(logger_type)
        Log4Ruby.class_eval do
          define_method(get_method_name(logger_type)) do |id, level = :info|
            Logger.new(id, level, logger_type)
          end
        end
      end

      def get_method_name(logger_type)
        logger_type_down = logger_type.downcase
        if logger_type_down.include?("logger")
          logger_type_down.downcase
        else
          "#{logger_type_down}_logger"
        end
      end

    end

  end
end

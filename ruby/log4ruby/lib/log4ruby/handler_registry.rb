require_relative 'handler'
require_relative 'handler/console_handler'
require_relative 'handler/file_handler'
require_relative 'handler/syslog_handler'
require_relative 'handler/remote_syslog_handler'
require_relative 'error'

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
        validate_handler(handler)
        unless @@handlers[logger_type]
          @@handlers[logger_type] = handler
          define_logger_provider_method(logger_type) if define_method
        end
      end

      def register!(logger_type, handler, define_method = true)
        if @@handlers[logger_type]
          raise HandlerRegistryError, "Handler for '#{logger_type}' already "\
            "registered. Use Log4Ruby::HandlerRegistry#update_handler instead."
        end
        register(logger_type, handler, define_method)
      end

      def update_handler(logger_type, handler)
        unless @@handlers[logger_type]
          raise HandlerRegistryError, "Unable to update a handler that "\
            "does not exist. Use the #register method instead"
        end
        @@handlers[logger_type] = handler
      end

      def handlers
        @@handlers
      end

      def deregister(logger_type)
        unless @@handlers[logger_type]
          raise HandlerRegistryError, "Unable to deregister a handler that "\
            "does not exist."
        end
        @@handlers.delete(logger_type)
      end

      def handles?(logger_type)
        not @@handlers[logger_type].nil?
      end

      private

      def validate_handler(handler)
        unless (handler.respond_to?(:log_message) and
                handler.method(:log_message).parameters.size == 1)
          raise HandlerRegistryError, "Handlers should implement "\
            "#log_message method that has one arguement: the log message "\
            "it should proccess"
        end
      end

      def define_logger_provider_method(logger_type)
        method_name = get_method_name(logger_type)
        Log4Ruby.class_eval do
          define_singleton_method(method_name) do |id, level = :info|
            Logger.new(id, level, logger_type)
          end
        end
      end

      def get_method_name(logger_type)
        logger_type_down = logger_type.to_s.downcase
        if logger_type_down.include?("logger")
          logger_type_down.downcase
        else
          "#{logger_type_down}_logger"
        end
      end

    end

  end
end

Log4Ruby::HandlerRegistry.init_handlers

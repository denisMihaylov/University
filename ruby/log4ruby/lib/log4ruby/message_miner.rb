require_relative 'message'
require_relative 'handler_registry'

module Log4Ruby
  #LogMessageMiner class that allows mining through the log messages
  class LogMessageMiner
    include Enumerable

    def initialize(logger_type:, **filter)
      validate_filter(filter)
      validate_logger_type(logger_type)
      @handler = HandlerRegistry.handlers[logger_type]
      @filter = filter
    end

    def each
      enum_for(:each_message).lazy.each do |message|
        yield message
      end
    end

    private

    def validate_logger_type(logger_type)
      unless HandlerRegistry.handles?(logger_type)
        raise LogMessageMinerError, "Logger type '#{logger_type}' has no "\
          "handler defined"
      end
    end

    def validate_filter(filter)
      message_instance = LogMessage.new
      filter.keys.each do |key|
        unless message_instance.respond_to?(key)
          raise LogMessageMinerError, "#{key} is not a valid filter property"
        end
      end
    end

    def each_message
      @handler.each_message(@filter) {|message| yield message}
    end

  end
end

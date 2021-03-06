require_relative 'constants'
require_relative 'handler_registry'
require_relative 'message'

module Log4Ruby
  # Logger class that the user uses as API to log messages
  class Logger
    attr_accessor :level, :id, :handler

    def initialize(id, level, handler)
      @id = id
      @level = level
      @handler = handler
    end

    LEVELS[1..-2].each do |level|
      define_method(level) do |message, exception = nil|
        log(level, message, exception) if logging_allowed?(level)
      end
      define_method("#{level}_enabled?") do
        logging_allowed?(level)
      end
    end

    private

    def log(level, message, exception)
      id = @id
      handler = @handler
      message = LogMessage.new do
        @logger_id = id
        @level = level
        @message = message
        @type = handler
        self.exception = exception if exception
      end
      HandlerRegistry.log_message(message)
    end

    def logging_allowed?(level)
      LEVELS.index(level) <= LEVELS.index(@level)
    end
  end
end

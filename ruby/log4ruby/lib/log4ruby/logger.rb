require_relative 'constants'

module Log4Ruby
  class Logger
    attr_accessor :level, :id, :handler

    def initialize(id, level, handler)
      @id = id
      @level = level
      @handler = handler
    end

    def logging_allowed?(level)
      LEVELS.index(level) <= LEVELS.index(@level)
    end

    LEVELS[1..-2].each do |level|
      define_method(level) do |message, exception = nil|
        log(level, message, exception) if logging_allowed?(level)
      end
      define_method("#{level.to_s}_enabled?") do
        logging_allowed?(level)
      end 
    end

    private

    def log(level, message, exception)
      id, handler = @id, @handler
      message = LogMessage.new do
        @logger_id = id
        @level = level
        @message = message
        @type = handler
        self.exception = exception
      end
      fork {HandlerRegistry.log_message(message)}
    end 

  end
end

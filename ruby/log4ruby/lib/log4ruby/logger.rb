module Log4Ruby
  class Logger
    attr_accessor :level, :id

    def initialize(id, level)
      @id = id
      @level = level
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

  end
end

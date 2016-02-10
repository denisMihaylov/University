module Log4Ruby
  class Logger
    attr_accessor :level, :id

    def initialize(id, level)
      @id = id
      @level = level
    end

    LEVELS[1..-2].each do |level|
      define_method(level) do |message, exception = nil|
        if logging_allowed?(level)
          log(level, message, exception)
        end
      end
    end


    private

    def logging_allowed?(level)
      LEVELS.index(level) <= LEVELS.index(@level)
    end

  end
end

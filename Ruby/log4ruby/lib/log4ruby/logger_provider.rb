require_relative 'logger/console_logger.rb'

module Log4Ruby

  class << self

    def console_logger(level = :info)
      ConsoleLogger.new(level)
    end

  end

end

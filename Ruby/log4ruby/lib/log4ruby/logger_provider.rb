require_relative 'logger/console_logger.rb'

module Log4Ruby

  class << self

    def get_console_logger
      ConsoleLogger.new
    end

  end

end

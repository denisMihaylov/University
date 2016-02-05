require_relative 'logger/console_logger'
require_relative 'logger/file_logger'

module Log4Ruby

  class << self

    def console_logger(level = :info)
      ConsoleLogger.new(level)
    end

    def file_logger(level = :info)
      FileLogger.new(level)
    end

  end

end

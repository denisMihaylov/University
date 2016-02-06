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

    def db_logger(db_type)
      DBLogger.new(db_type)
    end

    def sqlite3_logger
      db_logger(:sqlite3)
    end

  end

end

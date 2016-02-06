require_relative 'logger/console_logger'
require_relative 'logger/file_logger'
require_relative 'logger/db_logger'
require_relative 'handler/db_handler'

module Log4Ruby

  class << self

    def console_logger(level = :info)
      ConsoleLogger.new(level)
    end

    def file_logger(level = :info)
      FileLogger.new(level)
    end

    def db_logger(db_type, level = :info)
      DBLogger.new(db_type, level)
    end

    def sqlite3_logger
      require_relative 'handler/sqlite3_handler'
      HandlerRegistry.register(:sqlite3, SQLite3Handler.new) 
      db_logger(:sqlite3)
    end

  end

end

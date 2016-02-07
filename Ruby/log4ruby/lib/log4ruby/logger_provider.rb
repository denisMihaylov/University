require_relative 'logger/console_logger'
require_relative 'logger/file_logger'
require_relative 'logger/db_logger'
require_relative 'handler/db_handler'

module Log4Ruby

  class << self

    def console_logger(id, level = :info)
      ConsoleLogger.new(level)
    end

    def file_logger(id, level = :info)
      FileLogger.new(id, level)
    end

    def db_logger(db_type, id, level = :info)
      DBLogger.new(id, db_type, level)
    end

    def sqlite3_logger(id, level = :info)
      require_relative 'handler/sqlite3_handler'
      HandlerRegistry.register(:sqlite3, SQLite3Handler.new) 
      db_logger(:sqlite3, id, level)
    end

    def postgresql_logger(id, level = :info)
      require_relative 'handler/postgresql_handler'
      HandlerRegistry.register(:postgresql, PostgreSQLHandler.new)
      db_logger(:postgresql, id, level)
    end

    def mysql_logger(id, level = :info)
      require_relative 'handler/mysql_handler'
      HandlerRegistry.register(:mysql, MysqlHandler.new)
      db_logger(:mysql, id, level)
    end

  end

end

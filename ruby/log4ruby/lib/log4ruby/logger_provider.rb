require_relative 'handler/db_handler'

module Log4Ruby

  class << self

    def console_logger(id, level = :info)
      Logger.new(id, level, :console)
    end

    def file_logger(id, level = :info)
      Logger.new(id, level, :file)
    end

    def sqlite3_logger(id, level = :info)
      require_relative 'handler/sqlite3_handler'
      HandlerRegistry.register(:sqlite3, SQLite3Handler.new, false)
      db_logger(id, level, :sqlite3)
    end

    def postgresql_logger(id, level = :info)
      require_relative 'handler/postgresql_handler'
      HandlerRegistry.register(:postgresql, PostgreSQLHandler.new, false)
      db_logger(id, level, :postgresql)
    end

    def mysql_logger(id, level = :info)
      require_relative 'handler/mysql_handler'
      HandlerRegistry.register(:mysql, MysqlHandler.new, false)
      db_logger(id, level, :mysql)
    end

    def syslog_logger(facility = Config.syslog[:facility], level = :info)
      Logger.new(facility, level, :syslog)
    end

    def remote_logger(facility = Config.syslog[:facility], level = :info)
      Logger.new(facility, level, :remote)
    end

    private

    def db_logger(id, level = :info, db_type)
      Logger.new(id, level, db_type)
    end

  end

end

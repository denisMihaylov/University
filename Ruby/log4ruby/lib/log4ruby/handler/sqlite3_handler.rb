require 'sqlite3'

module Log4Ruby
  class SQLite3Handler < DBHandler

    STATEMENT_START = "INSERT INTO #{Config.db[@type][:table_name]} 
      (LOGGER_ID, LEVEL, TIME, EXCEPTION, MESSAGE) "

    def initialize
      @type, @queue = :sqlite3, []
    end

    def persist_messages
      db = SQLite3::Database.open(Config.db[:sqlite3][:db_path])
      db.execute("CREATE TABLE IF NOT EXISTS #{Config.db[@type][:table_name]}
        (LOGGER_ID, LEVEL, TIME, EXCEPTION, MESSAGE)"
      db.execute(statement)
    rescue SQLite3::Exception => e
      puts e
    ensure
      db.close if db
    end

    def statement
      
    end

  end
end

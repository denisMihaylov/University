require 'sqlite3'

module Log4Ruby
  class SQLite3Handler < DBHandler

    def initialize
      @type = :sqlite3
      create_table
    end

    private

    def create_table
      db = SQLite3::Database.open(db_name)
      db.execute(create_table_statement)
    rescue SQLite3::Exception => e
      p e.backtrace.take(5) if e.backtrace
      p e
    ensure
      db.close if db
    end

    def persist_message(message)
      db = SQLite3::Database.open(db_name)
      db.execute(insert_statement(message))
    rescue SQLite3::Exception => e
      p e.backtrace.take(5)
      p e
    ensure
      db.close if db
    end

  end
end

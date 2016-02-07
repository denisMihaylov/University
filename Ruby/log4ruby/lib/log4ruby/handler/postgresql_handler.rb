require 'pg'

module Log4Ruby
  class PostgreSQLHandler < DBHandler
    #INSERT multiple records into the database
    INSERT_STATEMENT = "INSERT INTO %s (%s) VALUES %s"
    
    def initialize
      @type, @queue = :postgresql, []
      create_table
    end

    def create_table
      con = connect_to_database
      con.exec(create_table_statement)
    rescue PG::Error => e
      p e
      p e.backtrace.take(5) if e.backtrace
    ensure
      con.close if con
    end

    def persist_messages
      con = connect_to_database
      con.exec(insert_statement)
      @queue = []
    rescue PG::Error => e
      p e
      p e.backtrace.take(5) if e.backtrace
    ensure
      con.close if con
    end

    def insert_statement
      values = map_internal(@queue) do |message|
        message_to_statement(message)
      end
      parts = [table_name, map_internal(get_columns, &:to_s), values]
      INSERT_STATEMENT % parts
    end

    def message_to_statement(message)
      "(%s)" % map_internal(get_columns) do |column|
        quote(message.send(column))
      end
    end

    def connect_to_database
      PG.connect :dbname => db_name, :user => user, :password => password
    end

  end
end

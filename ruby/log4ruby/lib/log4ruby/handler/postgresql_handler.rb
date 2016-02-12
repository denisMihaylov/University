require 'pg'
require_relative 'db_handler'

module Log4Ruby
  class PostgreSQLHandler < DBHandler
    
    def initialize
      @type = :postgresql
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

    def persist_message(message)
      con = connect_to_database
      con.exec(insert_statement(message))
    rescue PG::Error => e
      p e
      p e.backtrace.take(5) if e.backtrace
    ensure
      con.close if con
    end

    def connect_to_database
      PG.connect :dbname => db_name, :user => user, :password => password
    end

  end
end

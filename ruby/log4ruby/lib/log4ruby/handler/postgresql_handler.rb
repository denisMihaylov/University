require 'pg'
require_relative 'db_handler'

module Log4Ruby
  #PostgreSQL handler that allows logging to a postgres database
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

    def each_message(filter_hash)
      con = connect_to_database
      result = con.exec(select_statement)
      result.each do |row|
        message = LogMessage.build(get_hash_from_row(row))
        message.type = :sqlite3
        yield message if message.satisfy?(filter_hash)
      end
    rescue PG::Error => e
      p e 
      p e.backtrace.take(5) if e.backtrace
    ensure
      con.close if con 
    end 

    def get_hash_from_row(row)
      row.inject({}) {|hash, (key, value)| hash[key.to_sym] = value}
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

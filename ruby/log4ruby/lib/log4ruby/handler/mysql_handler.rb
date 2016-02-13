require 'mysql'
require_relative 'db_handler'

module Log4Ruby
  #Mysql handler that allows logging to a mysql database
  class MysqlHandler < DBHandler

    def initialize
      @type = :mysql
      create_table
    end

    def create_table
      con = connect_to_database
      con.query(create_table_statement)
    rescue Mysql::Error => e
      puts e.errno
      puts e.error
    ensure
      con.close if con
    end

    def each_message(filter_hash)
      con = connect_to_database
      p select_statement
      con.query(select_statement).each do |row|
        message = LogMessage.build(get_hash_from_row(row))
        message.type = :mysql
        yield message if message.satisfy?(filter_hash)
      end
    end

    def persist_message(message)
      con = connect_to_database
      con.query(insert_statement(message))
    rescue Myslq::Error => e
      puts e.errno
      puts e.error
    ensure
      con.close if con
    end

    def connect_to_database
      Mysql.new('localhost', user, password, db_name)
    end

  end
end

require 'mysql'

module Log4Ruby
  class MysqlHandler < DBHandler
    INSERT_STATEMENT = "INSERT INTO %s (%s) VALUES %s"

    def initialize
      @type, @queue = :mysql, []
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

    def persist_messages
      con = connect_to_database
      con.query(insert_statement)
      @queue = []
    rescue Myslq::Error => e
      puts e.errno
      puts e.error
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
      Mysql.new('localhost', user, password, db_name)
    end

  end
end

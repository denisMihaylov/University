require 'mysql'

module Log4Ruby
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

    def persist_message(message)
      con = connect_to_database
      con.query(insert_statement(message))
      @queue = []
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

require 'sqlite3'

module Log4Ruby
  class SQLite3Handler < DBHandler

    def initialize
      @type, @queue = :sqlite3, []
      create_table
    end

    def create_table
      db = SQLite3::Database.open(Config.db[@type][:db_name])
      db.execute(create_table_statement)
    rescue SQLite3::Exception => e
      p e.backtrace.take(5)
      p e
    ensure
      db.close if db
    end

    def persist_messages
      db = SQLite3::Database.open(Config.db[@type][:db_name])
      db.execute(insert_statement)
      @queue = []
    rescue SQLite3::Exception => e
      p e.backtrace.take(5)
      p e
    ensure
      db.close if db
    end

    def insert_statement
      parts = [table_name, map_internal(get_columns, &:to_s), select_statements]
      INSERT_STATEMENT % parts
    end

    def select_statements
      message = @queue.shift
      columns = get_columns
      first_message = map_internal(columns) do |column|
        VALUE_COLUMN_PAIR % [quote(message.send(column)), column]
      end
      first_message = "SELECT %s" % first_message
      other_messages = @queue.map do |message|
        "SELECT #{map_internal(columns) {|column| quote(message.send(column))}}"
      end
      other_messages.insert(0, first_message).join(" UNION ALL ".freeze)
    end

  end
end

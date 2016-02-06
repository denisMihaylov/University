require 'sqlite3'

module Log4Ruby
  class SQLite3Handler < DBHandler

    STATEMENT = "INSERT INTO #{Config.db[@type][:table_name]} (%s) %s"
    FIRST_SELECT = "%s AS %s"

    def initialize
      @type, @queue = :sqlite3, []
    end

    def persist_messages
      db = SQLite3::Database.open(Config.db[@type][:db_path])
      db.execute(create_table_statement)
      db.execute(statement)
      @queue = []
    rescue => e
      puts e
    ensure
      db.close if db
    end

    def statement
      columns = Config.message_formatters[@type][:parts]
      STATEMENT % [columns.map(&:to_s).join(", "), select_statements(columns)]
    end

    def select_statements(columns)
      message = @queue.shift
      first_select = columns.map do |column|
        FIRST_SELECT % ["'" + message.send(column).to_s + "'" || "'NIL'", column]
      end.join(", ")
      first_statement = "SELECT %s" % first_select
      other_statements = @queue.map do |message|
        "SELECT " + columns.map {|column| "'" + message.send(column).to_s + "'"||"'NILL'"}.join(", ")
      end
      other_statements.insert(0, first_statement).join(" UNION ALL ")
    end

    def create_table_statement
      "CREATE TABLE IF NOT EXISTS #{Config.db[@type][:table_name]} (" +
      Config.message_formatters[@type][:parts].join(", ") + ")"
    end

  end
end

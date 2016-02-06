require 'sqlite3'

module Log4Ruby
  class SQLite3Handler < DBHandler

    def log_message(message)
      puts message.type
    end

  end
end

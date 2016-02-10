module Log4Ruby
  #Simple sql util methods that can be mixed into DBHandlers
  module SQLUtils
    INSERT_STATEMENT = "INSERT INTO %s (%s) VALUES (%s)"
    CREATE_STATEMENT = "CREATE TABLE IF NOT EXISTS %s (Id %s, %s)"

    def create_table_statement
      columns_part = get_columns.map do |column|
        "%s %s" % [column.to_s, column_to_type(column)]
      end
      CREATE_STATEMENT % [table_name, primary_key_type, concat(columns_part)]
    end

    def insert_statement(message)
      values = get_values(message)
      parts = [table_name, map_internal(get_columns, &:to_s), values]
      INSERT_STATEMENT % parts
    end 

    def get_values(message)
      columns = get_columns
      map_internal(columns) {|column| quote(message.send(column))}
    end 

    def quote(value)
      if value.nil? || value.to_s.empty?
        'NULL'.freeze
      else
        "'%s'".freeze % value.to_s
      end
    end

    def table_name
      Config.db[@type][:table_name]
    end

    def get_columns
      Config.message_formatters[@type][:parts]
    end

    def concat(parts)
      parts.map(&:to_s).join(", ".freeze)
    end

    def column_to_type(column)
      if (column === :time || column == :date)
        Config.db[@type][:types][:time]
      else
        Config.db[@type][:types][:text]
      end
    end

    def map_internal(parts)
      concat(parts.map {|part| yield part})
    end

    def db_name
      Config.db[@type][:db_name]
    end

    def user
      Config.db[@type][:user]
    end

    def password
      Config.db[@type][:password]
    end

    def primary_key_type
      Config.db[@type][:types][:primary_key]
    end

  end
end

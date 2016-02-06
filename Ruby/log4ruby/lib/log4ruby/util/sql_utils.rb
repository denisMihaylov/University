module Log4Ruby
  #Simple sql util methods that can be mixed into DBHandlers
  module SQLUtils
    #INSERT multiple records into the database
    INSERT_STATEMENT = "INSERT INTO %s (%s) %s"

    #Formatter of 'value AS column'
    VALUE_COLUMN_PAIR = "%s AS %s"

    #CTEATE table statement
    CREATE_STATEMENT = "CREATE TABLE IF NOT EXISTS %s 
      (Id INTEGER PRIMARY KEY, %s)"

    def quote(value)
      value.nil? || value.empty? ? 'NULL'.freeze : "'%s'".freeze % value.to_s
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

    def create_table_statement
      columns_part = get_columns.map do |column|
        "%s %s" % [column.to_s, column_to_type(column)]
      end
      CREATE_STATEMENT % [table_name, concat(columns_part)]
    end

    def column_to_type(column)
      if (column === :time || column == :date)
        'DATETIME'.freeze
      else
        'TEXT'.freeze
      end
    end

    def map_internal(parts)
      concat(parts.map {|part| yield part})
    end

  end
end

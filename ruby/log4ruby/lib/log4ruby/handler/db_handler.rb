require_relative '../util/sql_utils'
require_relative '../handler'
require_relative '../config'

module Log4Ruby
  class DBHandler < Handler
    include SQLUtils

    def log_message(message)
      persist_message(message)
    end

    def get_hash_from_row(row)
      columns = get_columns
      row.each_with_index.inject({}) do |hash, (part, index)|
        hash.merge!(columns[index] => part)
      end 
    end 

  end
end

require_relative '../util/sql_utils'

module Log4Ruby
  class DBHandler < Handler
    include SQLUtils

    def log_message(message)
      persist_message(message)
    end

  end
end

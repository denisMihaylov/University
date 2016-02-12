require_relative '../util/sql_utils'
require_relative '../handler'
require_relative '../config'

module Log4Ruby
  class DBHandler < Handler
    include SQLUtils

    def log_message(message)
      message.time = message.time.strftime(Config.time_formatters[@type])
      persist_message(message)
    end

  end
end

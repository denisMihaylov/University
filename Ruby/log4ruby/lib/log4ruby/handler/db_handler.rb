require_relative '../util/sql_utils'

module Log4Ruby
  class DBHandler < Handler
    include SQLUtils

    def log_message(message)
      @queue << format_message(message)
      if (@queue.size >= Config.db[@type][:threshold])
        persist_messages
      end
    end

  end
end

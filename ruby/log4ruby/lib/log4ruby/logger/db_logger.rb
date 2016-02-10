module Log4Ruby
  class DBLogger < Logger
    #By the db_type when logging messages the corresponding
    #handler will be invoked
    attr_reader :db_type

    def initialize(id, db_type, level)
      @id, @db_type, @level = id, db_type, level
    end

    def log(level, message, exception)
      message = LogMessage.new(@id, level, message, db_type, exception)
      Store.instance.push(message)
    end

  end
end

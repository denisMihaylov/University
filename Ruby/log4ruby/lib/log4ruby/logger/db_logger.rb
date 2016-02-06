module Log4Ruby
  class DBLogger
    #By the db_type when logging messages the corresponding
    #handler will be invoked
    attr_reader :db_type

    def initialize(db_type)
      @db_type = db_type
    end

    def log(level, message, exception)
      Store.instance.push(LogMessage.new(level, message, db_type, exception))
    end

  end
end

module Log4Ruby
  class DBHandler < Handler

    def initialize(db_type)
      @db_type = db_type
    end

  end
end

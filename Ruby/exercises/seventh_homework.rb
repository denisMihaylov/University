module LazyMode

  class Date
    attr_accessor :year, :month, :day
    def initialize(date_string)
      @year, @month, @day = date_string.split('-').map {|part| part.to_i}
    end

  end

end



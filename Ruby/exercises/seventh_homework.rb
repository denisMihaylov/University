module LazyMode

  class Date
    attr_accessor :year, :month, :day
    def initialize(date_string)
      @year, @month, @day = date_string.split('-').map {|part| part.to_i}
    end

    def to_s
      "#{'%04d' % @year}-#{'%02d' % @month}-#{'%02d' % @day}"
    end

  end

end



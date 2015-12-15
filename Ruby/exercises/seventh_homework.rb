module LazyMode

  class << self

    def create_file(file_name)
      File.new(file_name, &(proc))
    end

  end

end

class LazyMode::Date
  attr_accessor :year, :month, :day
  def initialize(date_string)
    @year, @month, @day = date_string.split('-').map {|part| part.to_i}
  end

  def to_s
    "#{'%04d' % @year}-#{'%02d' % @month}-#{'%02d' % @day}"
  end

end

class LazyMode::File

  def initialize(file_name)
    @name = file_name
    instance_eval(&(proc))
  end

  private

  def note
    
  end

end

class LazyMode::Note

end

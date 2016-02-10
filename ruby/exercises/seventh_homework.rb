module LazyMode

  class << self

    def create_file(file_name, &block)
      File.new(file_name, &block)
    end

  end

end

module LazyMode::Notable

  def notes
    if @notes_as_array
      @notes_as_array
    else
      @notes_as_array = get_notes_as_array
    end
  end

  private

  def note(header, *tags, &block)
    @notes << LazyMode::Note.new(header, @name || @file_name, *tags, &block)
  end

  def get_notes_as_array
    @notes.inject([]) do |all_notes, note|
      all_notes << note
      all_notes += note.notes
    end
  end

end

class LazyMode::Date
  attr_accessor :year, :month, :day

  def initialize(date_string = "")
    @year, @month, @day = date_string.split('-').map {|part| part.to_i}
  end

  def to_s
    "#{'%04d' % @year}-#{'%02d' % @month}-#{'%02d' % @day}"
  end

  def -(other)
    to_days - other.to_days
  end

  def is_after?(other)
    to_days > other.to_days
  end

  def to_days
    @year * 360 + @month * 30 + @day
  end

  def travel_in_time(days)
    self.class.from_days(to_days + days)
  end

  class << self

    def from_days(days)
      year, month, day = days / 360, days / 30 % 12, days % 30
      self.new("#{year}-#{month}-#{day}")
    end

  end

end

class LazyMode::File
  include LazyMode::Notable
  attr_reader :name

  def initialize(file_name, &block)
    @name, @notes = file_name, []
    instance_eval(&block)
  end

  def daily_agenda(date)
    LazyMode::Agenda.new(notes, date, :daily)
  end

  def weekly_agenda(date)
    LazyMode::Agenda.new(notes, date, :weekly)
  end

end

class LazyMode::Agenda
  attr_reader :notes

  def initialize(notes, date, type)
    @notes = notes.select {|note| note.belongs_to_agenda?(date, type)}
    @notes = @notes.map {|note| note.reschedule(date)}
  end

  def where(text: //, tag: nil, status: nil)
    filtered_tasks = self.dup
    filtered_tasks.notes.select! do |note|
      select_note?(note, text, tag, status)
    end
    filtered_tasks
  end

  private

  def select_note?(note, text, tag, status)
    (text === note.body or text === note.header) and
    (tag ? note.tags.include?(tag) : true) and
    (status ? note.status == status : true)
  end

end

class LazyMode::Note
  include LazyMode::Notable
  attr_reader :header, :tags, :file_name
  attr_accessor :date

  RECURRENCE_INTERVAL = {'m' => 30, 'w' => 7, 'd' => 1}

  def initialize(header, file_name, *tags, &block)
    @header, @file_name, @tags, @notes = header, file_name, tags ? tags : [], []
    instance_eval(&block)
  end

  def body(body = @body)
    @body = body
  end

  def status(status = @status || :topostpone)
    @status = status
  end

  def scheduled(date = nil)
    if date
      date, recurrence = date.split(" ")
      set_recurrence(recurrence)
      @date = LazyMode::Date.new(date)
    else
      @date
    end
  end

  def belongs_to_agenda?(date, type)
    if (type == :weekly)
      (0..6) === days_to_closest_occurrence(date)
    else
      days_to_closest_occurrence(date) == 0
    end
  end

  def reschedule(date)
    rescheduled = self.dup
    rescheduled.date = date.travel_in_time(days_to_closest_occurrence(date))
    rescheduled
  end

  private

  def set_recurrence(recurrence)
    if recurrence
      days = RECURRENCE_INTERVAL[recurrence[2]]
      @recurrence_interval = recurrence[1].to_i * days
    end
  end

  def days_to_closest_occurrence(date)
    days = scheduled - date
    @recurrence_interval ? days % @recurrence_interval : days
  end

end

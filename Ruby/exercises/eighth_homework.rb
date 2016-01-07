class Spreadsheet

  def initialize(tab_separated_values = "")
    input = tab_separated_values.strip
    @sheet = input.split("\n").map(&:strip).map do |line|
      line.split(/  |\t/)
    end
  end

  def empty?
    @sheet.empty?
  end

  def cell_at(cell_index)
    validate_cell_index_format(cell_index)
    row, column = index_to_row_and_column(cell_index)
    if @sheet.size <= row or @sheet.first.size <= column
      raise Error, "Cell #{cell_index} does not exist"
    end
    @sheet[row][column].to_s
  end

  private

  def validate_cell_index_format(cell_index)
    unless /\A[[:alpha:]]+[[:digit:]]+\z/ === cell_index
      raise Error, "Invalid cell index #{cell_index}"
    end
  end

  def index_to_row_and_column(cell_index)
    column, row = cell_index.scan(/\A[[:alpha:]]+|[[:digit:]]+\z/)
    row = row.to_i - 1
    column = column.split("").map() do |letter|
      letter.ord - "A".ord
    end.reduce(&:+) + 26 * (column.size - 1)
    p [row, column]
  end

end

class Spreadsheet::Error < Exception

end

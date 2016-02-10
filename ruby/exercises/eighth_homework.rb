module Formula

  def add(parameters)
    check_arguments_at_least('ADD', 2, parameters)
    parameters.reduce(&:+)
  end

  def multiply(parameters)
    check_arguments_at_least('MULTIPLY', 2, parameters)
    parameters.reduce(&:*)
  end

  def subtract(parameters)
    check_arguments('SUBTRACT', 2, parameters)
    parameters[0] - parameters[1]
  end

  def divide(parameters)
    check_arguments('DIVIDE', 2, parameters)
    parameters[0] / parameters[1]
  end

  def mod(parameters)
    check_arguments('MOD', 2, parameters)
    parameters[0] % parameters[1]
  end

  def check_arguments(formula, expected, parameters)
    if parameters.size != expected
      raise Spreadsheet::Error, "Wrong number of arguments for '#{formula}': "\
                   "expected #{expected}, got #{parameters.size}"
    end
  end

  def check_arguments_at_least(formula, expected, parameters)
    if parameters.size < expected
      raise Spreadsheet::Error, "Wrong number of arguments for '#{formula}': "\
                   "expected at least #{expected}, got #{parameters.size}"
    end
  end

end

module Evaluate
  NUMBER_PATTERN = /\A(\d|\.)+\z/
  FORMULA_PATTERN = %r{
    \A                                                   #start of string
    [A-Z]+                                               #formula
    \(                                                   #opening bracket
    (?<param>([A-Z]+\d+|\d+\.?\d*))?(\s*,\s*\g<param>?)* #parameters
    \)                                                   #closing bracket
    \z                                                   #end of string
  }x
  VALID_FORMULA = ["ADD", "MULTIPLY", "SUBTRACT", "DIVIDE", "MOD"]

  def evaluate_cell(cell_index)
    cell_content = cell_at_internal(cell_index.strip)
    evaluate_content(cell_content)
  end

  def evaluate_content(cell_content)
    if cell_content.start_with?("=")
      evaluate_expression(cell_content[1..(-1)].strip)
    else
      evaluate_non_expression(cell_content)
    end
  end

  def evaluate_non_expression(content)
    if /\A\d/ === content
      Float(content)
    else
      content
    end
  end

  def evaluate_expression(expression)
    case expression
      when Spreadsheet::TABLE_CELL_PATTERN then evaluate_cell(expression)
      when NUMBER_PATTERN then Float(expression)
      when FORMULA_PATTERN then evaluate_formula_expression(expression)
      else raise Spreadsheet::Error, "Invalid expression '#{expression}'"
    end
  end

  def evaluate_formula_expression(expression)
    parameters_string = /\([A-Z\d,\s\.]*\)/.match(expression)[0][1..(-2)]
    parameters = parameters_string.split(",").map(&:strip)
    formula = /[A-Z]+/.match(expression)[0]
    evaluate_formula(formula, evaluate_parameters(parameters))
  end

  def evaluate_parameters(parameters)
    parameters.map do |parameter|
      if /\A\d/ === parameter
        Float(parameter)
      else
        evaluate_cell(parameter)
      end
    end
  end

  def evaluate_formula(formula, parameters)
    validate_formula(formula)
    send(formula.downcase.to_sym, parameters)
  end

  def validate_formula(formula)
    unless VALID_FORMULA.include?(formula)
      raise Spreadsheet::Error, "Unknown function '#{formula}'"
    end
  end

end

module SpreadsheetInternal

  def validate_cell_index_format(cell_index)
    unless Spreadsheet::TABLE_CELL_PATTERN === cell_index
      raise Spreadsheet::Error, "Invalid cell index #{cell_index}"
    end
  end

  def index_to_row_and_column(cell_index)
    column, row = cell_index.scan(/\A[[:alpha:]]+|[[:digit:]]+\z/)
    row = row.to_i - 1
    column = column.split("").map() do |letter|
      letter.ord - "A".ord
    end.reduce(&:+) + 26 * (column.size - 1)
    [row, column]
  end

  def finalize_output(cell_output)
    if String === cell_output
      cell_output
    else
      integer, float = cell_output.to_i, cell_output.to_f
      integer == float ? integer.to_s : '%.2f' % cell_output
    end
  end

end

class Spreadsheet
  include SpreadsheetInternal
  include Formula
  include Evaluate

  TABLE_CELL_PATTERN = /\A[A-Z]+\d+\z/

  def initialize(tab_separated_values = "")
    input = tab_separated_values.strip
    @sheet = input.split("\n").map(&:strip).map do |line|
      line.split(/\s{2,}|\t/)
    end
  end

  def empty?
    @sheet.empty?
  end

  def cell_at(cell_index)
    finalize_output(cell_at_internal(cell_index))
  end

  def cell_at_internal(cell_index)
    validate_cell_index_format(cell_index)
    row, column = index_to_row_and_column(cell_index)
    if @sheet.size <= row or @sheet.first.size <= column
      raise Error, "Cell '#{cell_index}' does not exist"
    end
    @sheet[row][column]
  end

  def [](cell_index)
    finalize_output(evaluate_cell(cell_index))
  end

  def to_s
    @sheet.map do |line|
      line.map {|content| finalize_output(evaluate_content(content))}.join("\t")
    end.join("\n")
  end

end

class Spreadsheet::Error < Exception

end

module TurtleGraphics

  module Canvas

  end

end

class TurtleGraphics::Turtle
  attr_reader :max_stepped, :canvas, :position, :orientation
  ORIENTATIONS = {left: 0, up: 1, right: 2, down: 3}

  def initialize(rows, columns)
    @max_stepped = 0
    @rows = rows
    @columns = columns
    @canvas = Array.new(rows) {|_| Array.new(columns, 0)}
    @orientation = 2
    @position = [0, 0]
  end

  def draw(canvas = nil)
    instance_eval(&(proc)) if block_given?
    mark_current_position
    canvas ? canvas.transform(self) : @canvas
  end

  def spawn_at(row, column)
    @position = [row, column]
  end

  def look(orientation)
    @orientation = ORIENTATIONS[orientation]
  end

  def move
    mark_current_position
    case @orientation
      when 0 then @position[1] = (@position[1] - 1) % @columns
      when 1 then @position[0] = (@position[0] - 1) % @rows
      when 2 then @position[1] = (@position[1] + 1) % @columns
      else @position[0] = (@position[0] + 1) % @rows
    end
  end

  def turn_right
    @orientation = (@orientation + 1) % 4
  end

  def turn_left
    @orientation = (@orientation - 1) % 4
  end

  private

  def mark_current_position
    current = (@canvas[@position.first][@position.last] += 1)
    @max_stepped = current if current > @max_stepped
  end

end

class TurtleGraphics::Canvas::ASCII

  def initialize(symbols)
    @symbols = symbols
  end

  def transform(turtle)
    @ratio = (@symbols.size - 1).to_f / turtle.max_stepped
    turtle.canvas.map do |row|
      row.map {|steps| steps_to_ascii(steps)}.join()
    end.join("\n")
  end

  private

  def steps_to_ascii(steps)
    index = (steps * @ratio).ceil
    @symbols[index]
  end

end

class TurtleGraphics::Canvas::HTML

  def initialize(pixels)
    @pixels = pixels
  end

  def transform(turtle)
    "<!DOCTYPE html>
    <html>
    <head>
      <title>Turtle graphics</title>

      <style>
        table {
          border-spacing: 0;
        }

        tr {
          padding: 0;
        }

        td {
          width: #{@pixels}px;
          height: #{@pixels}px;

          background-color: black;
          padding: 0;
        }
      </style>
    </head>
    <body>
      <table>
        #{table_content(turtle)}
      </table>
    </body>
    </html>"
  end

  private

  def table_content(turtle)
    @max_stepped = turtle.max_stepped
    turtle.canvas.map do |row|
      "<tr>\n#{table_cells(row)}\n</tr>"
    end.join("\n")
  end

  def table_cells(row)
    row.map do |steps|
      opacity = format('%.2f', steps.to_f / @max_stepped)
      "<td style=\"opacity: #{opacity}\"></td>"
    end.join("\n")
  end

end

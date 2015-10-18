def grow(snake, direction)
  moved_snake = snake.dup
  moved_snake << new_head(snake, direction)
end

def move(snake, direction)
  moved_snake = grow(snake, direction)
  moved_snake.shift
  moved_snake
end

def new_food(food, snake, dimensions)
  impossible_cells = food + snake
  new_food = random_cell(dimensions)
  new_food = random_cell(dimensions) while impossible_cells.include?(new_food)
  new_food
end

def random_cell(dimensions)
  x = rand(0..(dimensions[:width] - 1))
  y = rand(0..(dimensions[:height] - 1))
  [x, y]
end

def new_head(snake, direction)
  snake[-1].zip(direction).map { |x, y| x + y }
end

def obstacle_ahead?(snake, direction, dimensions)
  new_head = new_head(snake, direction)
  is_in_snake = snake.include?(new_head)
  blocked_horizontally = (new_head[0] == 0 or new_head[0] == dimensions[:width])
  blocked_vertically = (new_head[1] == 0 or new_head[1] == dimensions[:height])
  is_in_snake or blocked_horizontally or blocked_vertically
end

def danger?(snake, direction, dimensions)
  if obstacle_ahead?(snake, direction, dimensions) then
    true
  else
    next_snake = move(snake, direction)
    obstacle_ahead?(next_snake, direction, dimensions)
  end
end

def get_columns(matrix):
    return [list(x) for x in zip(*matrix)]


def grayscale(function):
    def grayscale_pixel(pixel):
        red = int(0.299 * pixel[0])
        green = int(0.587 * pixel[1])
        blue = int(0.114 * pixel[2])
        gray = red + green + blue
        return (gray, gray, gray)

    def decorator(picture):
        new_picture = function(picture)
        return [list(map(grayscale_pixel, row)) for row in new_picture]

    return decorator


@grayscale
def rotate_left(picture):
    columns = get_columns(picture)
    return columns[::-1]


def rotate_right(picture):
    columns = get_columns(picture)
    return list(map(lambda column: column[::-1], columns))


def map_picture(func, picture):
    def map_pixel(pixel):
        return tuple(func(index, color) for index, color in enumerate(pixel))
    return [list(map(map_pixel, row)) for row in picture]


def invert(picture):
    def invert_color(_, color):
        return 255 - color
    return map_picture(invert_color, picture)


def lighten(picture, factor):
    def lighten_color(_, color):
        return int(color + factor * (255 - color))
    return map_picture(lighten_color, picture)


def darken(picture, factor):
    def darken_color(_, color):
        return int(color - factor*color)
    return map_picture(darken_color, picture)


def create_histogram(picture):
    histogram = {
        0: {},
        1: {},
        2: {},
    }

    def add_color(index, color):
        histogram[index][color] = histogram[index].get(color, 0) + 1
    map_picture(add_color, picture)
    return {
        "red": histogram[0],
        "green": histogram[1],
        "blue": histogram[2],
    }

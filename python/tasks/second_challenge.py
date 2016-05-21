def get_columns(matrix):
    return [list(x) for x in zip(*matrix)]


def rotate_left(picture):
    columns = get_columns(picture)
    return columns[::-1]

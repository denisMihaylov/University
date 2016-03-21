from functools import reduce


def convert(argument):
    if isinstance(argument, tuple):
        return Expression(argument)
    elif hasattr(argument, 'evaluate'):
        return argument
    else:
        return Constant(argument)


def to_expression(function):
    def decorator(first, second):
        return Expression((convert(first), function(), convert(second)))
    return decorator


class Constant:
    def __init__(self, value):
        self.symbol = value

    def evaluate(self, **keywords):
        return self.symbol

    def __str__(self):
        return str(self.symbol)

    @property
    def arguments(self):
        return []

    @to_expression
    def __add__():
        return create_operator('+', lambda lhs, rhs: lhs + rhs)

    def __radd__(self, second):
        return Constant.__add__(second, self)

    @to_expression
    def __sub__():
        return create_operator('-', lambda lhs, rhs: lhs - rhs)

    def __rsub__(self, second):
        return Constant.__sub__(second, self)

    @to_expression
    def __mul__():
        return create_operator('*', lambda lhs, rhs: lhs * rhs)

    def __rmul__(self, second):
        return Constant.__mul__(second, self)

    @to_expression
    def __truediv__():
        return create_operator('/', lambda lhs, rhs: lhs / rhs)

    def __rtruediv__(self, second):
        return Constant.__truediv__(second, self)

    __floordiv__ = __truediv__
    __rfloordiv__ = __truediv__


class Operator(Constant):
    def __init__(self, symbol, function):
        self.symbol = symbol
        self.function = function

    def evaluate(self, lhs, rhs):
        return self.function(lhs, rhs)


class Variable(Constant):
    def __init__(self, name):
        self.symbol = name

    def evaluate(self, **keywords):
        return keywords[self.symbol]

    @property
    def arguments(self):
        return [str(self)]


class Expression(Constant):
    def __init__(self, expression_structure):
        self.exp = expression_structure

    def evaluate(self, **keywords):
        def evaluate_internal(argument):
            return convert(argument).evaluate(**keywords)
        lhs, rhs = [evaluate_internal(x) for x in [self.exp[0], self.exp[2]]]
        return self.exp[1].evaluate(lhs, rhs)

    @property
    def arguments(self):
        def concat_arguments(variables, item):
            return variables + convert(item).arguments
        return reduce(concat_arguments, [self.exp[0], self.exp[2]], [])

    @property
    def variable_names(self):
        return tuple(self.arguments)

    def __str__(self):
        def formatter(value):
            return str(convert(value))
        return "({} {} {})".format(*(map(formatter, self.exp)))


def create_variable(name):
    return Variable(name)


def create_expression(expression_structure):
    return Expression(expression_structure)


def create_operator(symbol, function):
    return Operator(symbol, function)


def create_constant(value):
    return Constant(value)

import unittest

import second


class SampleTest(unittest.TestCase):
    def test_five_plus_three(self):
        plus = second.create_operator('+', lambda lhs, rhs: lhs + rhs)
        x = second.create_variable('x')
        y = second.create_variable('y')
        added_expression = second.create_expression((x, plus, y))
        self.assertEqual(added_expression.evaluate(x=5, y=3), 8)

    def test_operators(self):
        y = second.create_variable('y')
        twelve = second.create_constant(12)
        expression = y + twelve
        self.assertEqual(expression.evaluate(y=3), 15)

    def test_constant_evaluation(self):
        self.assertEqual(second.create_variable('x').evaluate(x=42), 42)
        self.assertEqual(second.create_constant(5).evaluate(), 5)

if __name__ == '__main__':
    unittest.main()

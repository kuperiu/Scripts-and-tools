import unittest
import parentheses

class Test_TestIncrementDecrement(unittest.TestCase):
    def test_increment(self):
        self.assertEquals(parentheses.is_valid("{}"), True)
    def test_increment2(self):
        self.assertEquals(parentheses.is_valid("[{}]]]]]]"), False)
    def test_increment3(self):
        self.assertEquals(parentheses.is_valid("{()}[]"), True)
if __name__ == '__main__':
    unittest.main()

    
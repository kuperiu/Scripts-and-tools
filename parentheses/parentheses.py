def is_vaild_pair(left, right):
    if left == '(' and right == ')':
        return True
    if left == '[' and right == ']':
        return True
    if left == '{' and right == '}':
        return True
    return False


def is_valid(parentheses):
    arr = []
    for i in parentheses:
        if i == '(' or i == '[' or i == '{':
            arr.append(i)
        if not arr:
            return False
        if i == ')' or i == ']' or i == '}':
            test = arr.pop()
            res = is_vaild_pair(test, i)
            if not res:
                return False
    return True
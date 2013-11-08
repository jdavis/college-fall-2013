from collections import deque


class Node:
    def __init__(self, value, left=None, right=None):
        self.value = value
        self.left = left
        self.right = right

    def __str__(self, depth=0):
        ret = ""

        # Print right branch
        if self.right is not None:
            ret += self.right.__str__(depth + 1)

        # Print own value
        ret += "\n" + ("    " * depth) + str(self.value)

        # Print left branch
        if self.left is not None:
            ret += self.left.__str__(depth + 1)

        return ret


def reconstruct(t):
    s = [x for x in t[::-1]]

    return reconstruct_rec(s, '')


def reconstruct_rec(s, p):
    root = Node(s.pop())

    if len(s) != 0:
        if root.value >= s[-1]:
            root.left = reconstruct_rec(s, root.value)

    if len(s) != 0:
        if p >= s[-1] or p == '':
            root.right = reconstruct_rec(s, p)

    return root


if __name__ == '__main__':
    t = ['F', 'B', 'A', 'D', 'C', 'E', 'G', 'I', 'H']

    print 'T =', t
    print reconstruct(t)

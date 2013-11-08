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
    q = deque(t)

    return reconstruct_rec(q, '')


def reconstruct_rec(q, p):
    root = Node(q.popleft())

    if len(q) != 0:
        if root.value >= q[0]:
            root.left = reconstruct_rec(q, root.value)
    else:
        return root

    if len(q) != 0:
        if p >= q[0] or p == '':
            root.right = reconstruct_rec(q, p)
    else:
        return root

    return root


if __name__ == '__main__':
    t = ['F', 'B', 'A', 'D', 'C', 'E', 'G', 'I', 'H']

    print 'T =', t
    print reconstruct(t)

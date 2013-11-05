import random


def mid(x, y):
    return (y - x) / 2 + x


def median_of_two(l1, l2):
    s1, s2 = 0, 0
    e1, e2 = len(l1), len(l2)

    mid1 = mid(e1, s1)
    mid2 = mid(e2, s2)

    while mid1 < e1 and mid2 < e2:
        if l1[mid1] < l2[mid2]:
            s1 = mid1
            e2 = mid2
        else:
            e1 = mid1
            s2 = mid2

        mid1 = mid(e1, s1)
        mid2 = mid(e2, s2)

    if mid1 >= e1:
        return l1[mid1]
    elif mid2 >= e2:
        return l2[mid2]

if __name__ == '__main__':
    n = 10
    half = n / 2

    if half % 2 == 0:
        final = half
    else:
        final = half - 1

    l = [i for i in range(n)]

    print "n =", n
    print "half =", half

    l1, l2 = l[:half], l[half:]

    print "L1:", len(l1), l1
    print "L2:", len(l2), l2


    # Shuffle and try 100 times
    for i in range(100):
        random.shuffle(l)

        # Split it up
        l1, l2 = l[:half], l[half:]

        l1.sort()
        l2.sort()

        print "L1:", len(l1), l1
        print "L2:", len(l2), l2

        result1 = median_of_two(l1, l2)
        result2 = median_of_two(l2, l1)

        print "Result1 =", result1
        print "Result2 =", result2

        assert result1 == final
        assert result2 == final

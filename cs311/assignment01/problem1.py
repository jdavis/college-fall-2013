def quicksort(A, s, e):
    if s >= e:
        return

    mid = partition(A, s, e)

    print "Start = ", s
    print "Mid = ", mid
    print "End = ", e

    import pdb; pdb.set_trace()

    quicksort(A, s, mid)
    quicksort(A, mid + 1, e)


def partition(A, s, e):
    l = s + 1
    r = e

    print "In partition:"

    while l <= r:
        while l <= e and A[l] <= A[s]:
            l += 1

        while r >= s and A[r] > A[s]:
            r -= 1

        if l <= r:
            print "Swapping", l, "with", r
            A[l], A[r] = A[r], A[l]

    print "Found position:", r

    A[s], A[r] = A[r], A[s]

    return r

if __name__ == '__main__':
    l = [3, 3]

    print "L = ", l
    quicksort(l, 0, len(l) - 1)
    print "L = ", l

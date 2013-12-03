Assignment 5
============

by Josh Davis
Due: Monday, Dec 2 at 11:59

## Problem 1

## Problem 2

### Part A

An example of "blind write".

Schedule:
    T1          T2
    R(X)
    W(X)
                W(X)
    R(Y)
    W(Y)
    Commit
                Commit

### Part B

Using Strict 2PL locks.

Schedule using Concurrency Control:
    T1          T2
    R(X)
    W(X)
                W(X): Not allowed
    R(Y)
    W(Y)
    Commit
                W(X): Allowed
                Commit

## Problem 3

> Correction: For problem 3a it should be Abort(T2) not Abort(T1).

### Part A

S1: R1(X), W2(X), W1(X), Abort(T2), Commit(T1)

Classification:

- Serializable?
    - Yes. Because it is identical to running T1 -> T2 or T2 -> T1 because of
      the abort of T2.
- Conflict-Serializable?
    - No. Not conflict equivalent to T1 -> T2 or T2 -> T1.
- Recoverable?
    - Yes. T1 overwrites the value of X from T2 if it aborts.
- Avoids-Cascading-Aborts?
    - Yes. T1 overwrites any value T2 wrote therefore the abort doesn't matter.
- Strict?
    - No. W of X occurs in T2 before T1 commits (releases lock on X).

### Part B

S2: R1(X), R2(X), W1(X), W2(X), Commit(T2), Commit(T1)

Classification:

- Serializable?
    - No. RW conflict between X.
- Conflict-Serializable?
    - No. Not conflict equivalent to T1 -> T2 or T2 -> T1.
- Recoverable?
    - Yes. Aborting T2 just undoes the write on X, leaving it at the value T1
      wrote. Aborting T1 doesn't matter for T2 because T2 wrote X last.
- Avoids-Cascading-Aborts?
    - Yes.
- Strict?
    - No. T2 reads X before T1 writes it after reading it.

## Problem 4

### Part A

S1: R1(X), R2(Z), R1(Z), R3(X), R3(Y), W1(X), W3(Y), R2(Y), W2(Z), W2(Y)

- Draw the Serializability Graph

- Serializable?

- If serializable, write down the equivalent serial schedule(s).

### Part B

S1: R1(X), R2(Z), R3(X), R1(Z), R2(Y), R3(Y), W1(X), W2(Z), W3(Y), W2(Y)

- Draw the Serializability Graph

- Serializable?

- If serializable, write down the equivalent serial schedule(s).

## Problem 5

## Problem 6

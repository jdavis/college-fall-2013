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
    - Yes
- Conflict-Serializable?
    - No
- Recoverable?
    - Yes
- Avoids-Cascading-Aborts?
    - Yes
- Strict?
    - No

### Part B

S2: R1(X), R2(X), W1(X), W2(X), Commit(T2), Commit(T1)

Classification:

- Serializable?
    - No
- Conflict-Serializable?
    - No
- Recoverable?
    - No
- Avoids-Cascading-Aborts?
    - Yes
- Strict?
    - Yes

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

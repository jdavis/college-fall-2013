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

> Correction: For problem 3a it should be Abort_{T2} not Abort_{T1}.

### Part A

S1: R_{T1}(X), W_{T2}(X), W_{T1}(X), Abort_{T2}, Commit_{T1}

Classification:

- Serializable?
- Conflict-Serializable?
- Recoverable?
- Avoids-Cascading-Aborts?
- Strict?

### Part B

S2: R_{T1}(X), R_{T2}(X), W_{T1}(X), W_{T2}(X), Commit_{T2}, Commit_{T1}

Classification:

- Serializable?
- Conflict-Serializable?
- Recoverable?
- Avoids-Cascading-Aborts?
- Strict?

## Problem 4

## Problem 5

## Problem 6

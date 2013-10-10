COM S 461: Homework 2
=====================

Josh Davis

## Question 1

### Which of the following dependencies can you infer do not hold over schema S?

- A -> B: We can't tell if it holds.
- BC -> A: We know this does not hold.
- B -> C: We can't tell if it holds.

### Can you identify any dependencies that hold over S?

- No. In order to say that a dependency holds over a given schema, we would
  need to ensure it holds for all instances of the relation.

## Question 2

### Is D1 = {ABC, ACDE, ADG} a lossless join decomposition? Why?

- TODO

### Is D1 a dependency-preserving decomposition? Why?

No, it does not preserve the dependency of `E -> G`. We know this because if we
calculate all the FD's for the given decomposition, not all dependencies still
exist. Therefore it is not a dependency-preserving decomposition.

### What is the strongest normal form of ABC and why?

The strongest normal form of `ABC` is BCNF (which encompasses 1NF, 2NF, and
3NF). This is because for ABC, we have three FDs: `AB -> C`, `BC -> A`, `AC ->
B`. For all of those dependencies, we can see that each is a superkey. Thus it
follows the definition of BCNF.

## Question 3

### Is D2 a dependency-preserving decomposition? Why?

No, the dependency of `A -> DE` is not preserved. No where in the decomposed
relations given does A determine DE.

### Is D2 a lossless-join decomposition? Why?

TODO

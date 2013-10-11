COM S 461: Homework 2 =====================

Josh Davis

## Question 1

### Which of the following dependencies can you infer do not hold over schema S?

- `A -> B`: We can't tell.
- `BC -> A`: We know this does not hold.
- `B -> C`: We can't tell.

### Can you identify any dependencies that hold over S?

- No. In order to say that a dependency holds over a given schema, we would need
  to ensure it holds for all instances of the relation.

## Question 2

The functional dependencies are as follows: `{AB -> C, AC -> B, AD -> E, B -> D,
BC -> A, E -> G}`.

### Is `D1 = {ABC, ACDE, ADG}` a lossless join decomposition? Why?

- First let's look at `ABC. and `ACDE`. The common attributes are `AC`. This
  gives us `ABC intersection ACDE = AC` for the left side of the dependency. And
  `AC -> B` and by using Armstrong's Axioms, `AC -> ABC`, which is the
  intersection.

  Now we look at `ABCDE` and `ADG`, the intersection of the two decompositions
  is `AD`. This gives us `AD -> E` and since `E -> G`, then `AD -> G`. Using
  Armstrong's Union Axiom, `AD -> G` and then trivially, `AD -> ADG`. Thus it is
  a lossless join decomposition!

  Since we found a lossless arrangement, it must be lossless.

### Is `D1` a dependency-preserving decomposition? Why?

No, it does not preserve the dependency of `E -> G`. We know this because if we
calculate all the FD's for the given decomposition, not all dependencies still
exist. Therefore it is not a dependency-preserving decomposition.

### What is the strongest normal form of `ABC` and why?

The strongest normal form of `ABC` is BCNF (which encompasses 1NF, 2NF, and
3NF). This is because for ABC, we have three FDs: `AB -> C`, `BC -> A`, `AC ->
B`. For all of those dependencies, we can see that each is a superkey. Thus it
follows the definition of BCNF.

## Question 3

### Is `D2` a dependency-preserving decomposition? Why?

No, the dependency of `A -> DE` is not preserved. No where in the decomposed
relations given does A determine DE.

### Is `D2` a lossless-join decomposition? Why?

- Let's use `R2` and `R5`. This gives us `DE intersection DIJ = D`. Then from
  the FDs, we know that `D -> IJ`, thus `D -> DIJ` so `R2` and `R5` can be
  joined.

  Next, we take `DIJE` and `R1`. This gives us `DIJE intersection ABCD = D`. `D`
  only allows us to get `IJ`, which we already have. Thus this combination isn't
  lossless.

- Now let's try another set of starting relations, `R1` and `R2`. This gives us
  `ABCD intersection DE = D`. Once again, we get stuck with `D` only having one
  FD.

- Let's try another set, `R3` and `R4`. This gives us `BF intersection FGH = F`.
  Since `F -> GH`, we can do `F -> FGH`. Now we need to check another relation.

  Taking FGH, we are stuck because there are no other relations where the
  intersection isn't the empty set.

- It looks like this `D2` isn't lossless because we have no way of joining all
  the relations up to the full attribute set, `ABCDEFGHIJ`.

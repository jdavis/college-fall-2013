CS342 Cheat Sheet
=================
Josh Davis

Means of:
    - Computation: to actually compute (primitive expressions, etc). Defined by
      basic data types.
        - int, double, float: 10 + 8 + 2 or (+ 10 8 2)
    - Combination: putting together primitives (computations)
        - classes, defines, structs
    - Abstraction: concept or idea not associated with specific implementation
        - Method call, procedure call

eq? vs equal?:
    - eq? is analogous to reference equality in Java, while equal? is analogous
      to the equals method of class Object.

Currying:
    - TODO

Syntactic Sugar:
    - Scheme: (define (f) 2) vs (define f (lambda () 2))
    - C: a[i] vs *(a + i) where a is an array

Define Syntax:

    (define-syntax-rule (while condition body)
      ((lambda (f) (f f))
       (lambda (while-iter)
          (cond
            (condition body (while-iter while-iter))
            (else 0)))))


Grammer, BNF:
    - Count kinds of data

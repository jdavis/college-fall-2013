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

Define Datatype:
    (define-datatype binary-tree binary-tree?
      (leaf-node     (datum number?))
      (interior-node (key   symbol?)
                     (left  binary-tree?)
                     (right binary-tree?)))

    (define leaf-sum
      (lambda (tree)
        (cases binary-tree tree
          (leaf-node (datum)
            datum)
          (interior-node (key left right)
            (+ (leaf-sum left) (leaf-sum right)))
          (else
            (error "leaf-sum: Invalid tree" tree)))))

Data Abstraction:
    - Interface: tells us the data of the type, what operations, and what
      properties the data has.
    - Representation independence: when the client manipulates values of the
      data type only through procedures in the interface.

Inferfaces for Recursive Data Types:
    - State different kinds of data for a given data type
    - Constructors, predicates, extractors based on BNF
        1. One constructor for each kind of data in the data type.
        2. One predicate for each kind of data in the data type.
        3. One extractor for each piece of data passed to a constructor of the
           data type.

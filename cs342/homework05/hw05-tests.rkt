#lang racket
(#%provide (all-defined))
(#%require "test-infrastructure.rkt")
(#%require rackunit)

(#%require "hw05-answer-sheet.rkt")

;this function will run all the tests.
(define (test-all)
  (test p1)
  (test p2-a)
  (test p2-b)
  (test p3)
)

;======================================01=======================================
(define p1
  (test-suite
   "functional sets"
   (test-case
    "singleton-set test"
    
    (342-check-true ((singleton-set 1) 1) "set containing 1, given 1")
    (342-check-false ((singleton-set 1) 2) "set containing 1, given 2")
    )
   
   (test-case
    "union test"
    
    ;we will actually give names to our test data
    (define s1 (singleton-set 1))
    (define s2 (singleton-set 2))
    (define s1-2 (union s1 s2))
    
    (342-check-true (s1-2 1) "set containing 1 2, given 1")
    (342-check-true (s1-2 2) "set containing 1 2, given 2")
    (342-check-false (s1-2 3) "set containing 1 2, given 3")
    )
   
   (test-case
    "intersection test"
    
    ;we will actually give names to our test data
    (define s1 (singleton-set 1))
    (define s2 (singleton-set 2))
    (define s3 (singleton-set 3))
    (define s4 (singleton-set 4))
    
    (define s1-3 (union (union s1 s2) s3))
    (define s2-4 (union (union s2 s3) s4))
    
    ;this set will effectively contain elements 2,3
    (define s2-3 (intersection s1-3 s2-4))
    
    (342-check-true (s2-3 2) "set containing 2 3, given 2")
    (342-check-true (s2-3 3) "set containing 2 3, given 3")
    (342-check-false (s2-3 1) "set containing 2 3, given 1")
    (342-check-false (s2-3 4) "set containing 2 3, given 4")
    
    (342-check-false (s2-3 42) "set containing 2 3, given 42")
    )
   
   (test-case
    "diff test"
    
    ;we will actually give names to our test data
    (define s1 (singleton-set 1))
    (define s2 (singleton-set 2))
    (define s3 (singleton-set 3))
    (define s4 (singleton-set 4))
    
    (define s1-3 (union (union s1 s2) s3))
    (define s2-4 (union (union s2 s3) s4))
    
    ;this set will effectively contain only: 1
    (define sd-1 (diff s1-3 s2-4))
    
    (342-check-true (sd-1 1) "set containing 1, given 1")
    (342-check-false (sd-1 2) "set containing 1, given 2")
    (342-check-false (sd-1 3) "set containing 1, given 3")
    (342-check-false (sd-1 4) "set containing 1, given 4")
    
    (342-check-false (sd-1 42) "set containing 1, given 42")
    )
   
   (test-case
    "filter test"
    
    ;we will actually give names to our test data
    (define s1 (singleton-set 1))
    (define s2 (singleton-set 2))
    (define s3 (singleton-set 3))
    (define s4 (singleton-set 4))
    (define s7 (singleton-set 7))
    
    (define s1-7 (union (union (union (union s1 s2) s3) s4) s7))
    (define primes-set (filter prime? s1-7))
    
    (342-check-true (primes-set 2) "set containing primes, given 2")
    (342-check-true (primes-set 3) "set containing primes, given 3")
    (342-check-true (primes-set 7) "set containing primes, given 7")
    (342-check-false (primes-set 1) "set containing primes, given 1")
    (342-check-false (primes-set 4) "set containing primes, given 1")
    (342-check-false (primes-set 8) "set containing primes, given 8")
    )
   
   (test-case
    "exists? test"
    
    ;we will actually give names to our test data
    (define s4 (singleton-set 4))
    (define s6 (singleton-set 6))
    (define s7 (singleton-set 7))
    
    (define test-set (union (union s4 s6) s7))
    
    (342-check-true (exists? prime? test-set) "exists? a prime")
    
    (342-check-false (exists? string? test-set) "exists? a string")
    )
   
   (test-case
    "all? test"
    
    ;we will actually give names to our test data
    (define s3 (singleton-set 3))
    (define s7 (singleton-set 7))
    (define s13 (singleton-set 13))
    (define s4 (singleton-set 4))
    
    (define primes (union (union s3 s7) s13))
    (define mixed (union primes s4))
    
    (342-check-true (all? prime? primes) "all? primes in a primes only set")
    (342-check-false (all? prime? mixed) "all? primes in a mixed set")
    )
   
   (test-case
    "map-set test"
    
    ;we will actually give names to our test data
    (define s3 (singleton-set 3))
    (define s7 (singleton-set 7))
    (define s13 (singleton-set 13))
    
    (define primes (union (union s3 s7) s13))
    (define (add-forty-two x) (+ x 42))
    
    (define mapped-set (map-set add-forty-two primes))
    
    (342-check-true (mapped-set 45) "42+3 should be in the set")
    (342-check-true (mapped-set 49) "42+7 should be in the set")
    (342-check-true (mapped-set 55) "42+13 should be in the set")
    
    (342-check-false (mapped-set 3) "3, original value should not be in the new set")
    (342-check-false (mapped-set 7) "7, original value should not be in the new set")
    (342-check-false (mapped-set 13) "13, original value should not be in the new set")
    
    (342-check-false (mapped-set 42) "42, some random value should not be in the set")
    
    )
   
   )
  )
;======================================02=======================================
(define p2-a
  (test-suite
    "steps-a"
    
    (342-check-true
       (up-step? (up-step 3))
       "test 1"
       )
    
    (342-check-exn
       (up-step "not-a-number") 
       "Invalid arguments in: up-step --- expected: number? --- received: not-a-number")
    
    (342-check-true
       (down-step? (down-step 3))
       "test 2")
    
    (342-check-exn
       (down-step "not-a-number") 
       "Invalid arguments in: down-step --- expected: number? --- received: not-a-number")
    
    (342-check-true
       (left-step? (left-step 3))
       "test 3")
    
    (342-check-exn
       (left-step "not-a-number") 
       "Invalid arguments in: left-step --- expected: number? --- received: not-a-number")
    
    (342-check-true
       (right-step? (right-step 3))
       "test 4")
  
    (342-check-true
       (seq-step? (seq-step (right-step 3) (up-step 4)))
       "test 5")
    
    (342-check-exn
       (seq-step "not-a-step" (up-step 4)) 
       "Invalid arguments in: seq-step --- expected: step? --- received: not-a-step")
  
    (342-check-true
       (step? (up-step 3))
       "test 6")
    
    (342-check-true
       (step? (down-step 3))
       "test 7")
    
    (342-check-true
       (step? (left-step 3))
       "test 8")
    
    (342-check-true
       (step? (right-step 3))
       "test 9")
    
    (342-check-true
       (step? (seq-step (right-step 3) (up-step 4)))
       "test 10")
    
    (342-check-equal?
        (single-step->n (up-step 3))
        3
        "test 11"
     )
    
    (342-check-equal?
        (single-step->n (down-step 3))
        3
        "test 12"
     )
    
    (342-check-equal?
        (single-step->n (left-step 3))
        3
        "test 13"
     )
    
    (342-check-equal?
        (single-step->n (right-step 3))
        3
        "test 14"
     )
    
    (342-check-exn
       (single-step->n "not-a-single-step")
       "Invalid arguments in: single-step->n --- expected: single-step? --- received: not-a-single-step")
     
    (342-check-equal?
        (single-step->n (seq-step->st-1 (seq-step (left-step 3) (right-step 4))))
        3
        "test 15"
     )
    
    (342-check-equal?
        (single-step->n (seq-step->st-2 (seq-step (left-step 3) (right-step 4))))
        4
        "test 16"
     )
  )
)

;;======
(define p2-b
  (test-suite
    "steps-b"
    (342-check-equal?
        (move '(0 0) (up-step 3))
        '(0 3)
        "move up"
     )
    
    (342-check-equal?
        (move '(0 0) (down-step 3))
        '(0 -3)
        "move down"
     )
    
    (342-check-equal?
        (move '(0 0) (left-step 3))
        '(-3 0)
        "move left"
     )
    
    (342-check-equal?
        (move '(0 0) (right-step 3))
        '(3 0)
        "move right"
     )
    
    (342-check-equal?
        (move '(0 0) (seq-step (up-step 3)(right-step 3)))
        '(3 3)
        "move in sequence: up, right"
     )
    
    (342-check-equal?
        (move '(0 0) (seq-step (up-step 3)(down-step 3)))
        '(0 0)
        "move in sequence: up, down; they should cancel each other"
     )
    
    (342-check-equal?
        (move '(0 0) (seq-step (up-step 10) (seq-step (left-step 7) (right-step 4))))
        '(-3 10)
        "move in sequence of sequence: up, left, right; they should cancel each other"
     )
    
  )
)

;;=====================================================03=================================
(define p3
  (test-suite
    "binary search tree"
    
    (342-check-true
       (empty-tree? (empty-tree))
       "checks to see if an empty-tree is an empty tree"
     )
    
    (342-check-false
       (empty-tree? (bstree 42))
       "is a bstree an empty-tree? no."
     )
    
    (342-check-false
       (empty-tree? "empty")
       "is a string an empty-tree? no."
     )
    
    (342-check-equal? 
        (tree->root (bstree 42))
        42
        "verifying proper construction"
     )
    
    (342-check-equal? 
        (tree->left (bstree 42))
        (empty-tree)
        "the left tree of a leaf bstree should be the empty-tree"
     )
    
    (342-check-equal? 
        (tree->right (bstree 42))
        (empty-tree)
        "the right tree of a leaf bstree should be the empty-tree"
     )
    
    (342-check-equal?
       (insert-tree 8 (empty-tree))
       (bstree 8)
       "inserting a value into an empty tree"
     )
    
    (342-check-equal?
       (tree->left (insert-tree 3 (bstree 8)))
       (bstree 3)
       "inserting a value into the left subtree"
     )
    
    (342-check-equal?
       (tree->right (insert-tree 10 (bstree 8)))
       (bstree 10)
       "inserting a value into the right subtree"
     )
    
    (342-check-equal?
       (tree->left (tree->left (insert-tree 1 (insert-tree 3 (bstree 8)))))
       (bstree 1)
       "inserting a value into the left subtree at two level depth"
     )
    
    (342-check-equal?
       (tree->right (tree->right (insert-tree 14 (insert-tree 10 (bstree 8)))))
       (bstree 14)
       "inserting a value into the right subtree at two level depth"
     )
    
    (342-check-equal?
       (tree->list (insert-tree 3 (insert-tree 10 (bstree 8))))
       '(3 8 10)
       "getting the sorted list"
     )
    
    ;;you should write more tests on your own.
    
  )
)
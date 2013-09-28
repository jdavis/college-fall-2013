#lang racket
(#%provide (all-defined))

#|
IMPORTANT:
Overall, you are allowed to change this file in any way that does *not* affect the
compilation of the accompanying test file. Changes that are almost certain to break
the above restriction are:
  - changing the names of any definitions that are explicitely used in the tests
    (e.g. function names, relevant constants)

If there are any specific instructions for a problem, please read them carefully. Otherwise,
follow these general rules:

   - replace the 'UNIMPLEMENTED symbol with your solution
   - you are NOT allowed to change the number of arguments of the pre-defined functions,
     because changing the number of arguments automatically changes the semantics of the
     function. Changing the name of the arguments is permitted since that change only
     affects the readability of the function, not the semantics.
   - you may write any number of helper functions

When done, make sure that the accompanying test file compiles. You will lose up to 25%
of the total points for the entire homework depending on the number of errors.
If you cannot come up with a correct solution then please make the answer-sheet
compiles. If you have partial solutions that do not compile please comment them out,
if this is the case, the default definitions will have to be present since the tests
will be expecting functions with the names defined here.

Submission guidelines:
   - please rename the file to hw05-yourlastname.rkt prior to submission
   - don't forget to also rename hw05-yourlastname-tests.rkt
   - upload both the solution and the tests
|#
;======================================01=======================================
;singleton-set should return a function that takes a number as an argument and
;tells whether or not that number is in the set
(define (singleton-set x)
  (lambda (e)
    (eq? e x)))


;the set of all elements that are in either 's1' or 's2'
(define (union s1 s2)
  (lambda (e) (or (s1 e) (s2 e))))

;the set of all elements that are in both  in 's1' and 's2'
(define (intersection s1 s2)
  (lambda (e) (and (s1 e) (s2 e))))

;the set of all elements that are in 's1', but that are not in 's2'
(define (diff s1 s2)
  (lambda (e) (and (s1 e) (not (s2 e)))))

;returns the subset of s, for which the predicate 'predicate' is true.
(define (filter predicate s)
  (lambda (e) (and (predicate e) (s e))))

;we assume that the sets can contain only numbers between 0 and bound
(define bound 100)

;returns whether or not the set contains at least an element for which
;the predicate is true.
(define (exists? predicate s)
  (ormap
    (lambda (e)
      (and (predicate e)
           (s e)))
    (range bound)))

;returns whether or not the predicate is true for all the elements
;of the set
(define (all? predicate s)
  (andmap
    (lambda (e)
      (or
        (not (s e))
        (and
          (predicate e)
          (s e))))
    (range bound)))

;returns a new set where "op" has been applied to all elements
(define (map-set op s)
  (lambda (e)
    (ormap
      (lambda (f)
        (and (s f) (eq? (op f) e)))
      (range bound))))

;just a sample predicate
(define (prime? n)
  (define (non-divisible? n)
    (lambda (i)
      (not (= (modulo n i) 0))))
  (if (or (equal? n 1) (equal? n 0))
    #f
    (let ([range-of-prime-divisors (cddr (range (+ (integer-sqrt n) 1)))])
      (andmap (non-divisible? n) range-of-prime-divisors))))
;===============================================================================
;======================================02=======================================
;===============================================================================

;you should use this function to create the error messages.
(define (invalid-args-msg fun-name-as-string
                          expected-value-type-as-predicate-string
                          received)
  (string-append "Invalid arguments in: " fun-name-as-string " --- "
                 "expected: " expected-value-type-as-predicate-string " --- "
                 "received: " (~a received)
                 )
)


(define (up-step n)
  'UNIMPLEMENTED
)

(define (down-step n)
  'UNIMPLEMENTED
)

(define (left-step n)
  'UNIMPLEMENTED
)

(define (right-step n)
  'UNIMPLEMENTED
)

(define (seq-step st-1 st-2)
  'UNIMPLEMENTED
)

;;====
(define (up-step? st)
  'UNIMPLEMENTED
)

(define (down-step? st)
  'UNIMPLEMENTED
)

(define (left-step? st)
  'UNIMPLEMENTED
)

(define (right-step? st)
  'UNIMPLEMENTED
)

(define (seq-step? st)
  'UNIMPLEMENTED
)

;This is a predicate that tells you whether or not something is a step,
;it should return true when given either up, down, left, right or seq steps.
(define (step? st)
  'UNIMPLEMENTED
)


;;to avoid needless duplication we will only implement one extractor to handle all the
;;simple steps, rather than 4. So this should take: up, down, left and right steps.
(define (single-step->n st)
  'UNIMPLMENTED
)

;;two extractors, one for each piece of data representing a sequential step
(define (seq-step->st-1 st)
  'UNIMPLEMENTED
)


(define (seq-step->st-2 st)
  'UNIMPLEMENTED
)
;;===================================
(define (move start-p step)
  'UNIMPLEMENTED
)

;======================================03=======================================

(define (empty-tree)
  'UNIMPLEMENTED
)

(define (empty-tree? tree)
  'UNIMPLEMENTED
)

(define (bstree root)
  'UNIMPLEMENTED
)

(define (tree->root tree)
  'UNIMPLEMENTED
)

(define (tree->left tree)
  'UNIMPLEMENTED
)

(define (tree->right tree)
  'UNIMPLEMENTED
)

(define (insert-tree n t)
  'UNIMPLEMENTED
)

(define (tree->list tree)
  'UNIMPLEMENTED
)

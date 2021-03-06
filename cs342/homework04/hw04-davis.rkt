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
   - please rename the file to hw04-yourlastname.rkt prior to submission
   - only this file needs to be uploaded to the blackboard system
|#

;======================================01=======================================
(define (foldl-342 op zero-el lst)
  (define (rdr lst)
    (cond
      ((null? (cdr lst)) '())
      (else
        (cons
          (car lst)
          (rdr (cdr lst))))))
   (cond
     ((null? lst) zero-el)
     (else
       (op
         (last lst)
         (foldl-342
           op
           zero-el
           (rdr lst))))))

;---
(define (foldr-342 op zero-el lst)
   (cond
     ((null? lst) zero-el)
     (else
       (op
         (car lst)
         (foldr-342
           op
           zero-el
           (cdr lst))))))

;======================================02=======================================
(define (andmap-342 test-op lst)
  (cond
    ((null? lst) #t)
    (else
      (and (test-op
             (car lst))
           (andmap-342
             test-op
             (cdr lst))))))

;======================================03=======================================
(define (map-reduce m-op r-op zero-el lst)
  (define (mapp op lst)
    (cond
      ((null? lst) lst)
      (else
        (cons
          (op (car lst))
          (mapp
            op
            (cdr lst))))))
  (foldl-342
    r-op
    zero-el
    (mapp
      m-op
      lst)))

;======================================04=======================================
(define (matrix-to-vector op mat)
  (apply map (cons op mat)))

;======================================05=======================================
(define (change-at-index i new-el lst)
  (define (change-iter iter lst)
    (cond
      ((null? lst) lst)
      ((= iter i) (cons
                    new-el
                    (cdr lst)))
      (else
        (cons
          (car lst)
          (change-iter
            (+ iter 1)
            (cdr lst))))))
  (change-iter 0 lst))

;======================================06=======================================
(define-syntax-rule (for {var in value-range} return result)
  (map (lambda (var) result) value-range))
;======================================07=======================================
(define-syntax-rule (seq expr1 expr2)
  ((lambda () expr1 expr2)))

;====
(define-syntax-rule (while condition body)
  ((lambda (f) (f f))
   (lambda (while-iter)
      (cond
        (condition body (while-iter while-iter))
        (else 0)))))

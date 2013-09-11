#lang racket
(#%provide (all-defined))

#|
If there are any specific instructions for a problem, please read them carefully. Otherwise,
follow these general rules:
   - replace the 'UNIMPLEMENTED symbol with your solution
   - you are NOT allowed to change the names of any definition
   - you are NOT allowed to change the number of arguments of the pre-defined functions,
     but you can change the names of the arguments if you deem it necessary.
   - make sure that you submit an asnwer sheet that compiles! If you cannot write
     a correct solution at least make it compile, if you cannot make it compile then
     comment it out. In the latter case, make sure that the default definitions
     for the problem are still present. Otherwise you may be penalized up to 25%
     of the total points for the homework.
   - you may use any number of helper functions you deem necessary.

When done, make sure that you do not get any errors when you hit the "Run" button. You will
lose up to 25% of the total points for the entire homework depending on the number of errors.
If you cannot come up with a correct solution then please make the answer-sheet
compile correctly and comment any partial solution you might have; if this is the case,
the default definitions will have to be present!
|#
;======================================01=======================================
(define (list-of-even-numbers? lst)
  (cond
    ((null? lst) #t)
    ((and
       (number? (car lst))
       (even? (car lst))) (list-of-even-numbers? (cdr lst)))
    (else #f)))

;======================================02=======================================
;;for n > 0
;Sn = 1/1 + 1/4 + 1/9 + 1/16 + ...
(define (series-a n)
  'UNIMPLEMETED
)

;====
;;for n >= 0
;Sn = 1 - 1/2 + 1/6 - 1/24 + ...
(define (series-b n)
  'UNIMPLEMETED
)

;======================================03=======================================
(define (carpet n)
  'UNIMPLEMENTED
)

;======================================04=======================================
(define (sort-ascend loi)
 'UNIMPLEMENTED
)

;======================================05=======================================
(define (balanced? in)
  'UNIMPLEMENTED
)

;======================================06=======================================
(define (list-of-all? predicate lst)
  'UNIMPLEMENTED
)

;======================================07=======================================
(define (create-mapping keys vals)
  'UNIMPLEMENTED
)

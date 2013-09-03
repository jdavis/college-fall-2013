#lang racket
(#%provide (all-defined))
(#%require "test-infrastructure.rkt")
(#%require rackunit)

;if you rename the answer sheet to conform with the submission requirements
;you will have to change this line so that the tests can find the
(#%require "hw02-davis.rkt")

;to run the tests, evaluate:
;>(test all)

(define all
  (test-suite
    "These are all the tests for homework 2"

    (342-check-equal? (p1-1) 54 "Problem 1, ((3 + 3) * 9)")
    (342-check-equal? (p1-2) 3 "Problem 1, ((6 * 9) / ((4 + 2) + (4 * 3)))")
    (342-check-equal? (p1-3) 42 "Problem 1, (2* ((20 - (91 / 7)) * (45 - 42)))")

    (342-check-equal? (p4) 7 "p2, sum of the two largest x,y,z")
    (342-check-equal? (p5) 5 "p2, sum of the two smallest x,y,z")
    (342-check-equal? (p6) #f "p2, x, y are not equal")

    (342-check-equal? (p12-1 example) '(d a b c) "12-1")
    (342-check-equal? (p12-2 example) '(a b d a b) "12-2, ")
    (342-check-equal? (p12-3 example) '(b c d a) "12-3")

    ;;problem 14
    (342-check-equal? (create-error-msg 'forty-two 42)
                      "This is a custom error message we will be using next. Symbol 'forty-two was not paired with value 42")

    ;;problem 15
    (342-check-equal? (check-correctness '(answer-to-everything 42)) #t)
    (342-check-equal? (check-correctness '(symbol-other-than-the-previous-one 42)) #f)
    (342-check-equal? (check-correctness '(test 30)) #f)

    ;this will check to see if an exception with the below written error-message
    ;is raised.
    (342-check-exn
       (check-correctness '(answer-to-everything 10))
       "This is a custom error message we will be using next. Symbol 'answer-to-everything was not paired with value 42")


    ;;problem 18

    (342-check-equal?
       (pascal 1)
       '((1))
     )

    (342-check-equal?
       (pascal 2)
       '((1) (1 1))
     )

    (342-check-equal?
       (pascal 3)
       '((1) (1 1) (1 2 1))
     )

    (342-check-equal?
       (pascal 4)
       '((1) (1 1) (1 2 1) (1 3 3 1))
     )

    (342-check-equal?
       (pascal 5)
       '((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1))
     )

    (342-check-equal?
       (pascal 6)
       '((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1))
     )

    (342-check-equal?
       (pascal 7)
       '((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1) (1 6 15 20 15 6 1))
     )
    )
)

(test all)

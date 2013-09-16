#lang racket
(#%provide (all-defined))
(#%require "test-infrastructure.rkt")
(#%require rackunit)

(#%require "hw04-davis.rkt")

;as you can probably figure out, this function will run
;all the tests.
(define (test-all)
  (test p1-a)
  (test p1-b)
  (test p2)
  (test p3)
  (test p4)
  (test p5)
  (test p6)
  (test p7-a)
  (test p7-b)
)

;======================================01=======================================
(define p1-a
  (test-suite
    "fold left"
    (342-check-equal?
       (foldl-342 + 0 '(1 2 3 4))
       10
       "foldl with addition"
     )

    (342-check-equal?
       (foldl-342 + 0 '())
       0
       "foldl over an empty list"
     )

    (342-check-equal?
       (foldl-342 + 42 '())
       42
       "foldl over an empty list with zero element = 42"
     )

    (342-check-equal?
       (foldl-342 string-append "" (list "!!!" "42"  "is " "answer " "the " ))
       "the answer is 42!!!"
       "foldl over strings"
     )

    (342-check-equal?
       (foldl-342 - 0 '(1 2 3 4))
        2
       "foldl with subtraction in order list"
     )

    (342-check-equal?
       (foldl-342 - 0 '(4 3 2 1))
        -2
       "foldl with subtraction reverse order list"
     )
  )
)
;---

(define p1-b
  (test-suite
    "fold right"
    (342-check-equal?
       (foldr-342 + 0 '(1 2 3 4))
       10
       "foldr with addition"
     )

    (342-check-equal?
       (foldr-342 + 0 '())
       0
       "foldr over an empty list"
     )

    (342-check-equal?
       (foldr-342 + 42 '())
       42
       "foldr over an empty list with zero element = 42"
     )

    (342-check-equal?
       (foldr-342 string-append "" (list "the " "answer " "is " "42" "!!!"))
       "the answer is 42!!!"
       "foldr over strings"
     )

    (342-check-equal?
       (foldr-342 - 0 '(1 2 3 4))
        -2
       "foldr with subtraction in order list"
     )

    (342-check-equal?
       (foldr-342 - 0 '(4 3 2 1))
        2
       "foldr with subtraction reverse order list"
     )
  )
)
;======================================02=======================================
(define p2
  (test-suite
    "andmap"
    (342-check-equal?
      (andmap-342 odd? '(1 3 5))
      #t
      "list containing only odd numbers"
   )

    (342-check-equal?
      (andmap-342 odd? '(1 3 6))
      #f
      "list of odds containing one even number"
    )

    (342-check-equal?
      (andmap-342 odd? '())
      #t
      "empty list"
    )

  )
)

;======================================03=======================================
(define add-forty-two
  (lambda (x) (+ x 42)))

(define p3
  (test-suite
    "map reduce"

    (342-check-equal?
      (map-reduce add-forty-two + 0 '(0 1 2))
      129
      "we add 42 to each number then add them together"
    )

    (342-check-equal?
      (map-reduce add-forty-two + 0 '())
      0
      "map reduce over an empty list with zero element 0"
    )

    (342-check-equal?
      (map-reduce add-forty-two + 42 '())
      42
      "map reduce over an empty list with zero element = 42"
    )
  )
)

;======================================04=======================================
(define n-matrix
   '((1 2 3 4)
     (5 6 7 8)
     (9 0 1 2))
)

(define str-matrix
  '(("a" "c" "e")
    ("b" "d" "f"))
)

(define p4
  (test-suite
    "matrix to vector"

    (342-check-equal?
      (matrix-to-vector + n-matrix)
      '(15 8 11 14)
    )

    (342-check-equal?
      (matrix-to-vector string-append str-matrix)
      '("ab" "cd" "ef")
    )
  )
)
;======================================05=======================================
(define p5
  (test-suite
    "change-at-index"

    (342-check-equal?
      (change-at-index 0 42 '(please do not replace me))
      '(42 do not replace me)
    )

    (342-check-equal?
      (change-at-index 1 42 '(please do not replace me))
     '(please 42 not replace me)
    )

    (342-check-equal?
      (change-at-index 2 42 '(please do not replace me))
      '(please do 42 replace me)
    )

    (342-check-equal?
      (change-at-index 3 42 '(please do not replace me))
      '(please do not 42 me)
    )

    (342-check-equal?
      (change-at-index 4 42 '(please do not replace me))
      '(please do not replace 42)
    )
  )
)
;======================================06=======================================
(define p6
  (test-suite
    "for"

    (342-check-equal?
       (for {i in '()} return (+ i 42))
       '()
       "empty list"
     )

    (342-check-equal?
       (for {a in '(0 1 2 3)} return (+ a 42))
       '(42 43 44 45)
       "add 42 to the list"

     )

    (342-check-equal?
       (for {to-ignore in '(0 1 2 3)} return 42)
       '(42 42 42 42)
       "ignore looping variable"
     )
  )
)
;======================================07=======================================
(define test-var-1 42)
(define p7-a
  (test-suite
    "seq"

    (342-check-true
       (and
          (equal? (seq (set! test-var-1 'not-42) 342) 342)
          (equal? test-var-1 'not-42))
       "measure side effect and return value"
     )

    (342-check-equal?
       (seq 'to-be-ignored (* 5 6))
       30
       "ignoring first expression"
     )
  )
)
;;======================
(define test-counter-1 0)

(define p7-b
  (test-suite
    "while"

    (342-check-true
       (and
         (equal? 0 (while (< test-counter-1 100)
                          (set! test-counter-1 (+ test-counter-1 1))
                   )
         )
         (equal? test-counter-1 100)
       )
       "loop and increment counter, while always returns 0"
     )

    (test-case
       "nested whiles"
       (let ([i 0] [j 0] [v #()])
         (while (< i 3)
           (begin
              ;;this condition is here to exemplify that it should be arbitrarily complex
              (while (and (< j 5) (= 1 1))
                  (begin
                    (set! j (+ j 1))
                    (set! v (vector-append v #(*)))
                  )
              )
              (set! v (vector-append v #(/n)))
              (set! j 0)
              (set! i (+ i 1))
           )
         )
         (342-check-equal? v #(* * * * * /n * * * * * /n * * * * * /n))
       )
     )
  )
)

(test p1-a)
(test p1-b)

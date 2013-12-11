#lang racket

(#%require "hw09-tests.rkt")

; Run all the tests
(test-all)

(#%require "hw09-env-values.rkt")
(initialize-store!)
(displayln (~a "Blank Store: " the-store))
(define env (extend-env-wrapper 'x 1 (empty-env) #f))
(displayln (~a "Store 1: " the-store))
(newref 2)
(displayln (~a "Store 2: " the-store))
(newref 3)
(displayln (~a "Store 3: " the-store))
(displayln (~a "The store before Mark: " the-store))
(mark-all)
(displayln (~a "The store after Mark: " the-store))
(clear-reachable env)
(displayln (~a "The store after Clear-reachable " the-store))

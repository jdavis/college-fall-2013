#lang racket

(#%require "hw09-tests.rkt")

; Run all the tests
(test-all)

(#%require "hw09-env-values.rkt")
(initialize-store!)

(define env (empty-env))

(displayln (~a "Blank Store: " (map list the-store the-mark)))

(set! env (extend-env-wrapper 'x 0 env #f))
(displayln (~a "Store 1: " (map list the-store the-mark)))

(set! env (extend-env-wrapper 'y 2 env #f))
(displayln (~a "Store 2: " (map list the-store the-mark)))

(newref 3)
(displayln (~a "Store 3: " (map list the-store the-mark)))

(displayln (~a "The store before Mark: " (map list the-store the-mark)))
(mark-all)
(displayln (~a "The store after Mark: " (map list the-store the-mark)))

(clear-reachable env)
(displayln (~a "The store after Clear-reachable " (map list the-store the-mark)))

(#%require "hw09-interpreter.rkt")
(run-debug "
{
  {
    val x = up(42)
    x              #1
  }
  { #block2
     val y = ( 1 2) #2
     val z = down(3) #3

     { #block3
       val t1 = up(13) #4
       val t2 = up(14) #5
       #at this point our store should have 5 values in it
       t2              #6
     }
     { #block4
       #in this scope, the values referenced by t1 and t2 are no longer
       #accessible so they should be available for garbage collection.
       val this-requires-gc = 42  #7
       this-requires-gc           #8
     }
  }
}
")

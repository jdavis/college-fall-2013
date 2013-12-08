#lang racket
(#%provide type-checking)
(#%require rackunit)

(#%require "hw09-type-checker.rkt")
(#%require "hw09-lang.rkt")

;this function will run all the tests.
(define (test-all)
  (test type-checking)
  )
;===============================================================================
;================================ tests original ===============================
;===============================================================================
(define type-checking
  (test-suite
   "type checking"
   
   suite-num
   suite-step
   suite-point
   suite-add
   suite-origin
   suite-if
   suite-move
   suite-val
   suite-fun
   suite-call
   suite-block
   suite-def
   
   );end test-suite
  )

(define suite-num
  (test-suite
   "num-expr"
   
   (test-case
    "num-expr"
    (check-equal?
     (check-types "42")
     'int
     )
    )   
   );end test-suite
  )

(define suite-step
  (test-suite
   "single steps"
   
   (test-case
    "single steps"
    (check-equal?
     (check-types "up(42)")
     'step
     )
    
    (check-equal?
     (check-types "down(42)")
     'step
     )
    
    (check-equal?
     (check-types "left(42)")
     'step
     )
    
    (check-equal?
     (check-types "right(42)")
     'step
     )
    
    (342-check-exn
     (check-types "up(up(42))")
     "type mismatch. expected: int     actual: step"
     )
    
    (342-check-exn
     (check-types "up(down(42))")
     "type mismatch. expected: int     actual: step"
     )
    
    (342-check-exn
     (check-types "up(left(42))")
     "type mismatch. expected: int     actual: step"
     )
    
    (342-check-exn
     (check-types "up(right(42))")
     "type mismatch. expected: int     actual: step"
     )
    )   
   );end test-suite
  )

(define suite-point
  (test-suite
   "point-expr"
   
   (test-case
    "point-expr"
    (check-equal?
     (check-types "(0 0)")
     'point
     )
    
    (342-check-exn
     (check-types "(up(42) 0)")
     "type mismatch. expected: int     actual: step"
     )
    
    (342-check-exn
     (check-types "(0 up(42))")
     "type mismatch. expected: int     actual: step"
     )
    )   
   );end test-suite
  )

(define suite-add
  (test-suite
   "add-expr"
   
   (test-case
    "up steps"
    (check-equal?
     (check-types "+ up(42) up(42)")
     'step
     )
    )
   
   (test-case
    "down steps"
    (check-equal?
     (check-types "+ down(42) down(42)")
     'step
     )
    )
   
   (test-case
    "left steps"
    (check-equal?
     (check-types "+ left(42) left(42)")
     'step
     )
    )
   
   (test-case
    "right steps"
    (check-equal?
     (check-types "+ right(42) right(42)")
     'step
     )
    )
   
   (test-case
    "mixed steps"
    (check-equal?
     (check-types "+ left(42) right(42)")
     'step
     )
    
    (check-equal?
     (check-types "+ left(42) up(42)")
     'step
     )
    
    (check-equal?
     (check-types "+ left(42) down(42)")
     'step
     )
    
    (check-equal?
     (check-types "+ right(42) left(42)")
     'step
     )
    
    (check-equal?
     (check-types "+ right(42) up(42)")
     'step
     )
    
    (check-equal?
     (check-types "+ right(42) left(42)")
     'step
     )
    
    (check-equal?
     (check-types "+ right(42) down(42)")
     'step
     )
    )
   
   (test-case
    "type errors"
    (342-check-exn
     (check-types "+ right(42) 42")
     "type mismatch. expected: step     actual: int"
     )
    
    (342-check-exn
     (check-types "+ 42 right(42)")
     "type mismatch. expected: step     actual: int"
     )
    
    (342-check-exn
     (check-types "+ 42 42")
     "type mismatch. expected: step     actual: int"
     )
    )
   );end test-suite
  )

(define suite-origin
  (test-suite
   "origin-expr"
   
   (test-case
    "origin-expr"
    (check-equal?
     (check-types "origin?((42 42))")
     'bool
     )
    
    (342-check-exn
     (check-types "origin?(42)")
     "type mismatch. expected: point     actual: int"
     )
    )
   );end test-suite
  )

(define suite-if
  (test-suite
   "if expr"
   
   (test-case
    "if expr"
    (check-equal?
     (check-types
      "if( origin?((42 42)) ) 
         then 42
         else 42
      ")
     'int
     )
    )
   
   (test-case
    "if, incorrect usage"
    (342-check-exn
     (check-types
      "if( origin?(42) )
         then 42
         else 42
      ")
     "type mismatch. expected: bool     actual: int"
     )
    
    (342-check-exn
     (check-types
      "if( origin?((42 42)) )
         then (0 0)
         else 42
      ")
     "type mismatch. expected: point     actual: int"
     )
    
    (342-check-exn
     (check-types
      "if( origin?((42 42)) )
         then 42
         else (0 0)
      ")
     "type mismatch. expected: int     actual: point"
     )
    
    )
   );end test-suite
  )

(define suite-move
  (test-suite
   "move-expr"
   
   (test-case
    "move expr"
    (check-equal?
     (check-types "move((42 42) up(42))")
     'point
     )
    
    (check-equal?
     (check-types "move((42 42) down(42))")
     'point
     )
    
    (check-equal?
     (check-types "move((42 42) left(42))")
     'point
     )
    
    (check-equal?
     (check-types "move((42 42) right(42))")
     'point
     )
    
    (check-equal?
     (check-types "move((42 42) right(42) left(42) down(42))")
     'point
     )
    )
   
   (test-case
    "incorrect usage of move"
    (342-check-exn
     (check-types "move(42 up(42))")
     "type mismatch. expected: point     actual: int"
     )
    
    (342-check-exn
     (check-types "move((0 0) 42)")
     "type mismatch. expected: step     actual: int"
     )
    )
   );end test-suite
  )

(define suite-val
  (test-suite
   "variable definitions"
   
   (test-case
    "correct usage"
    (check-equal?
     (check-types "val x:int =42; x")
     'int
     )
    
    (check-equal?
     (check-types "val x:bool = origin?((0 0)); x")
     'bool
     )
    
    (check-equal?
     (check-types "val x:point = (42 30); x")
     'point
     )
    ) 
   
   (test-case
    "incorrect usage, variable definitions"
    (342-check-exn
     (check-types "val  x:int = (0 0); x")
     "type mismatch. expected: int     actual: point"
     )
    
    (342-check-exn
     (check-types "val x: int = 42;
                   val y: bool = x;
                   x")
     "type mismatch. expected: bool     actual: int"
     )
    
    )
   );end test-suite
  )


(define suite-fun
  (test-suite
   "anonymous functions"
   
   (test-case
    "correct usage"
    (check-equal?
     (check-types "fun():int = 42")
     '(() -> int)
     )
    
    (check-equal?
     (check-types "fun(x:int y:bool):int = 42")
     '((int bool) -> int)
     )
    
    (check-equal?
     (check-types "fun(x:int y:bool):int = 42")
     '((int bool) -> int)
     )
    
    (check-equal?
     (check-types "val x:int =42;
                   fun():int = x")
     '(() -> int)
     )
    
    (check-equal?
     (check-types "fun(x:int y:bool):()->point = 
                     fun ():point = (42 42)
                      ")
     '((int bool) -> (() -> point))
     )
    )
   
   (test-case
    "incorrect usage of fun"
    (342-check-exn
     (check-types
      "fun():bool = 42"
      )
     "type mismatch. expected: bool     actual: int"
     )
    
    (342-check-exn
     (check-types
      "fun(x:int):bool = x"
      )
     "type mismatch. expected: bool     actual: int"
     )
    
    (342-check-exn
     (check-types
      "val x:int =42;
       fun():bool = x"
      )
     "type mismatch. expected: bool     actual: int"
     )
    
    (342-check-exn
     (check-types
      "fun(x:int y:bool):()->point = 
             fun ():point = 42"
      )
     "type mismatch. expected: point     actual: int"
     )
    )
   );end test-suite
  )

(define suite-call
  (test-suite
   "fun-call-expr"
   
   (test-case
    "call"
    (check-equal?
     (check-types
      "call(
          fun():int = 42
         )")
     'int
     )
    
    (check-equal?
     (check-types
      "call(
          fun(x:int):int = 42
          42
         )")
     'int
     )
    
    (check-equal?
     (check-types
      "call(
          fun(x:int y:point z:bool):int = 42
          42
          (0 0)
          origin?((42 42))
         )")
     'int
     )
    
    (check-equal?
     (check-types
      "call(
          fun(x:int):()->bool = fun():bool = origin?((0 0))
          42
         )")
     '(() -> bool)
     )
    )
   
   (test-case
    "incorrect usage of call"
    (342-check-exn
     (check-types
      "call(
          fun():int = 42
          42
         )")
     "arity mismatch. expected 0 arguments, received 1"
     )
    
    (342-check-exn
     (check-types
      "call(
          fun(x:int y:bool):int = 42
          42
          (0 0)
         )")
     "type mismatch. expected: bool     actual: point"
     )
    )
   );end test-suite
  )



(define suite-block
  (test-suite
   "block-expr"
   
   (test-case
    "correct usage"
    (check-equal?
     (check-types 
      "{42}")
     'int
     )
    
    (check-equal?
     (check-types 
      "{val x:int =42
        x
       }")
     'int
     )
    )   
   );end test-suite
  )

(define suite-def
  (test-suite
   "named function definitions"
   
   (test-case
    "correct usage"
    (check-equal?
     (check-types
      "def a():int = 42;
       a
       ")
     '(() -> int)
     )
    )
   
   (test-case
    "correct usage"
    (check-equal?
     (check-types
      "def a(x:int y:int):int = 42;
       a
       ")
     '((int int) -> int)
     )
    )
   );end test-suite
  )

;===============================================================================
;============================test infrastructure================================
;===============================================================================
(require rackunit/text-ui)

(define (test suite)
  (run-tests suite 'verbose)  
  )

(define-syntax 342-check-exn
  (syntax-rules ()
    [ (342-check-exn expression exn-msg)
      (check-equal? 
       (with-handlers ([string? (lambda (err-msg) err-msg)]) 
         expression)
       exn-msg)
      ]
    )
  )
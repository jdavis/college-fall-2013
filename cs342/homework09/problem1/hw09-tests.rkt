#lang racket
(#%provide (all-defined))
(#%require rackunit)

(#%require "hw09-interpreter.rkt")
(#%require "hw09-env-values.rkt")
(#%require "hw09-lang.rkt")

;this function will run all the tests.
(define (test-all)
  (test p1)
  (test implicit)
  (test original)
  )

;===============================================================================
;============================== tests problem 1 ================================
;===============================================================================
(define p1
  (test-suite
   "problem 1"
   (test-case
    "num-val"
    (342-check-exn
     (run
      "{
         val aNum = 42
         set (aNum up(42))
         aNum
       }"
      )
     "cannot assign a 'single-step-type value to a 'num-type value reference."
     )
    
    )
   
   (test-case
    "num-val"
    (342-check-exn
     (run
      "{
         val aNum = 42
         set (aNum (0 0))
         aNum
       }"
      )
     "cannot assign a 'point-type value to a 'num-type value reference."
     )
    )
   )
  )

;===============================================================================
;========================== tests original language ============================
;===============================================================================
(define implicit
  (test-suite
   "examples of implicit referencing"
   (test-case
    "simple example"
    (check-equal?
     (run "{val x = 42
            set (x 13)
            x
            }")
     (num-val 13)
     )
    )
   )
  )


(define original
  (test-suite
   "interpreter with basic operations and datatypes"
   
   (test-case
    "test case 1. basic datatype construction"
    
    ;just like in racket, a simple number is a valid program in our language.
    (check-equal?
     (run "42")
     (num-val 42)
     )
    
    (check-equal?
     (run "up(3)")
     (step-val (up-step 3))
     )
    
    (check-equal?
     (run "down(3)")
     (step-val (down-step 3))
     )
    
    (check-equal?
     (run "left(3)")
     (step-val (left-step 3))
     )
    
    (check-equal?
     (run "right(3)")
     (step-val (right-step 3))
     )
    
    (check-equal?
     (run "(0 0)")
     (point-val (point 0 0))
     )
    
    )
   
   (test-case
    "test case 2. invalid values for basic datatypes"
    
    (342-check-exn 
     (run "up(down(3))")
     "num-val->n, expected: num-val?, got: #(struct:step-val #(struct:down-step 3))"
     )
    
    (342-check-exn 
     (run "down(up(3))")
     "num-val->n, expected: num-val?, got: #(struct:step-val #(struct:up-step 3))"
     )
    
    (342-check-exn 
     (run "left(right(3))")
     "num-val->n, expected: num-val?, got: #(struct:step-val #(struct:right-step 3))"
     )
    
    (342-check-exn 
     (run "right(left(3))")
     "num-val->n, expected: num-val?, got: #(struct:step-val #(struct:left-step 3))"
     )
    
    (342-check-exn 
     (run "(3 up(42))")
     "num-val->n, expected: num-val?, got: #(struct:step-val #(struct:up-step 42))"
     )
    
    (342-check-exn 
     (run "(left(42) 2)")
     "num-val->n, expected: num-val?, got: #(struct:step-val #(struct:left-step 42))"
     )
    )
   
   (test-case
    "test case 3. checking a multi-expression program"
    (define multi-expression-program
      "
        42
        #our programs can be composed of multiple expressions
        #but only the value of the last expression is returned
        13
        up(42)
      "
      )
    (check-equal?
     (run multi-expression-program)
     (step-val (up-step 42))
     )
    ;since our language does not support any side effects, yet, we cannot test whether or not
    ;the first two expression were evaluated, but your code will be manually inspected
    ;to make sure that they were.
    )
   
   (test-case
    "test 4. add-expr, correct input"
    
    (check-equal?
     (run "+ up(1) up(2)")
     (step-val (up-step 3))
     )
    
    (check-equal?
     (run "+ up(2) up(1)")
     (step-val (up-step 3))
     )
    
    (check-equal?
     (run "+ up(2) down(1)")
     (step-val (up-step 1))
     )
    
    ;the tests should pass even if you don't write whitespaces
    (check-equal?
     (run "+up(2)down(1)")
     (step-val (up-step 1))
     )
    
    (check-equal?
     (run "+ down(1) up(2)")
     (step-val (up-step 1))
     )
    
    (check-equal?
     (run "+ down(5) up(2)")
     (step-val (down-step 3))
     )
    
    (check-equal?
     (run "+ up(2) down(5)")
     (step-val (down-step 3))
     )
    
    (check-equal?
     (run "+ up(5) down(2)")
     (step-val (up-step 3))
     )
    
    (check-equal?
     (run "+ down(2) up(5)")
     (step-val (up-step 3))
     )
    
    (check-equal?
     (run "+ down(2) down(1)")
     (step-val (down-step 3))
     )
    
    (check-equal?
     (run "+ down(1) down(2)")
     (step-val (down-step 3))
     )
    
    ;;left and right
    (check-equal?
     (run "+ left(1) left(2)")
     (step-val (left-step 3))
     )
    
    (check-equal?
     (run "+ left(2) left(1)")
     (step-val (left-step 3))
     )
    
    (check-equal?
     (run "+ left(2) right(1)")
     (step-val (left-step 1))
     )
    
    ;the tests should pass even if you don't write whitespaces
    (check-equal?
     (run "+left(2)right(1)")
     (step-val (left-step 1))
     )
    
    (check-equal?
     (run "+ right(1) left(2)")
     (step-val (left-step 1))
     )
    
    (check-equal?
     (run "+ left(5) right(2)")
     (step-val (left-step 3))
     )
    
    (check-equal?
     (run "+ right(2) left(5)")
     (step-val (left-step 3))
     )
    
    (check-equal?
     (run "+ right(5) left(2)")
     (step-val (right-step 3))
     )
    
    (check-equal?
     (run "+ left(2) right(5)")
     (step-val (right-step 3))
     )
    
    (check-equal?
     (run "+ left(2) left(1)")
     (step-val (left-step 3))
     )
    
    (check-equal?
     (run "+ left(1) left(2)")
     (step-val (left-step 3))
     )
    
    ;the plus operator will include only
    ;the first two up steps. The last
    ;up step will be treated as a separate
    ;expression. Since it is the last expression
    ;in the program, its value will be returned.
    (check-equal?
     (run "+ up(3) up(4) up(6)")
     (step-val (up-step 6))
     )
    
    )
   
   (test-case
    "test 5. add-expr, incorrect usage"
    ;this will only look for a non-specific error, you will see this assertion
    ;being used instead of the 342-check-exn whenever we expect the automatically
    ;generated parser to throw exceptions, rather than your own code. This will still
    ;require some manual inspection since an exception might be thrown even if you wrote
    ;the grammar incorrectly.
    (check-exn
     exn:fail?
     (lambda ()
       (run "+ up(3)")))
    
    ;you cannot add a number to an up-step
    (342-check-exn
     (run "+ 4 up(3)")
     "step-val->st, expected: num-val?, got: #(struct:num-val 4)"
     )
    
    (342-check-exn
     (run "+ up(3) 4")
     "step-val->st, expected: num-val?, got: #(struct:num-val 4)"
     )
    
    )
   
   (test-case
    "test 6. origin? correct usage"
    
    (check-equal?
     (run "origin? ((0 0))")
     (bool-val #t)
     )
    
    (check-equal?
     (run "origin?((0 1))")
     (bool-val #f)
     )
    
    )
   
   (test-case
    "test 7. origin? incorrect usage"
    
    (342-check-exn
     (run "origin? (42)")
     "point-val->p, expected: point-val?, got: #(struct:num-val 42)"
     )
    
    (342-check-exn
     (run "origin?(up(4))")
     "point-val->p, expected: point-val?, got: #(struct:step-val #(struct:up-step 4))"
     )
    
    (check-exn
     exn:fail?
     (lambda ()
       ;notice that we've given two numbers as parameters, not a point
       (run "origin?(0 0)")))
    
    )
   
   (test-case
    "test 8. if, correct usage"
    (check-equal?
     (run "
           if ( origin?((0 0)) )
              then 42
              else up(3)")
     (num-val 42)
     )
    
    (check-equal?
     (run "
           if ( origin?((0 1)) )
              then 42
              else up(3)")
     (step-val (up-step 3))
     )
    )
   
   (test-case
    "test 9. if, incorrect usage"
    
    (342-check-exn
     (run "
           if (42)
              then 42
              else up(3)")
     
     "bool-val->b, expected: bool-val?, got: #(struct:num-val 42)"
     )
    
    (check-exn
     exn:fail?
     (lambda ()
       (run "
           if (origin? (0 0))
              42
              else up(3)"))
     "mising 'then keyword"
     )
    
    (check-exn
     exn:fail?
     (lambda ()
       (run "
           if (origin? (0 0))
              then 42
              up(3)"))
     "missing 'else keyword"
     )
    
    (check-exn
     exn:fail?
     (lambda ()
       (run "
           if origin? (0 0)
              then 42
              up(3)"))
     "missing enclosing parentheses of the conditional"
     )
    )
   
   (test-case
    "test 10. move, one step"
    
    (check-equal?
     (run "move ((0 0) up(3))")
     (point-val '(point 0 3))
     )
    
    (check-equal?
     (run "move ((0 0) down(3))")
     (point-val '(point 0 -3))
     )
    
    (check-equal?
     (run "move ((0 0) left(3))")
     (point-val '(point -3 0))
     )
    
    (check-equal?
     (run "move ((0 0) right(3))")
     (point-val '(point 3 0))
     )
    )
   
   (test-case
    "test 11. move, multiple steps"
    
    (check-equal?
     (run "move ((0 0)
                  right(3)
                  right(7)
               )")
     (point-val '(point 10 0))
     )
    
    (check-equal?
     (run "move ((0 0)
                  right(3)
                  right(7)
                  up(42)
               )")
     (point-val '(point 10 42))
     )
    
    (check-equal?
     (run "move ((0 0)
                  right(3)
                  right(7)
                  up(5)
                  down(3)
                  left(2)
               )")
     (point-val '(point 8 2))
     )
    
    (check-equal?
     (run "move ((-3 2)
                  up(1)
                  right(5)
                  left(10)
                  left(2)
               )")
     (point-val '(point -10 3))
     )
    
    )
   
   (test-case
    "test 12. move, incorrect usage"
    
    (342-check-exn
     (run "move(up(3) down(3))")
     "point-val->p, expected: point-val?, got: #(struct:step-val #(struct:up-step 3))"
     )
    
    (342-check-exn
     ;the 5th parameter is not a step
     (run "move((0 0) up(3) down(3) left(3) 42 right(42))")
     "step-val->st, expected: num-val?, got: #(struct:num-val 42)"
     )
    
    (check-exn
     exn:fail?
     (lambda ()
       (run "move((0 0))"))
     "missing at least one step after the starting point"
     )
    
    )
   
   (test-case
    "test 0. block with no variables"
    
    (define empty-block "{}")
    ;this is a valid program, but the return value is undefined,
    ;i.e. you may return whatever you want.
    (check-not-exn (lambda () (run empty-block)))
    
    (check-equal?
     (run "{
             up(42)
           }")
     (step-val (up-step 42))
     )
    
    (check-equal?
     (run "{
             up(42)
             down (3)
           }")
     (step-val (down-step 3))
     )
    
    (check-equal?
     (run "{
             up(42)
             down (3)
             (42 42)
           }")
     (point-val '(point 42 42))
     )
    )
   
   (test-case
    "test 1. one single variable declaration and usage"
    (check-equal?
     (run "{
               val x = up(3)
               x
             }")
     (step-val (up-step 3))
     )
    
    (check-equal?
     (run "{
               val x = up(3)
               x
               (0 0)
             }")
     (point-val '(point 0 0))
     )
    
    ;this is a valid program, but its return value is undefined.
    ;i.e. you may have it return whatever value you want.
    (define one-var-declaration
      "{
         val x = up(3)
       }")
    (check-not-exn (lambda () (run one-var-declaration)))
    )
   
   (test-case
    "test 2. multiple variables"
    
    (check-equal?
     (run "{
              val x = up(3)
              val y = down(4)
              val z = + x y
              z
           }")
     (step-val (down-step 1))
     "you should be able to make use of previous variable definitions"
     )
    
    (check-equal?
     (run "{
              val x = 5
              val y = up(x)
              val x = down(3)
              val y = + down(3) x
              y
           }")
     (step-val (down-step 6))
     "shadowing variables should work"
     )
    
    (check-equal?
     (run "{
              val x = 5
              val y = up(x)
              val x = down(3)
              val y = + y x
              y
           }")
     (step-val (up-step 2))
     "redefining a variable in terms of its previous definition should work"
     )
    
    (check-equal?
     (run "{
              val x-val = 42
              val x = up(x-val)
              val y = down(4)
              val point = (0 0)
              #evaluating an expression who's value is discarded
              x
              if (origin?(point))
                 then x
                 else y
           }")
     (step-val (up-step 42))
     "there should be no restriction on the complexity of the program"
     )
    )
   
   (test-case
    "test 3. nested blocks"
    
    (check-equal?
     (run
      "{
        val x = 42
        {
         val y = 23
        }
        x
      }")
     (num-val 42)
     )
    
    (check-equal?
     (run
      "{
        val x = 42
        {
         val y = 23
         x
        }
      }")
     (num-val 42)
     "the value of x should be available in the inner block even if declared only in the outer block"
     )
    
    (check-equal?
     (run
      "{
        val x = 42
        {
         val x = 23
        }
        x
       }")
     (num-val 42)
     "val x = 23 is in a different scope as val x = 42 so the value of x in the outer block should not be affected"
     )
    
    (check-equal?
     (run
      "{
        val x = 42
        {
         val x = 23
         x
        }
      }")
     (num-val 23)
     "the value of the outer block is the value of the inner block, in this case the definition of x in the inner block
     shadows the outer definition
      "
     )
    )
   
   (test-case
    "test 4. block, incorrect usage"
    
    (check-exn
     exn:fail?
     (lambda ()
       (run "{
                val x = 42
                x
                val y = 33
               

              }"))
     "can't have variable declarations after an expression"
     )
    
    ;undefined variable
    (342-check-exn
     (run "{ x }") 
     "No binding for 'x"
     )
    
    ;undefined variable outside of a block
    (342-check-exn
     (run "y") 
     "No binding for 'y"
     )
    
    ;a variable declared in an inner scope is not visible in an outer scope.
    (342-check-exn
     (run
      "{
        val x = 42
        {
         val y = 23
        }
        y
      }")
     "No binding for 'y"
     )
    )
   
   (test-case
    "test 4. final variables"
    
    (check-equal?
     (run "{
             val x = 33
             final val x = 42
             x
           }")
     (num-val 42)
     "can override normal variable declaration with a final one"
     )
    
    ;val expression cannot override a final variable
    (342-check-exn
     (run "{
             final val x = 42
             val x = 33
             x
           }")
     "variable 'x is final and cannot be overridden."
     )
    
    ;neither can a final val expression.
    (342-check-exn
     (run "{
             final val x = 42
             final val x = 33
             x
           }")
     "variable 'x is final and cannot be overridden."
     )
    )
   (test-suite
    "program parameters"
    
    (test-case
     "one single argument"
     
     (check-equal?
      (run "arg0" "up(3)")
      (step-val (up-step 3))
      )
     
     (check-equal?
      (run "{
             val arg0 = 42
             arg0
           }")
      (num-val 42)
      "you can have variables named 'argX if there are no program parameters"
      )
     
     (check-equal?
      (run "{
             val arg1 = up(3)
             + arg0 arg1
           }"
           "up(24)"
           )
      (step-val (up-step 27))
      "you can have variables named 'argX if X > number of parameters + 1"
      )
     
     (check-equal?
      (run "up(arg0)" "3")
      (step-val (up-step 3))
      )
     
     (check-equal?
      (run "arg0" "(0 0)")
      (point-val (point 0 0))
      )
     
     (check-equal?
      (run "arg0" "+ up(1) up(2)")
      (step-val (up-step 3))
      )
     
     (check-equal?
      (run "arg0" "+ up(3) up(4) up(6)")
      (step-val (up-step 6))
      )
     )
    
    (test-case
     "2 arguments"
     (check-equal?
      (run "+ arg0 arg1" 
           "up(3)"
           "up(5)")
      (step-val (up-step 8))
      )
     
     (check-equal?
      (run "move(arg0 arg1 up(3) down(4))" "(2 2)" "down(3)")
      (point-val '(point 2 -2))
      )
     )
    
    (test-case
     "multiple arguments"
     (check-equal?
      (run "move((0 0) arg0 arg1 arg2 arg3 arg4 arg5 arg6)"
           "up(3)"
           "left(5)"
           "right(4)"
           "down(2)"
           "up(6)"
           "right(2)"
           "right(3)"
           )
      (point-val '(point 4 7))
      )
     )
    
    (test-case
     "incorrect usage"
     
     (342-check-exn
      (run "arg0")
      "No binding for 'arg0"     
      )
     
     (342-check-exn
      (run "arg1" "up(2)")
      "No binding for 'arg1"     
      )
     
     (342-check-exn
      (run "arg0" (up-step 3))
      "argument should be a string, got: #(struct:up-step 3)"   
      )
     
     (342-check-exn
      (run "arg0" "up(3)"
           42
           "down(3)")
      "argument should be a string, got: 42"
      )
     
     ;;cannot override the program arguments 
     (342-check-exn
      (run "{val arg0 = 42}"
           "up(3)")
      "variable 'arg0 is final and cannot be overridden."
      )
     )
    )
   
   (test-suite
    "program parameters"
    
    (test-case
     "one single argument"
     
     (check-equal?
      (run "arg0" "up(3)")
      (step-val (up-step 3))
      )
     
     (check-equal?
      (run "{
             val arg0 = 42
             arg0
           }")
      (num-val 42)
      "you can have variables named 'argX if there are no program parameters"
      )
     
     (check-equal?
      (run "{
             val arg1 = up(3)
             + arg0 arg1
           }"
           "up(24)"
           )
      (step-val (up-step 27))
      "you can have variables named 'argX if X > number of parameters + 1"
      )
     
     (check-equal?
      (run "up(arg0)" "3")
      (step-val (up-step 3))
      )
     
     (check-equal?
      (run "arg0" "(0 0)")
      (point-val (point 0 0))
      )
     
     (check-equal?
      (run "arg0" "+ up(1) up(2)")
      (step-val (up-step 3))
      )
     
     (check-equal?
      (run "arg0" "+ up(3) up(4) up(6)")
      (step-val (up-step 6))
      )
     )
    
    (test-case
     "2 arguments"
     (check-equal?
      (run "+ arg0 arg1" 
           "up(3)"
           "up(5)")
      (step-val (up-step 8))
      )
     
     (check-equal?
      (run "move(arg0 arg1 up(3) down(4))" "(2 2)" "down(3)")
      (point-val '(point 2 -2))
      )
     )
    
    (test-case
     "multiple arguments"
     (check-equal?
      (run "move((0 0) arg0 arg1 arg2 arg3 arg4 arg5 arg6)"
           "up(3)"
           "left(5)"
           "right(4)"
           "down(2)"
           "up(6)"
           "right(2)"
           "right(3)"
           )
      (point-val '(point 4 7))
      )
     )
    
    (test-case
     "incorrect usage"
     
     (342-check-exn
      (run "arg0")
      "No binding for 'arg0"     
      )
     
     (342-check-exn
      (run "arg1" "up(2)")
      "No binding for 'arg1"     
      )
     
     (342-check-exn
      (run "arg0" (up-step 3))
      "argument should be a string, got: #(struct:up-step 3)"   
      )
     
     (342-check-exn
      (run "arg0" "up(3)"
           42
           "down(3)")
      "argument should be a string, got: 42"
      )
     
     ;;cannot override the program arguments 
     (342-check-exn
      (run "{val arg0 = 42}"
           "up(3)")
      "variable 'arg0 is final and cannot be overridden."
      )
     )
    )
   
   (test-suite
    "anonymous procedures"
    
    (test-case
     "procedures as values"
     
     ;the exact way you represent procedures is up to you, but just like a
     ;(lambda ...) expression in racket, the fun-expr in our language
     ;has to return the procedure as a value.
     (check-not-exn
      (lambda ()
        (run "fun() = up(42)")))
     
     (check-not-exn
      (lambda ()
        (run "fun(x) = + x up(42)")))
     
     (check-not-exn
      (lambda ()
        (run "fun(x y z) =
              {+ x {+ y z}}")))
     
     (check-equal?
      (run "fun(x y) = + x y")
      (run "fun(x y) = + x y")
      "these two functions should be identical"
      )
     
     ;you can assign a function to a variable.
     (check-not-exn
      (lambda ()
        (run
         "{
            val add-42 = {fun(x) = + x up(42)}
            add-42
          }")))
     )
    
    (test-case
     "funciton calls"
     
     (check-equal?
      (run 
       "call
         (fun(x) = + x up(42)
          #the above line is the function creation, we call that function
          #with the parameter down(40)
          down(40)
         )
       "
       )
      (step-val (up-step 2))
      )
     
     (check-equal?
      (run
       "{
         val add-42 =
           fun(x) = + x up(42)

         call (add-42 down(40))
       }")
      (step-val (up-step 2))
      )
     
     (check-equal?
      (run
       "{
         val move-3 = 
           fun (p st1 st2 st3) = move (p st1 st2 st3)
      
         call (move-3 (0 0) up(3) down(1) right(2))
       }")
      (point-val '(point 2 2))
      )
     
     ;function parameters shadow previous variables with the same names definitions.
     (check-equal?
      (run
       "{
         val x = 42
         call (fun (x) = x
               #we're calling the identity function with the value 13
               13)
       }")
      (num-val 13)
      )
     )
    
    (test-case
     "closures"
     
     (test-case
      "functions that return functions"
      (check-equal?
       (run 
        "call (call (fun () = fun(x) = x) 42)")
       (num-val 42)
       )
      )
     
     (check-equal?
      (run 
       "{
          val forty-two = 42
          #this function will return the value of the variable 'forty-two
          val f = fun() = forty-two
          call(f)
        }
       ")
      (num-val 42)
      )
     
     (check-equal?
      (run
       "{
         val add-upX = 
           fun (x) = {fun (y) = + up(x) y}
        
         val add-up42 = call (add-upX 42)
      
         call (add-up42 down(40))
       }")
      (step-val (up-step 2))
      )
     
     (check-equal?
      (run
       "{
         val move-from = 
           fun (p) = {fun (st) = move(p st)}
        
         val move-from00 = call (move-from (0 0))
      
        call(move-from00 right(2))
       }")
      (point-val '(point 2 0))
      )    
     )
    
    (test-case
     "higher order procedures"
     (check-equal?
      (run 
       "{
          val indirection = fun (f p)=call (f p)
          val helper =
             fun (x) = 
                 if (origin?(x))
                     then 42
                     else 0
          call (indirection helper (0 0))
        }"
       )
      (num-val 42)
      )
     )
    
    (test-case
     "incorrect usage"
     
     (342-check-exn
      (run "call(
            fun (x y) = {
              val x = 42
              x
            }
            13
          )")
      "arity mismatch. expected 2 arguments, received 1"
      )
     )
    )
   
   (test-suite 
    "named functions"
    
    (test-case
     "regular usage of def"
     
     (check-equal?
      (run
       "def f42() = 42;
       def up-alias(x) = up(x);
       
      #actual body of the program:
       call(up-alias call(f42))")
      (step-val (up-step 42))
      
      "multiple function definitions"
      )
     
     (check-equal?
      (run
       "final val constant = 42;
       def f42() = constant;
       def up-alias(x) = up(x);
       #actual body of the program:
       call(up-alias call(f42))")
      (step-val (up-step 42))
      
      "you can have variable definitions as well as function definitions before the body of the program"
      )
     
     (check-equal?
      (run
       "def f() = 42;
       val f-alias = f;
       
       call(f-alias)")
      (num-val 42)
      )
     )
    
    (test-case
     "incorrect usage of def"
     ;defs are implicitely final.
     (342-check-exn
      (run 
       "def not-overridable() = 42;
        {
          val not-overridable = 13
          not-overridable   
        }
        ")
      "variable 'not-overridable is final and cannot be overridden."
      )
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
#lang racket
(#%provide check-types type-mismatch-exception)
(#%require (lib "eopl.ss" "eopl"))

(#%require "hw09-lang.rkt")
(#%require "hw09-tenv.rkt")


;IMPORTANT: these partial implementations serve only as an example, you may
;rewrite them however you want to as long as the signature  of the "check-types"
;procedure stays the same.
;================================= check-types =================================
(define (check-types program-string)
  ;type->symbol is a trivially easy translation function from the internal
  ;representation of the types, to the symbol+list form used in the tests.
  (type->symbol
   (type-of (create-ast program-string) (empty-tenv)))
  )

;===============================================================================
;================================= type-of =====================================
;===============================================================================
(define (type-of ast tenv)
  (cond
    [(program? ast) (type-of-program ast tenv)]
    [(expr? ast) (type-of-expr ast tenv)]
    [(var-expr? ast) (type-of-var-expr ast tenv)]
    [else (raise (to-string "Not an ast node: " ast))]
    )
  )

;================================= program =====================================
(define (type-of-program prog tenv)
  (cases program prog
         (a-program (var-exprs expr exprs)
                    (let
                      ([new-tenv (foldl type-of tenv var-exprs)])
                      (andmap
                        (lambda (e) (type-of e new-tenv))
                        (cons
                          expr
                          exprs)))
                    )
         )
  )

;=================================== expr ======================================
(define (type-of-expr ex tenv)
  (cases expr ex
    ;a number has type int-type
    (num-expr (num) (int-type))

    ;aside from having to return a point-type, the point-expr must verify
    ;that it was given two int-types.
    (point-expr
     (x y)
     (let
         ([type-of-x (type-of x tenv)]
          [type-of-y (type-of y tenv)])
       (check-expected-type! type-of-x (int-type))
       (check-expected-type! type-of-y (int-type))
       (point-type)
       )
     )

    (origin-expr
      (x)
      (let
        ([type-of-x (type-of x tenv)])
        (check-expected-type! type-of-x (point-type)))
      (bool-type))

    (if-expr
      (x y z)
     (let
         ([type-of-x (type-of x tenv)]
          [type-of-y (type-of y tenv)]
          [type-of-z (type-of z tenv)])
       (check-expected-type! type-of-x (bool-type))
       (check-expected-type! type-of-y type-of-y)
       (check-expected-type! type-of-z type-of-y)
       type-of-y
       )

    (up-expr
      (x)
      (let
        ([type-of-x (type-of x tenv)]
         [expected (int-type)])
        (check-expected-type! type-of-x expected))
      (step-type))

    (else (raise (to-string "No typing rules for the following <expr>: " ex)))
    )
  )

;=================================== var =======================================
(define (type-of-var-expr v-ex tenv)
  'UNIMPLEMENTED-TYPE-OF-VAR
  )



;I advise you use this function to compare two types
(define (check-expected-type! actual expected)
  (if (equal? actual expected)
      actual
      (type-mismatch-exception (type->symbol expected) (type->symbol actual))
      )
  )

(define (type-mismatch-exception expected actual)
  (raise (to-string "type mismatch. expected: " expected "     actual: " actual)))

;you will need to add the conversion rules from types to symbols as you add new types
;to the language
(define (type->symbol t)
  (cases type t
    (int-type () 'int)
    (bool-type () 'bool)
    (proc-type (type-args type) '(type-args -> type))
    (step-type () 'step)
    (point-type () 'point)
    (else 'NO-TYPE->SYMBOL-CONVERSION-AVAILABLE)
    )
  )

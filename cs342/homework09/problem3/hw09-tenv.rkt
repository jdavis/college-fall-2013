#lang racket
(#%require (lib "eopl.ss" "eopl"))
(#%require "hw09-lang.rkt")

(#%provide (all-defined))

;same behaviour as the function ~a
(define (to-string s . los)
  (letrec
      ([lst (cons s los)]
       [lst-of-strings (map (lambda (s) (format "~a" s)) lst)])
    (foldr string-append "" lst-of-strings)
    )
  )

;given one or more arguments this function will return a flat list
(define (flat-list el1 . rest)
  (flatten (list el1 rest))
  )
;===============================================================================
;==================================== Types ====================================
;===============================================================================
(define (invalid-types-exception expected-type actual-type)
  (raise (to-string "type error; expected: " expected-type ", got: " actual-type) ))

;we now deal with an environment for storing types, not expressed values
(define-datatype t-environment t-environment?
  (empty-tenv)
  (extend-tenv
   (bvar symbol?)
   (bval type?)
   (saved-env t-environment?))
  )

(define (apply-tenv tenv search-sym)
  (cases t-environment tenv
    (empty-tenv
     ()
     (no-binding-exception search-sym))

    (extend-tenv
     (var val saved-env)
     (if (eqv? search-sym var)
         val
         (apply-tenv saved-env search-sym)))
    )
  )

(define (no-binding-exception sym)
  (raise (to-string "No type for '" sym)))

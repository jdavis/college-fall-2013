#lang racket
(#%provide (all-defined))
(#%require rackunit)

(#%require "hw06-answer-sheet.rkt")
(#%require "hw06-env-values.rkt")

;===============================================================================
;============================= tests problem 4 =================================
;===============================================================================
(define p4
  (test-suite
   "the tests for your language features"
   
   (test-case
    "test case 1."
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
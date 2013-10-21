#lang racket
(#%provide (all-defined))
(#%require rackunit)

(#%require "hw06-davis.rkt")
(#%require "hw06-env-values.rkt")

;===============================================================================
;============================= tests problem 4 =================================
;===============================================================================

;
; This language feature gives a primitive feature set for operating with lines.
; You can put in two points (which calculates the slope) as well as an x
; value to determine the y value at that point.
;
; Examples:
;
; - Basic line at at point x = 2
; > line((0, 0) (1, 1)) at 2
; 2
;
; - You can make a new point from a line by doing the following:
; > (2 line((0, 0) (1, 1)) at 2)
; '(point 2 2)
(define p4
  (test-suite
   "the tests for your language features"

   (test-case
    "test case 1. test support for floats"

    (check-equal?
      (run "1.2345")
      (num-val 1.2345)
      )

    (check-equal?
      (run "-1.2345")
      (num-val -1.2345)
      )

    (check-equal?
      (run ".2345")
      (num-val .2345)
      )

    (check-equal?
      (run "-.2345")
      (num-val -.2345)
      )

    (check-equal?
      (run "0.2345")
      (num-val 0.2345)
      )

    (check-equal?
      (run "-0.2345")
      (num-val -0.2345)
      )
    )

   (test-case
    "test case 2. basic line construction"

    (check-equal?
      (run "line((0 0) (1 1)) at 2")
      (num-val 2)
      )

    (check-equal?
      (run "(2 line((0 0) (1 1)) at 2)")
      (point-val (point 2 2))
      )

    (check-equal?
      (run "line((0 0) (1 1)) at 0")
      (num-val 0)
      )

    (check-equal?
      (run "(0 line((0 0) (1 1)) at 0)")
      (point-val (point 0 0))
      )

    (check-equal?
      (run "origin? ((0 line((0 0) (1 1)) at 0))")
      (bool-val #t)
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

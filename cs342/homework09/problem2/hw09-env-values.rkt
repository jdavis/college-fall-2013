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
;============================= Expressed Values ================================
;===============================================================================
(define-datatype expressed-val expressed-val?
  (num-val (n number?))
  (bool-val (b boolean?))
  (step-val (s step?))
  (point-val (p point?))
  (proc-val (p proc?))
  )

(define (invalid-args-exception fun-name expected-val actual-val)
  (raise (to-string fun-name ", expected: " expected-val ", got: " actual-val) ))
;================================ expressed-val ===================================
(define (num-val->n num)
  (or (expressed-val? num) (invalid-args-exception "num-val->n" "expressed-val?" num))
  (cases expressed-val num
    (num-val (n) n)
    (else (invalid-args-exception "num-val->n" "num-val?" num))
    )
  )

(define (bool-val->b bool)
  (or (expressed-val? bool) (invalid-args-exception "bool-val->b" "expressed-val?" bool))
  (cases expressed-val bool
    (bool-val (b) b)
    (else (invalid-args-exception "bool-val->b" "bool-val?" bool))
    )
  )

(define (step-val->st st)
  (or (expressed-val? st) (invalid-args-exception "step-val->st" "expressed-val?" st))
  (cases expressed-val st
    (step-val (st) st)
    (else (invalid-args-exception "step-val->st" "num-val?" st))
    )
  )

(define (point-val->p p)
  (or (expressed-val? p) (invalid-args-exception "point-val->p" "expressed-val?" p))
  (cases expressed-val p
    (point-val (p) p)
    (else (invalid-args-exception "point-val->p" "point-val?" p))
    )
  )

(define (proc-val->proc p)
  (or (expressed-val? p) (invalid-args-exception "proc-val->proc" "expressed-val?" p))
  (cases expressed-val p
    (proc-val (pr) pr)
    (else (invalid-args-exception "proc-val->proc" "proc-val?" p))
    )
  )
;==================================== proc =====================================
(define-datatype proc proc?
  (procedure
   (vars (list-of symbol?))
   (body expr?)
   (env environment?)
   )
  )

(define (proc->vars p)
  (or (proc? p) (invalid-args-exception "proc->vars" "proc?" p))
  (cases proc p
    (procedure (vars body env) vars)
    )
  )

(define (proc->body p)
  (or (proc? p) (invalid-args-exception "proc->body" "proc?" p))
  (cases proc p
    (procedure (vars body env) body)
    )
  )

(define (proc->env p)
  (or (proc? p) (invalid-args-exception "proc->env" "proc?" p))
  (cases proc p
    (procedure (vars body env) env)
    )
  )

;==================================== step =====================================
(define-datatype step step?
  (up-step (num number?))
  (down-step (num number?))
  (left-step (num number?))
  (right-step (num number?))
  )

(define (up-step? st)
  (and (step? st)
       (cases step st
         (up-step (num) #t)
         (else #f)
         )
       )
  )

(define (down-step? st)
  (and (step? st)
       (cases step st
         (down-step (num) #t)
         (else #f)
         )
       )
  )

(define (left-step? st)
  (and (step? st)
       (cases step st
         (left-step (num) #t)
         (else #f)
         )
       )
  )

(define (right-step? st)
  (and (step? st)
       (cases step st
         (right-step (num) #t)
         (else #f)
         )
       )
  )


(define (single-step->n st)
  (if (step? st)
      (cases step st
        (up-step (num) num)
        (down-step (num) num)
        (left-step (num) num)
        (right-step (num) num)
        (else (invalid-args-exception "single-step->n" "single-step?" st))
        )
      (raise (invalid-args-exception "single-step->n" "single-step?" st))
      )
  )

;=================================== point =====================================
(define point-type 'point)
(define (point x y)
  (or (number? x) (raise (invalid-args-exception "point" "number" x)))
  (or (number? y) (raise (invalid-args-exception "point" "number" y)))
  (list point-type x y)
  )

(define (point? p)
  (and (list? p)
       (= 3 (length p))
       (equal? (first p) point-type)
       (number? (second p))
       (number? (third p)))
  )

(define (point->x p)
  (if (point? p)
      (second p)
      (raise (invalid-args-exception "point->x" "point?" p))
      )
  )
(define (point->y p)
  (if (point? p)
      (third p)
      (raise (invalid-args-exception "point->x" "point?" p))
      )
  )


;===============================================================================
;=============================== Environment ===================================
;===============================================================================

(define FINAL #t)
(define NON-FINAL #f)

(define (extend-env-wrapper sym val old-env final?)
  (define (is-var-final? env)
    (cases environment env
      (empty-env () #f)

      (extend-env (sym val prev-env)
                  (is-var-final? prev-env))

      (extend-env-final (stored-sym val prev-env)
                        (if (equal? sym stored-sym)
                            #t
                            (is-var-final? prev-env)
                            )
                        )
      )
    )

  (if (is-var-final? old-env)
      (sym-final-exception sym)
      (if final?
          ;$implicit we now extend the environment with references to values
          ;it is advantageous that we always used extend-env-wrapper instead of
          ;any of the standard constructors, we only have to modify code here!
          ;unlike the implementation in your textbook where all call sites
          ;of extend-env had to be modified.
          (extend-env-final sym (newref val) old-env)
          (extend-env sym (newref val) old-env)
          )
      )
  )

(define-datatype environment environment?
  (empty-env)
  (extend-env
   (bvar symbol?)
   ;$implicit the environment now stores only references
   (bval reference?)
   (saved-env environment?))
  (extend-env-final
   (bvar symbol?)
   ;$implicit the environment now stores only references
   (bval reference?)
   (saved-env environment?)))

(define (apply-env env search-sym)
  (cases environment env
    (empty-env ()
               (no-binding-exception search-sym))

    (extend-env (var val saved-env)
                (if (eqv? search-sym var)
                    val
                    (apply-env saved-env search-sym))
                )

    (extend-env-final (var val saved-env)
                      (if (eqv? search-sym var)
                          val
                          (apply-env saved-env search-sym)))
    )
  )

(define (sym-final-exception sym)
  (raise (to-string "variable '" sym " is final and cannot be overridden."))
  )

(define (no-binding-exception sym)
  (raise (to-string "No binding for '" sym))
  )

;===============================================================================
;================================ the store ====================================
;===============================================================================
;;; world's dumbest model of the store:  the store is a list and a
;;; reference is number which denotes a position in the list.

;; the-store: a Scheme variable containing the current state of the
;; store.  Initially set to a dummy value.
(define the-store 'uninitialized)
(define the-mark 'uninitialized)

;; empty-store : () -> Store
;; Page: 111
(define empty-store
  (lambda () '()))

;; initialize-store! : () -> Store
;; usage: (initialize-store!) sets the-store to the empty-store
;; Page 111
(define initialize-store!
  (lambda ()
    (set! the-store (empty-store))
    (set! the-mark (empty-store))))

(define (set-store-ref! ref b)
  (displayln (~a "Setting ref " ref " with value " b))
  (set!
    the-mark
    (append
      (take the-mark ref)
      (list b)
      (drop the-mark (+ ref 1)))))

;; reference? : SchemeVal -> Bool
;; Page: 111
(define (reference? v)
  (integer? v))

;; newref : ExpVal -> Ref -- malloc in C/C++
;; Page: 111
(define (newref val)
  (let ((next-ref (length the-store)))
    (set! the-store
          (append
            the-store
            (list val)))
    (set! the-mark
          (append
            the-mark
            (list (list))))
    next-ref))

;; deref : Ref -> ExpVal -- value->string at certain reference
;; Page 111
(define (deref ref)
  (or (list? the-store) (raise "unitialized store"))
  (if (>= ref (length the-store))
    (report-invalid-reference ref)
      (list-ref the-store ref)
      )
  )

;
; Garbage Collection Code
;

(define (ref-flag ref)
  (or (list? the-store) (raise "unitialized store"))
  (if (>= ref (length the-store))
      (report-invalid-reference ref)
      (list-ref the-mark ref)
      )
  )

(define (mark-all)
  (set!
    the-mark
    (map
      (lambda (i) #t)
      the-store)))

(define (clear-reachable env)
  (cases environment env
         (empty-env () (list))

         (extend-env (var val saved-env)
                    (set-store-ref!
                      (deref val)
                      #f)
                    (clear-reachable saved-env))

         (extend-env-final (var val saved-env)
                    (set-store-ref!
                      val
                      (deref val)
                      #f)
                    (clear-reachable saved-env))))

(define (sweep env)
  (list))

(define (gc env)
  (begin
    (mark-all)
    (clear-reachable env)
    (sweep env)))

;; setref! : Ref * ExpVal -> Unspecified -- backend of assignment
;; Page: 112
(define (setref! ref val)
  (or (list? the-store) (raise "unitialized store"))
  (if (>= ref (length the-store))
      (report-invalid-reference ref)
      (set! the-store
            ;we map the old store to a new one where only the element on
            ;position 'ref' is changed. The exact same thing we did for the
            ;change-at-index problem in homework 2.
            (map (lambda (store-entry index)
                   (if (= index ref)
                       val
                       store-entry
                       )
                   )
                 the-store
                 (range (length the-store))))
      )
  )

(define (report-invalid-reference ref)
  (raise (to-string "illegal reference: " ref "; in store: " the-store)))

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
        (check-expected-type! type-of-x (point-type))
        (bool-type)
        )
      )

    (if-expr
      (cond-expr then-expr else-expr)
     (let
         ([type-of-cond (type-of cond-expr tenv)]
          [type-of-then (type-of then-expr tenv)]
          [type-of-else (type-of else-expr tenv)])
       (check-expected-type! type-of-cond (bool-type))
       (check-expected-type! type-of-else type-of-then)
       type-of-then
       )
     )

    (up-expr
      (x)
      (let
        ([type-of-x (type-of x tenv)])
        (check-expected-type! type-of-x (int-type))
        (step-type)
        )
      )

    (down-expr
      (x)
      (let
        ([type-of-x (type-of x tenv)])
        (check-expected-type! type-of-x (int-type))
        (step-type)
        )
      )

    (left-expr
      (x)
      (let
        ([type-of-x (type-of x tenv)])
        (check-expected-type! type-of-x (int-type))
        (step-type)
        )
      )

    (right-expr
      (x)
      (let
        ([type-of-x (type-of x tenv)])
        (check-expected-type! type-of-x (int-type))
        (step-type)
        )
      )

    (add-expr
      (x y)
      (let
        ([type-of-x (type-of x tenv)]
         [type-of-y (type-of y tenv)])
        (check-expected-type! type-of-x (step-type))
        (check-expected-type! type-of-y (step-type))
        (step-type)
        )
      )

    (move-expr
      (p st rest-of-st)
      (let
        ([type-of-p (type-of p tenv)]
         [type-of-st (type-of st tenv)]
         [type-of-rest (map (lambda (s) (type-of s tenv)) rest-of-st)])
        (check-expected-type! type-of-p (point-type))
        (check-expected-type! type-of-st (step-type))
        (map
          (lambda (s) (check-expected-type! s (step-type)))
          type-of-rest)
        (point-type)
        )
      )

    (iden-expr
      (iden)
      (apply-tenv tenv iden)
      )

    (fun-expr
      (args arg-types body-type body-expr)
      (letrec
         ([new-tenv (foldl extend-tenv tenv args arg-types)]
          [type-of-body-expr (type-of body-expr new-tenv)])
        (check-expected-type! type-of-body-expr body-type)
        (proc-type arg-types body-type)
        )
      )

    (fun-call-expr
      (proc param-values)
      (letrec
        ([type-of-proc (type-of proc tenv)]
         [type-of-params (map (lambda (s) (type-of s tenv)) param-values)]
         [proc-types (proc-type->types type-of-proc)]
         [proc-arg-types (first proc-types)]
         [body-type (second proc-types)]
         [new-proc (proc-type type-of-params body-type)])
        (when (not
                (=
                  (length proc-arg-types)
                  (length param-values)))
          (raise
            (to-string
              "arity mismatch. expected "
              (length proc-arg-types)
              " arguments, received "
              (length param-values))))
        (for
          ([arg proc-arg-types]
           [param type-of-params])
          (check-expected-type! param arg))
        body-type
        )
      )

    (block-expr
      (var-exprs exprs)
      (let
        ([new-tenv (foldl type-of tenv var-exprs)])
        (andmap
          (lambda (e) (type-of e new-tenv))
          exprs)
        )
      )

    (else (raise (to-string "No typing rules for the following <expr>: " ex)))
    )
  )

;=================================== var =======================================
(define (type-of-var-expr v-ex tenv)
  (cases var-expr v-ex
    (val
      (var-name var-type value)
      (let
        ([type-of-val (type-of value tenv)])
        (check-expected-type! type-of-val var-type)
        (extend-tenv var-name var-type tenv)
        )
      )

    (def-fun
      (name args arg-types body-type body-expr)
      (letrec
        ([type-of-body (type-of body-expr tenv)]
         [new-tenv (foldl extend-tenv tenv args arg-types)])
        (check-expected-type! type-of-body body-type)
        (extend-tenv name (proc-type arg-types body-type) new-tenv)
        )
      )

    )

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

(define (proc-type->types p)
  (cases type p
    (proc-type (type-args type)
               (list type-args type))
    (else (type-mismatch-exception "proc type" p))))

;you will need to add the conversion rules from types to symbols as you add new types
;to the language
(define (type->symbol t)
  (cases type t
    (int-type () 'int)
    (bool-type () 'bool)
    (proc-type (type-args type) (list
                                  (map type->symbol type-args)
                                  '->
                                  (type->symbol type)))
    (step-type () 'step)
    (point-type () 'point)
    (else 'NO-TYPE->SYMBOL-CONVERSION-AVAILABLE)
    )
  )

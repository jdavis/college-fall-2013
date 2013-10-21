#lang racket
(#%provide (all-defined))
(#%require (lib "eopl.ss" "eopl"))
(#%require "hw06-env-values.rkt")

;===============================================================================
;========================= Lexical and Grammar Specs ===========================
;===============================================================================

(define the-lexical-spec
  '(
    (whitespace (whitespace) skip)
    (comment ("#" (arbno (not #\newline))) skip)
    (number (digit (arbno digit)) number)
    (number ("-" digit (arbno digit)) number)

    ; Add support for decimals
    (number ((arbno digit) "." digit (arbno digit)) number)
    (number ("-" (arbno digit) "." digit (arbno digit)) number)

    (identifier (letter (arbno (or letter digit "_" "-" "?"))) symbol)
    )
  )

;write your answer in string form:
(define problem-1-answer
  "The parser will break up everything into tokens based on these 4 rules:

  1. Whitespace is insignificant.

  2. A comment goes from # to a new line and is skipped.

  3. Numbers are a token that starts with either a digit or a - sign and
  followed by any number of digits. The datum type is a Racket number.

  4. Then an identifier is anything that starts with a letter and then any number
  of digits, letters, or special characters '_-?'. The datum type is a Racket
  symbol.")

(define the-grammar
  '(
    (program ((arbno expression)) a-program)

    (expression
     (number)
     num-expr)

    (expression
     ("up" "(" expression ")")
     up-expr)

    (expression
     ("down" "(" expression ")")
     down-expr)

    (expression
     ("left" "(" expression ")")
     left-expr)

    (expression
     ("right" "(" expression ")")
     right-expr)

    (expression
      ("(" expression expression ")")
      point-expr)

    (expression
      ("origin?" "(" expression ")")
      origin-expr)

    (expression
      ("line" "(" expression expression ")" "at" expression)
      line-expr)

    (expression
      ("if" "(" expression ")" "then" expression "else" expression)
      if-expr)

    (expression
      ("+" expression expression)
      add-expr)

    (expression
      ("move" "(" expression expression (arbno expression) ")")
      move-expr)

    (expression
      (identifier)
      iden-expr)

    (expression
      ("{" (arbno var-expr) (arbno expression) "}")
      block-expr)

    (var-expr
      ("val" identifier "=" expression)
      val)

    (var-expr
      ("final" "val" identifier "=" expression)
      final-val)
    ))

;given one or more arguments this function will return a flat list
(define (flat-list el1 . rest)
  (flatten (list el1 rest)))

;===============================================================================
;================================ Value-of =====================================
;===============================================================================
;value-of takes as a parameter an AST resulted from a call to the
;create-ast function.
(define (run program-string)
  (value-of (create-ast program-string) (empty-env)))

(define (value-of ast env)
  (cond
    ((program? ast) (value-of-ast-node-program ast env))
    ((var-expr? ast) (value-of-ast-node-var ast env))
    ((expression? ast) (value-of-ast-node-expression ast env))
    (else 0)))

;for each different ast node type, e.g. <program>, <expr>, <var-expr> you might
;consider implementing a function with the outline:
(define (value-of-ast-node-program ast env)
  (cases program ast
         (a-program (exprs) (last (map (lambda (x) (value-of x env)) exprs)))))

(define (value-of-ast-node-expression ast env)
  (cases expression ast
         (num-expr (num)
                   (num-val num))

         (up-expr (exp1)
                  (let ([val1 (value-of exp1 env)])
                    (step-val (up-step (num-val->n val1)))))

         (down-expr (exp1)
                  (let ([val1 (value-of exp1 env)])
                    (step-val (down-step (num-val->n val1)))))

         (left-expr (exp1)
                    (let ([val1 (value-of exp1 env)])
                      (step-val (left-step (num-val->n val1)))))

         (right-expr (exp1)
                    (let ([val1 (value-of exp1 env)])
                      (step-val (right-step (num-val->n val1)))))

         (point-expr (exp1 exp2)
                     (let ([val1 (value-of exp1 env)]
                           [val2 (value-of exp2 env)])
                       (point-val
                         (point
                           (num-val->n val1)
                           (num-val->n val2)))))

         (origin-expr (exp1)
                      (let ([p (point-val->p (value-of exp1 env))])
                        (bool-val
                          (and (= 0 (point->x p))
                               (= 0 (point->y p))))))

         (if-expr (ifexp exp1 exp2)
                  (let
                    ([ifval (value-of ifexp env)]
                     [val1 (value-of exp1 env)]
                     [val2 (value-of exp2 env)])
                    (if
                      (bool-val->b ifval)
                      val1
                      val2)))

         (add-expr (exp1 exp2)
                   (let
                     ([val1 (value-of exp1 env)]
                      [val2 (value-of exp2 env)])
                     (step-val (add-steps val1 val2))))

         (move-expr (exp1 exp2 exps)
                    (foldl
                      (lambda (x1 x2) (move-helper env x1 x2))
                      (value-of exp1 env)
                      (cons exp2 exps)))
         (line-expr (exp1 exp2 exp3)
                    (letrec
                      ([p1 (point-val->p (value-of exp1 env))]
                       [x1 (point->x p1)]
                       [y1 (point->y p1)]
                       [p2 (point-val->p (value-of exp2 env))]
                       [x2 (point->x p2)]
                       [y2 (point->y p2)]
                       [x (num-val->n (value-of exp3 env))]
                       [slope (/ (- y2 y1) (- x2 x1))])
                      (num-val
                        (+
                          (* slope x)
                          (- y1 (* slope x1))))))
         (iden-expr (iden)
                    (apply-env env iden))
         (block-expr (var-exprs exprs)
                     (cond
                       ((null? exprs) 0)
                       (else
                         (let
                           ([scope (update-env var-exprs env)])
                           (last (map (lambda (x) (value-of x scope)) exprs))))))))

(define (value-of-ast-node-var ast env)
  (cases var-expr ast
         (val (iden expr1)
              (let
                ([val1 (value-of expr1 env)])
                (extend-env-wrapper iden val1 env #f)))
         (final-val (iden expr1)
              (let
                ([val1 (value-of expr1 env)])
                (extend-env-wrapper iden val1 env #t)))))

(define (update-env vars env)
  (cond
    ((null? vars) env)
    (else
      (update-env
        (cdr vars)
        (value-of (car vars) env)))))

(define (add-steps exp1 exp2)
  (let
    ([st1 (step-val->st exp1)]
     [st2 (step-val->st exp2)]
     [st1v (single-step->n (step-val->st exp1))]
     [st2v (single-step->n (step-val->st exp2))])
    (cond
      ((and
         (left-step? st1)
         (left-step? st2))
       (left-step
         (+ st1v st2v)))
      ((and
         (up-step? st1)
         (up-step? st2))
       (up-step
         (+ st1v st2v)))
      ((and
         (right-step? st1)
         (right-step? st2))
       (right-step
         (+ st1v st2v)))
      ((and
         (down-step? st1)
         (down-step? st2))
       (down-step
         (+ st1v st2v)))
      ((and
         (up-step? st1)
         (down-step? st2))
       (cond
         ((> st1v st2v)
          (up-step (- st1v st2v)))
         (else (down-step (- st2v st1v)))))
      ((and
         (down-step? st1)
         (up-step? st2))
       (cond
         ((> st1v st2v)
          (down-step (- st1v st2v)))
         (else (up-step (- st2v st1v)))))
      ((and
         (left-step? st1)
         (right-step? st2))
       (cond
         ((> st1v st2v)
          (left-step (- st1v st2v)))
         (else (right-step (- st2v st1v)))))
      ((and
         (right-step? st1)
         (left-step? st2))
       (cond
         ((> st1v st2v)
          (right-step (- st1v st2v)))
         (else (left-step (- st2v st1v))))))))

(define (move-helper env exp1 exp2)
  (letrec
    ([step (step-val->st (value-of exp1 env))]
     [n (single-step->n step)]
     [p (point-val->p exp2)]
     [x (point->x p)]
     [y (point->y p)])
    (point-val
      (cond
        ((up-step? step) (point x (+ n y)))
        ((down-step? step) (point x (- y n)))
        ((left-step? step) (point (- x n) y))
        ((right-step? step) (point (+ n x) y))))))

;===============================================================================
;============================= sllgen boilerplate ==============================
;===============================================================================
;this will create the AST datatype with define-datatype
;according to the lexical and grammar specifications.
(sllgen:make-define-datatypes the-lexical-spec the-grammar)

;you can use this function to display the define-datatype
;expression used to generate the AST. Take some time to read it.
;you should be able to understand it by now.
(define (show-the-datatypes)
  (sllgen:list-define-datatypes the-lexical-spec the-grammar))

;create-ast is a one argument function that takes a string,
;scans & parses it and generates a resulting abstract
;syntax tree.
(define create-ast
  (sllgen:make-string-parser the-lexical-spec the-grammar))

;you can use this function to find out more about how
;the string is broken up into tokens during parsing,
;this step is automatically included in the create-ast
;function. This is a one-argument function that takes a
;string.
(define just-scan
  (sllgen:make-string-scanner the-lexical-spec the-grammar))

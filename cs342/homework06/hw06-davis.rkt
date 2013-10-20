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

    (identifier (letter (arbno (or letter digit "_" "-" "?"))) symbol)
    )
  )

;write your answer in string form:
(define problem-1-answer
  "First off, whitespace is insignificant. A comment goes from # to a new line and is skipped.
  Numbers are"
  )

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
      ("if" "(" expression ")" "then" expression "else" expression)
      if-expr)

    (expression
      ("+" expression expression)
      add-expr)

    (expression
      ("move" "(" (arbno expression) ")")
      move-expr)
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
  (value-of (create-ast program-string)))

(define (value-of ast)
  (value-of-ast-node-program ast))

;for each different ast node type, e.g. <program>, <expr>, <var-expr> you might
;consider implementing a function with the outline:
#|
(define (value-of-ast-node-type ast)
  (cases ast-node-type ast
    (ast-node-type-variant
     (f1 f2)
     'UNIMPLEMENTED
     )
    (else (raise (~a "value-of-ast-node-type error: unimplemented expression: " ast)))
    )
  )
|#
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

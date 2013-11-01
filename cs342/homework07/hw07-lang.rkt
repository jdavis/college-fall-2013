#lang racket
(#%require (lib "eopl.ss" "eopl"))
(#%provide (all-defined))

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

(define the-grammar
  '(
    (program (expr (arbno expr)) a-program)
    
    (expr (number) num-expr)
    (expr ("up" "(" expr ")") up-expr)
    (expr ("down" "(" expr ")") down-expr)
    (expr ("left" "(" expr ")") left-expr)
    (expr ("right" "(" expr ")") right-expr)
    (expr ("(" expr expr ")") point-expr)
    
    (expr ("+" expr expr) add-expr)
    (expr ("origin?" "(" expr ")") origin-expr)
    (expr ("if" "(" expr ")" "then" expr "else" expr ) if-expr)
    (expr ("move" "(" expr expr (arbno expr) ")") move-expr)
    
    (expr ("{" (arbno var-expr) (arbno expr) "}") block-expr)
    (expr (identifier) iden-expr)
    
    (var-expr ("val" identifier "=" expr) val)
    (var-expr ("final val" identifier "=" expr) final-val)
    )
  )

;===============================================================================
;============================= sllgen boilerplate ==============================
;===============================================================================
;this will create the AST datatype with define-datatype
;according to the lexical and grammar specifications.
(sllgen:make-define-datatypes the-lexical-spec the-grammar)

;you can use this function to display the define-datatype
;expression used to generate the AST.
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

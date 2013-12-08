#lang racket
(#%provide (all-defined))
(#%require (lib "eopl.ss" "eopl"))

(#%require "hw09-env-values.rkt")
(#%require "hw09-lang.rkt")

(define (std-printing-fun modifier)
  (lambda (env name-of-exp list-of-fields-as-strings) 
    (display (string-append "[" (pc->string) modifier ":"
                            name-of-exp "] \n\t"
                            (store-env->string env)"\n\t--"
                            (foldr (lambda (h t) (string-append "\n\t" h t)) "\n" list-of-fields-as-strings)))
    )
  )

(define (list-to-string lst string-builder separator)
  (define (helper lst)
    (if (null? lst)
        ""
        (to-string 
         (foldr
          (lambda (el acc)
            (to-string (string-builder el) separator acc)
            ) "" (reverse (cdr (reverse lst)))) (string-builder (last lst))))
    )
  (string-append "(" (helper lst) ")")
  )

;======================= program counter ===============================
(define the-pc 0)

(define (initialize-pc!)
  (set! the-pc 0))

(define (bump-pc!)
  (set! the-pc (+ 1 the-pc)))

(define (unbump-pc!)
  (set! the-pc (- 1 the-pc)))

(define (pc->string) (number->string the-pc))

;======================= expressed-val to string ===============================
(define (expressed-val->string val)
  (cases expressed-val val
    (num-val (num) (number->string num))
    (bool-val (b) (if b "#t" "#f"))
    (step-val (st) (single-step->string st))
    (point-val (p) (point->string p))
    (proc-val (p) (proc->string p))
    )
  )

(define (single-step->string st)
  (cases step st
    (up-step (n) (to-string "up("n")"))
    (down-step (n) (to-string "down("n")"))
    (left-step (n) (to-string "left("n")"))
    (right-step (n) (to-string "right("n")"))
    (else (to-string "No debug info for step: " st))
    )
  )

(define (point->string p)
  (to-string "("(point->x p) " " (point->y p) ")")
  )

(define (proc->string p)
  (cases proc p
    (procedure (args body saved-env)
               (string-append (list-to-string args symbol->string " ") "->" (ast->string body)" with env=" (env->string saved-env))))
  )

;=============================== env to string =================================
(define (empty-env? env)
  (if (environment? env)
      (cases environment env
        (empty-env () #t)
        (else #f)
        )
      #f
      )
  )

(define (env->string env)
  (letrec ((env-string-helper 
            (lambda (env)
              (cases environment env
                (empty-env () "")
                (extend-env (var val saved-env)
                            (if (empty-env? saved-env) (string-append (symbol->string var) "=" (reference->string val))
                                (string-append (symbol->string var) "=" (reference->string val) ", " (env-string-helper saved-env))))
                (extend-env-final (var val saved-env)
                                  (if (empty-env? saved-env) (string-append (symbol->string var) "=" (reference->string val))
                                      (string-append (symbol->string var) "=" (reference->string val) ", " (env-string-helper saved-env))))
                ))))
    (string-append "{" (env-string-helper env) "}")))


;========================== store to string ===============================
;; reference->string: Ref -> String
(define (reference->string r)
  (string-append "loc:" (number->string r)))

(define (store->string)
  (if (equal? the-store 'uninitialized)
      "uninitialized"
      ;we transform the store to a list of strings of the format index:value-flag
      (let ([store-ref-val-pair 
             (map (lambda (value index)
                    (to-string index ":" (expressed-val->string value)))
                  the-store
                  (range (length the-store)))])
        
        (to-string "{"(string-join store-ref-val-pair) "}")
        )
      )
  )

(define (store-env->string env)
  (string-append "store = " (store->string) "\n\tenv   = " (env->string env)))

;========================== DEBUG INFO FOR AST ===============================
(define (debug-ast ast env printing-fun)
  (cond 
    [(program? ast) (debug-program ast env printing-fun)]
    [(expr? ast) (debug-expr ast env printing-fun)]
    [(var-expr? ast) (debug-var ast env printing-fun)]
    [else (to-string "No debug info for ast node: " ast)]
    )
  )

;=================================== debug-program =======================================
(define (debug-program prog env printing-fun)
  (cases program prog
    (a-program
     (fun-defs expr rest-of-expressions)
     (printing-fun env "program" '())
     )
    )
  )

;=================================== debug-expr =======================================
(define (debug-expr ex env printing-fun)
  (or (expr? ex) (raise (string-append "value-of-expr error: expected an expression, got " (to-string ex))))
  (cases expr ex
    (num-expr (n) (printing-fun env "num-expr" (list (to-string "n = " n))))
    
    (up-expr
     (num)
     (printing-fun env "up-expr" (list (to-string "n = " (ast->string num)))))
    
    (down-expr
     (num)
     (printing-fun env "down-expr" (list (to-string "n = " (ast->string num)))))
    
    (left-expr
     (num)
     (printing-fun env "down-expr" (list (to-string "n = " (ast->string num)))))
    
    (right-expr
     (num)
     (printing-fun env "right-expr" (list (to-string "n = " (ast->string num)))))
    
    (iden-expr
     (var-name)
     (printing-fun env "iden-expr" (list (to-string "iden = " var-name))))
    
    (point-expr
     (x y)
     (printing-fun env "point-expr" (list (to-string "x = " (ast->string x))
                                          (to-string "y = " (ast->string y))))
     )
    
    (move-expr
     (point-expr first-move rest-of-moves)
     (printing-fun env "move-expr" (list (to-string "point = " (ast->string point-expr))
                                         (to-string "first-move = " (ast->string first-move))
                                         (to-string "rest-of-move = " (list-to-string rest-of-moves ast->string ", "))))
     )
    
    (add-expr
     (lhs rhs)
     (printing-fun env "add-expr" (list (to-string "lhs = " (ast->string lhs))
                                        (to-string "rhs = " (ast->string rhs))))
     )
    
    (origin-expr 
     (p-expr)
     (printing-fun env "origin-expr" (list (to-string "point = " (ast->string p-expr))))
     )
    
    (if-expr 
     (cond then-exp else-exp)
     (printing-fun env "if-expr" (list (to-string "condition = "(ast->string cond)) 
                                       (to-string "then-exp = "(ast->string then-exp))
                                       (to-string "else-exp = "(ast->string else-exp)))
                   )
     )
    
    (block-expr
     (list-of-var-decl list-of-expr)
     (printing-fun env "block-expr" (list (to-string "var declarations = " (list-to-string list-of-var-decl ast->string ";")) 
                                          (to-string "expressions = "(list-to-string list-of-expr ast->string "; ")))
                   )
     )
    
    (fun-expr
     (vars-expr body-expr)
     (printing-fun env "fun-expr"
                   (list (to-string "args = " (list-to-string vars-expr symbol->string " ")) 
                         (to-string "body = " (ast->string body-expr)))
                   )
     )
    
    (fun-call-expr
     (fun-exp argv-expr)
     (printing-fun env "fun-call-expr"
                   (list (to-string "function  = " (ast->string fun-exp)) 
                         (to-string "arguments = " (list-to-string argv-expr ast->string " ")))
                   )
     )
    
    (set-expr
     (var-name val-expr)
     (printing-fun env "set-expr"
                   (list (to-string "var name  = " var-name) 
                         (to-string "var value = " (ast->string val-expr)))
                   )
     )
    
    (else (to-string "debug-expr error: no debug information for: " ex))
    )
  )

;=================================== debug-var =======================================
(define (debug-var v-ex env printing-fun)
  (or (var-expr? v-ex) (invalid-args-exception "value-of-var" "var-expr?" v-ex))
  (cases var-expr v-ex
    (val
     (iden val-of-iden)
     (printing-fun env "val" (list (to-string "name  = " iden )
                                   (to-string "value = " (ast->string val-of-iden)))))
    
    (final-val
     (iden val-of-iden)
     (printing-fun env "final-val" (list (to-string "name  = " iden )
                                         (to-string "value = " (ast->string val-of-iden)))))
    
    (def-fun
      (fun-name fun-params body)
      (printing-fun env "fun-exp"
                    (list (to-string "name = " (list-to-string fun-name symbol->string " "))
                          (to-string "args = " (list-to-string fun-params symbol->string " ")) 
                          (to-string "body = " (ast->string body)))
                    )
      )
    (else (to-string "debug-var error: no debug information for: " v-ex))
    )
  )
;========================== AST TO STRING ===============================
(define (ast->string ast)
  (cond 
    [(program? ast) (program->string ast)]
    [(expr? ast) (expr->string ast)]
    [(var-expr? ast) (var->string ast)]
    [else (to-string "no string representation for ast node: " ast)]
    )
  )

(define (program->string prog)
  (cases program prog
    (a-program
     (fun-defs expr rest-of-expressions)
     (to-string "program")
     )
    )
  )

;=================================== expr->string =======================================
(define (expr->string ex)
  (or (expr? ex) (raise (string-append "value-of-expr error: expected an expression, got " (to-string ex))))
  (cases expr ex
    (num-expr (n) (to-string n))
    
    (up-expr
     (num)
     (to-string "up(" (ast->string num) ")") )
    
    (down-expr
     (num)
     (to-string "down(" (ast->string num) ")"))
    
    (left-expr
     (num)
     (to-string "left(" (ast->string num) ")"))
    
    (right-expr
     (num)
     (to-string "right(" (ast->string num) ")"))
    
    (iden-expr
     (var-name)
     (to-string var-name))
    
    (point-expr
     (x y)
     (to-string "(" (ast->string x) " " (ast->string y) ")")
     )
    
    (move-expr
     (point-expr first-move rest-of-moves)
     (to-string "move" "(" (ast->string point-expr) " " (list-to-string (flat-list first-move rest-of-moves) ast->string " ") ")")
     )
    
    (add-expr
     (lhs rhs)
     (to-string "+ " (ast->string lhs) " " (ast->string rhs))
     )
    
    (origin-expr 
     (p-expr)
     (to-string "origin?(" (ast->string p-expr) ")")
     )
    
    (if-expr 
     (cond then-exp else-exp)
     (to-string "if(" (ast->string cond) "then " (ast->string then-exp) (ast->string else-exp))
     )
    
    (block-expr
     (list-of-var-decl list-of-expr)
     (to-string "{"(list-to-string list-of-var-decl ast->string ";/n") (list-to-string list-of-expr ast->string "/n") "}")
     )
    
    (fun-expr
     (vars-expr body-expr)
     (to-string "fun" (to-string vars-expr) "=" (ast->string body-expr))
     )
    
    (fun-call-expr
     (fun-exp argv-expr)
     (to-string "call " (ast->string fun-exp) (ast->string argv-expr))
     )
    
    (set-expr
     (var-name val-expr)
     (to-string "set(" var-name (ast->string val-expr))
     )
    
    (else (to-string "expr->string error: no string representation for: " ex))
    )
  )

;=================================== debug-var =======================================
(define (var->string v-ex)
  (or (var-expr? v-ex) (invalid-args-exception "value-of-var" "var-expr?" v-ex))
  (cases var-expr v-ex
    (val
     (iden val-of-iden)
     (to-string "val " iden " = " (ast->string val-of-iden)))
    
    (final-val
     (iden val-of-iden)
     (to-string "final val " iden " = " (ast->string val-of-iden)))
    
    (def-fun
      (fun-name fun-params body)
      (to-string "def " fun-name "( " fun-params")" " = " (ast->string body))
      )
    (else (to-string "var->string error: no string representation for: " v-ex))
    )
  )
#lang racket
(#%provide (all-defined))
(#%require (lib "eopl.ss" "eopl"))

(#%require "hw08-lang.rkt")
(#%require "hw08-env-values.rkt")

;==================================== run ======================================
(define (run program-string . argument-strings)
  (define (create-arg-sym index)
    (string->symbol (string-append "arg" (number->string index)))
    )


  (initialize-store!)
  (or (string? program-string) (raise (to-string "expected a program as string, got: " program-string)))

  (for-each
   (lambda (arg)
     (or (string? arg) (raise (to-string "argument should be a string, got: " arg))))
   argument-strings)

  (letrec
      ([argument-asts (map create-ast argument-strings)]
       [argument-values (map (lambda (arg) (value-of arg (empty-env))) argument-asts)]
       [initial-env
        (extend-env-multiple-times
         (map create-arg-sym (range (length argument-values)))
         argument-values
         (empty-env)
         FINAL
         )])
    (value-of (create-ast program-string) initial-env)
    )
  )

;===============================================================================
;================================ value-of =====================================
;===============================================================================
(define (value-of ast env)
  (cond
    [(program? ast) (value-of-program ast env)]
    [(expr? ast) (value-of-expr ast env)]
    [(var-expr? ast) (value-of-var ast env)]
    [else (raise (to-string "Unimplemented ast node: " ast))]
    )
  )

;================================= program =====================================
(define (value-of-program prog env)
  (cases program prog
    (a-program
     (fun-defs expr rest-of-expressions)
     (let ([new-env (foldl value-of env fun-defs)])
       (andmap (lambda (ex) (value-of ex new-env))
               (flat-list expr rest-of-expressions))
       )
     )
    )
  )

;=================================== expr =======================================
(define (value-of-expr ex env)
  (or (expr? ex) (raise (string-append "value-of-expr error: expected an expression, got " (to-string ex))))
  (cases expr ex
    (num-expr (n) (num-val n))

    (up-expr
     (num)
     (step-val (up-step (num-val->n (value-of num env)))))

    (down-expr
     (num)
     (step-val (down-step (num-val->n (value-of num env)))))

    (left-expr
     (num)
     (step-val (left-step (num-val->n (value-of num env)))))

    (right-expr
     (num)
     (step-val (right-step (num-val->n (value-of num env)))))

    (iden-expr
     (var-name)
     (apply-env env var-name))

    (point-expr
     (x y)
     (point-val (point (num-val->n (value-of x env)) (num-val->n (value-of y env))))
     )

    (move-expr
     (point-expr first-move rest-of-moves)
     (letrec
         ([start-p (point-val->p (value-of point-expr env))]
          [all-moves-as-expr (map (lambda (ex) (value-of ex env)) (flat-list first-move rest-of-moves))]
          [all-moves-step (map step-val->st all-moves-as-expr)]
          [final-p (foldl move start-p all-moves-step)])
       (point-val final-p)
       )
     )

    (add-expr
     (lhs rhs)
     (letrec
         ([l-step-val (value-of lhs env)]
          [r-step-val (value-of rhs env)]
          [l-step (step-val->st l-step-val)]
          [r-step (step-val->st r-step-val)]
          [res (+ (get-axis-value l-step) (get-axis-value r-step))])
       (cond
         [(and (valid-steps-for-add? l-step r-step)
               (or (left-step? l-step) (right-step? l-step)))
          (get-horizontal-step res)
          ]
         [(and (valid-steps-for-add? l-step r-step) (or (up-step? l-step) (down-step? l-step)))
          (get-vertical-step res)
          ]
         [else (raise "invalid args in add")]
         )
       )
     )

    (origin-expr
     (p-expr)
     (bool-val (equal? (point-val->p (value-of p-expr env)) (point 0 0)))
     )

    (if-expr
     (cond then-exp else-exp)
     (let
         ([c-val (bool-val->b (value-of cond env))])
       (if c-val
           (value-of then-exp env)
           (value-of else-exp env))
       )
     )

    (block-expr
     (list-of-var-decl list-of-expr)
     (let ([new-env (foldl value-of env list-of-var-decl)])
       (andmap (lambda (ex) (value-of ex new-env))
               list-of-expr)
       )
     )

    (fun-expr
     (vars-expr body-expr)
     (proc-val (procedure vars-expr body-expr env))
     )

    (recfun-expr
      (vars-expr body-expr)
      (let
        ([rec-env (extend-env-rec 'self vars-expr body-expr env)])
        (proc-val (procedure vars-expr body-expr rec-env))))

    (fun-call-expr
     (fun-exp argv-expr)
     (letrec
         ([fun (proc-val->proc (value-of fun-exp env))]
          [var-names (proc->vars fun)]
          ;we evaluate the values of the parameters in the current environment
          [argument-values (map (lambda (x) (value-of x env)) argv-expr)]
          [fun-body (proc->body fun)]
          [closure-env (proc->env fun)]
          ;we extend the environment in which the function was created with all
          ;the paramater names -> values pairs.
          [new-env
           (begin
             (or (equal? (length var-names) (length argument-values))
                 (raise (to-string "arity mismatch. expected "(length var-names) " arguments, received " (length argument-values))))
             (extend-env-multiple-times var-names argument-values closure-env NON-FINAL)
             )])

       (value-of fun-body new-env)
       )
     )

    (new-ref-expr
      (ref-expr)
      (let
        ([val (value-of ref-expr env)])
        (ref-val (newref val))))

    (deref-expr
      (ref-expr)
      (deref (value-of ref-expr env)))

    (set-ref-expr
      (ref-expr ref-value)
      (setref!
        (value-of ref-expr env)
        (value-of ref-value env)))

    (inc-ref-expr
      (ref-expr)
      '()
      )

    (dec-ref-expr
      (ref-expr)
      '()
      )

    (else (raise (to-string "value-of-expr error: unimplemented expression: " ex)))
    )
  )

(define (extend-env-multiple-times list-of-syms list-of-vals init-env final?)
  (foldl
   (lambda (arg-sym arg-val env)
     (extend-env-wrapper arg-sym arg-val env final?)
     )
   init-env
   list-of-syms
   list-of-vals
   )
  )

(define (move st start-p)
  (cases step st
    (up-step (st)
             (point (point->x start-p) (+ (point->y start-p) st)))

    (down-step (st)
               (point (point->x start-p) (- (point->y start-p) st)))

    (left-step (st)
               (point ( - (point->x start-p) st) (point->y start-p)))

    (right-step (st)
                (point ( + (point->x start-p) st) (point->y start-p)))
    )
  )
;========================= helpers for add ================================
(define (valid-steps-for-add? st1 st2)
  (or
   (and (up-step? st1) (up-step? st2))
   (and (down-step? st1) (down-step? st2))
   (and (up-step? st1) (down-step? st2))
   (and (down-step? st1) (up-step? st2))

   (and (left-step? st1) (left-step? st2))
   (and (right-step? st1) (right-step? st2))
   (and (left-step? st1) (right-step? st2))
   (and (right-step? st1) (left-step? st2))
   )
  )

(define (get-axis-value st)
  (cases step st
    (up-step (st) st)
    (down-step (st) (* -1 st))
    (left-step (st) (* -1 st))
    (right-step (st) st)
    )
  )

(define (get-vertical-step num)
  (if (positive? num)
      (step-val (up-step num))
      (step-val (down-step (* -1 num)))
      )
  )

(define (get-horizontal-step num)
  (if (positive? num)
      (step-val (right-step num))
      (step-val (left-step (* -1 num)))
      )
  )
;=================================== var =======================================
(define (value-of-var v-ex env)
  (or (var-expr? v-ex) (invalid-args-exception "value-of-var" "var-expr?" v-ex))
  (cases var-expr v-ex
    (val
     (iden val-of-iden)
     (extend-env-wrapper iden (value-of val-of-iden env) env NON-FINAL))

    (final-val
     (iden val-of-iden)
     (extend-env-wrapper iden (value-of val-of-iden env) env FINAL))

    (def-fun
      (fun-name fun-params body)
      (let
        ([rec-env (extend-env-rec fun-name fun-params body env)])
        (extend-env-wrapper fun-name (proc-val (procedure fun-params body rec-env)) env FINAL))
      )
    (else (raise (to-string "value-of-var error: unimplemented expression: " v-ex)))
    )
  )

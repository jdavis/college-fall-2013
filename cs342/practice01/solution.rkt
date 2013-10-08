; Practice Exam Solutions

(define (one-star-one-plus prev-sym)
  (if (equal? prev-sym '+)
    '*
    '+))

(define (triangle-pattern size next-sym init-sym)
  (define (prepend-sym lst)
    ;(display "List: ")
    ;(displayln lst)
    (let ([sym (next-sym init-sym)])
      (cons init-sym lst)))
  (cond
    ((= size 1) (list (list init-sym)))
    (else
      (append
        (list (list init-sym))
        (map prepend-sym (triangle-pattern
                           (- size 1)
                           next-sym
                           (next-sym init-sym)))
        (list (list init-sym))))))

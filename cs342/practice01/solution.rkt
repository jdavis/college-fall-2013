;
; Practice Exam Solutions
;

; Problem 1
(define (one-star-one-plus prev-sym i)
  (if (equal? prev-sym '+)
    '*
    '+))

(define (triangle-pattern size next-sym init-sym)
  (define (prepend-sym lst)
      (cons init-sym lst))
  (cond
    ((= size 1) (list (list init-sym)))
    (else
      (append
        (list (list init-sym))
        (map prepend-sym (triangle-pattern
                           (- size 1)
                           next-sym
                           (next-sym init-sym size)))
        (list (list init-sym))))))

; Problem 1 Output Testing
(displayln (triangle-pattern 1 one-star-one-plus '*))
(displayln (triangle-pattern 2 one-star-one-plus '*))
(displayln (triangle-pattern 3 one-star-one-plus '*))
(displayln (triangle-pattern 4 one-star-one-plus '*))

; Problem 2a
(define (node sym)
  (lambda (left)
    (lambda (right)
      (list sym left right))))

; Problem 2b
(define solution
  (((node 'top) 2) 3))

; Problem 2b Output Testing
(displayln (equal?
             solution
             (list 'top 2 3)))

; Problem 3
(define (get-last-name lst)
  (cond
    ((null? lst) '())
    (else
      (cons
        (caddar lst)
        (get-last-name (cdr lst))))))

; Problem 3 Output Testing
(define solution '("Kennedy" "Churchill"))
(define fixture '(("John" "F" "Kennedy") ("Winston" "S" "Churchill")))
(define answer (get-last-name fixture))
(displayln (equal?  solution answer))

; Problem 4
(define x '((a . b) (c d e) f g))

(displayln (eq? (cdar x) 'b))
(displayln (eq? (caddr x) 'f))
(displayln (eq? (cadddr x) 'g))
(displayln (equal? (cdadr x) '(d e)))
(displayln (equal? (cddadr x) '(e)))

; Problem 5
(define (leaf-node number)
  (lambda (n)
    (equal? n number)))

(define (interior-node left right)
  (lambda (n)
    (or
      (left n)
      (right n))))

(define (number-exists? tree n)
  (tree n))

; Problem 5 Output Testing
(displayln (eq? #f
                (number-exists? (leaf-node 4) 5)))
(displayln (eq? #t
                (number-exists? (interior-node (leaf-node 4) (leaf-node 5)) 5)))

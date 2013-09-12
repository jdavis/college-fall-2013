#lang racket
(#%provide (all-defined))

#|
If there are any specific instructions for a problem, please read them carefully. Otherwise,
follow these general rules:
   - replace the 'UNIMPLEMENTED symbol with your solution
   - you are NOT allowed to change the names of any definition
   - you are NOT allowed to change the number of arguments of the pre-defined functions,
     but you can change the names of the arguments if you deem it necessary.
   - make sure that you submit an asnwer sheet that compiles! If you cannot write
     a correct solution at least make it compile, if you cannot make it compile then
     comment it out. In the latter case, make sure that the default definitions
     for the problem are still present. Otherwise you may be penalized up to 25%
     of the total points for the homework.
   - you may use any number of helper functions you deem necessary.

When done, make sure that you do not get any errors when you hit the "Run" button. You will
lose up to 25% of the total points for the entire homework depending on the number of errors.
If you cannot come up with a correct solution then please make the answer-sheet
compile correctly and comment any partial solution you might have; if this is the case,
the default definitions will have to be present!
|#
;======================================01=======================================
(define (list-of-even-numbers? lst)
  (cond
    ((not (list? lst)) #f)
    ((null? lst) #t)
    ((and
       (number? (car lst))
       (even? (car lst))) (list-of-even-numbers? (cdr lst)))
    (else #f)))

;======================================02=======================================
;;for n > 0
;Sn = 1/1 + 1/4 + 1/9 + 1/16 + ...
(define (series-a n)
  (define (series-a-iter result iter limit)
    (let ([x (/ 1 (* iter iter))])
        (cond
          ((<= iter 0) 0)
          ((> iter limit) result)
          (else
            (series-a-iter
            (+ result x)
            (+ iter 1)
            n)))))
  (series-a-iter 0 1 n))

;====
;;for n >= 0
;Sn = 1 - 1/2 + 1/6 - 1/24 + ...
(define (series-b n)
  (define (pow a b)
    (define (pow-iter result iter)
      (cond
        ((= iter 0) result)
        (else
          (pow-iter (* result a) (- iter 1)))))
    (pow-iter 1 b))
  (define (factorial n)
    (define (fact-iter result iter)
      (cond
        ((= iter 0) result)
        (else
          (fact-iter (* result iter) (- iter 1)))))
    (fact-iter 1 n))
  (define (series-b-iter result iter)
    (cond
      ((> iter n) result)
      (else
        (let
          ([x (/ (pow -1 iter) (factorial (+ iter 1)))])
          (series-b-iter (+ x result) (+ iter 1))))))
  (series-b-iter 0 0))

;======================================03=======================================
(define (carpet n)
  (define (multiple sym iter)
    (cond
      ((= iter -1) '())
      (else (cons sym (multiple sym (- iter 1))))))
  (define (surround sym result)
    (cond
      ((null? result) '())
      (else
        (cons
          (append (list sym)
                  (car result)
                  (list sym))
          (surround sym (cdr result))))))
  (define (carpet-iter iter result)
    (cond
      ((= iter n) result)
      (else
        (let ([sym (if (even? iter) '+ '%)]
              [l (* 2 (+ iter 1))])
          (carpet-iter (+ iter 1)
                       (append
                         (list (multiple sym l))
                         (surround sym result)
                         (list (multiple sym l))))))))
  (carpet-iter 0 '((%))))

;======================================04=======================================
(define (sort-ascend loi)
  (define (merge first second)
    (cond
      ((null? first) second)
      ((null? second) first)
      ((< (car first) (car second))
       (cons
         (car first)
         (merge (cdr first) second)))
      (else
       (cons
         (car second)
         (merge first (cdr second))))))
  (let ([mid (quotient (length loi) 2)])
    (cond
      ((= mid 0) loi)
      (else
        (merge
          (sort-ascend (take loi mid))
          (sort-ascend (drop loi mid)))))))

;======================================05=======================================
(define (balanced? in)
  (define (balanced-iter lst count state)
    (cond
      ((null? lst) (= count 0))
      ((char=? #\( (car lst))
       (balanced-iter (cdr lst) (+ count 1) 1))
      ((char=? #\) (car lst))
       (cond
         ((= state 0) #f)
         (else
           (balanced-iter
             (cdr lst)
             (- count 1)
             (if (= count 1) 0 1)))))
      (else
        (balanced-iter
          (cdr lst)
          count
          state))))
  (balanced-iter (string->list in) 0 0))

;======================================06=======================================
(define (list-of-all? predicate lst)
  (cond
    ((null? lst) #t)
    ((predicate (car lst))
     (list-of-all? predicate (cdr lst)))
    (else #f)))

;======================================07=======================================
(define (create-mapping keys vals)
  (define (found iter index lst)
    (cond
      ((= iter index) (car lst))
      (else
        (found (+ iter 1) index (cdr lst)))))
  (define (find key index lst)
    (cond
      ((null? lst) (raise (string-append "Could not find mapping for symbol " (symbol->string key))))
      ((eq? key (car lst)) (found 0 index vals))
      (else
        (find key (+ index 1) (cdr lst)))))
  (lambda
    (key)
    (find key 0 keys)))

(define roman-numerals-keys '(I II III IV V))
;values
(define arabic-numerals-vals '(1 2 3 4 V))
(define roman-to-arabic (create-mapping roman-numerals-keys arabic-numerals-vals))
(roman-to-arabic 'I)
(roman-to-arabic 'V)
(roman-to-arabic 'some-symbol)

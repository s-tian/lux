(define (ray o d)
  (list o d)
)

(define (ray-o r)
  (car r)
)

(define (ray-d r)
  (car (cdr r))
)

(define (sphere center radius color type)
  (list center radius color type)
)

(define (sph-center s)
  (car s)
)

(define (sph-radius s)
  (car (cdr s))
)

(define (sph-color s)
  (car (cdr (cdr s)))
)

(define (sph-type s)
  (car (cdr (cdr (cdr s))))
)

;; Computes ray sphere intersection
;; Returns distance to intersection point or -1 if no intersection
(define (intersect s r)
  (define otos (vec-sub (sph-center s) (ray-o r)))
  (define rT (vec-dot otos (ray-d r)))
  (define l (- (expt (sph-radius s) 2) (- (vec-dot otos otos) (* rT rT))))
  (if (< l 0)
    -1
    (begin
     (define res (- rT (expt l 0.5)))
     (if (< res 0)
       (+ rT (expt l 0.5))
       res
     ))))

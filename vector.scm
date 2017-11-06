
;; sin and cos using Taylor series approximation

(define (sin x)
  (+ x (- (/ (expt x 3) 6)) (/ (expt x 5) 120) (- (/ (expt x 7) 5040)))
)

(define (cos x)
  (+ 1 (- (/ (expt x 2) 2)) (/ (expt x 4) 24) (- (/ (expt x 6) 720)) (/ (expt x 8) 40320))
)

;; Make vector abstraction 

(define (vec3 x y z)
  (list x y z)
)

(define (vec-x v)
  (car v)
)

(define (vec-y v)
  (car (cdr v))
)

(define (vec-z v)
  (car (cdr (cdr v)))
)

(define (vec-oper v1 v2 op)
 (cond
    ((list? v2) (vec3 
                  (op (vec-x v1) (vec-x v2)) 
                  (op (vec-y v1) (vec-y v2)) 
                  (op (vec-z v1) (vec-z v2))
                ))
    ;; v2 is a number, not a vector
    (else (vec3 (op (vec-x v1) v2) (op (vec-y v1) v2) (op (vec-z v1) v2)))
  )
)

;; vec-add first operand must be a vector

(define (vec-add v1 v2)
  (vec-oper v1 v2 +)
)

;; vec-sub first operand must be a vector

(define (vec-sub v1 v2)
  (vec-oper v1 v2 -)
)

;; vec-mul first operand must be a vector

(define (vec-mul v1 v2)
  (vec-oper v1 v2 *)
)

(define (sum-list l total)
  (cond
    ((null? l) total)
    (else (sum-list (cdr l) (+ total (car l))))
  )
)

(define (vec-dot v1 v2)
  (sum-list (vec-mul v1 v2) 0)
)

(define (vec-len v)
  (expt (+ (expt (vec-x v) 2) (expt (vec-y v) 2) (expt (vec-z v) 2)) 0.5)
)

;; unit vector

(define (vec-u v)
  (define l (vec-len v))
  (vec3 (/ (vec-x v) l) (/ (vec-y v) l) (/ (vec-z v) l))
)



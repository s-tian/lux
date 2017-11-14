; random number generator implementation

(define (random-generator seed)
  (define (rng)
    (set! seed (modulo (+ (* 16807 seed) 0) 2147483647))
    (/ seed 2147483647)
  )
  rng
)

(define random
  (random-generator 61616161) ;; Seed the random number generator
)

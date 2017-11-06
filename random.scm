; random number generator implementation

(define (random-generator seed)
  (define (rng)
    (set! seed (modulo (+ (* 1103515245 seed) 12345) 2147483648))
    (/ seed 2147483648)
  )
  rng
)

(define random
  (random-generator 61616161) ;; Seed the random number generator
)

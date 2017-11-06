;; Returns a pair of the closest object and the distance to it

(define (intersect-list objects r)
  (if (null? objects)
    (list -1 (expt 2 32)) ;; Return -1 object and max distance
    
    ;; Compute closest in rest of list
    (begin
     (define closest (intersect-list (cdr objects) r))
     ;; Get distance to first object
     (define dist (intersect (car objects) r))
     
     ;; If we are closer
     (if (> (car (cdr closest)) dist)
       ;; If we get no intersection or too close
       (if (< dist 0.00001)
         closest ;; Return closest of rest of list
         (list (car objects) dist) ;; Otherwise new closest
       )
       closest
     ))))

(define (schlick cosine ref_idx)
  (define r0 (/ (- 1 ref_idx) (+ 1 ref_idx)))
  (define r0 (* r0 r0))
  (+ (* (- 1 r0) (expt (- 1 cosine) 5))))

;; Shoots ray r into the scene of objects

(define (shoot r objects depth color)
  (if (= depth 7) ;; if we reach maximum allowed recusion depth
    (vec3 0 0 0)  ;; return no light
    (begin
     (define closest (intersect-list objects r))
     (if (equal? (car closest) -1)
       (vec3 0 0 0) ;; If no hit return black (background color)
       (begin
        (define impact (vec-add (vec-mul (ray-d r) (car (cdr closest))) (ray-o r)))
        (define normal (vec-u (vec-sub impact (sph-center (car closest)))))
        (define refRay (ray impact (vec-sub (ray-d r) 
                                            (vec-mul normal (* 2 (vec-dot (ray-d r) normal))))))
        (cond
          ((equal? (sph-type (car closest)) 'DIFFUSE)
           (define target (vec-add normal (random-in-unit-sphere)))
           (shoot (ray impact (vec-u target))
                  objects
                  (+ depth 1)
                  (vec-mul color (sph-color (car closest)))))
          ((equal? (sph-type (car closest)) 'MIRROR)
           (shoot refRay objects (+ depth 1) (vec-mul color (sph-color (car closest)))))
          ((equal? (sph-type (car closest)) 'EMITTER)
           (vec-mul color (sph-color (car closest))))
          (else 
            (define ref_idx 1.5)
            (if (> (vec-dot (ray-d r) normal) 0)
              (begin
                (define outward_normal (vec-mul normal -1))
                (define nint ref_idx)
                (define cosine (vec-dot (ray-d r) normal))
                (define cosine (expt (- 1 (* ref_idx ref_idx (- 1 (* cosine cosine)))) 0.5))
               )
              (begin
                (define outward_normal normal)
                (define nint (/ 1 ref_idx))
                (define cosine (* -1 (vec-dot (ray-d r) normal)))
               )
              )
            (define dt (vec-dot (ray-d r) outward_normal))
            (define discr (- 1 (* nint nint (- 1 (* dt dt)))))
            (if (> discr 0)
              (begin
                (define refracted (vec-sub (vec-mul (vec-sub (ray-d r) (vec-mul outward_normal dt))
                                                    nint)
                                           (vec-mul outward_normal (expt discr 0.5))))
                (define reflect_prob (schlick cosine ref_idx)))
              (define reflect_prob 1))
            (if (< (random) reflect_prob)
              (shoot refRay objects (+ 1 depth) (vec-mul color (sph-color (car closest))))
              (shoot (ray impact refracted) objects (+ 1 depth) (vec-mul color (sph-color (car closest)))))
            )
         ))))))

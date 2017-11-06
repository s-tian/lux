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
           (define target (vec-add (vec-add impact normal) (random-in-unit-sphere)))
           (shoot (ray impact (vec-u (vec-sub target impact)))
                  objects
                  (+ depth 1)
                  (vec-mul color (sph-color (car closest)))))
          ((equal? (sph-type (car closest)) 'MIRROR)
           (shoot refRay objects (+ depth 1) (vec-mul color (sph-color (car closest)))))
          ((equal? (sph-type (car closest)) 'EMITTER)
           (vec-mul color (sph-color (car closest))))
          (else '(glass))
         ))))))

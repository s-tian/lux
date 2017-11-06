;; Main raytracing logic

(load 'random)
(load 'vector)
(load 'ray)
(load 'sphere)
(load 'shoot)

;; Generates a random vector in the unit sphere recursively

(define (random-in-unit-sphere)
  (define v (vec-sub (vec-mul (vec3 (random) (random) (random)) 2) 1))
  (if (< (vec-len v) 1.0)
    v
    (random-in-unit-sphere)
  )
)

(define (min a b)
  (if (< a b) a b)
)

(define (color-adj color) ;; Color gamma correction and coercion into turtle rgb
  (rgb (expt (min (vec-x color) 1) 0.5)
       (expt (min (vec-y color) 1) 0.5)
       (expt (min (vec-z color) 1) 0.5)
  )
)

(define (draw)
  (pixelsize 5) 
  (define width 20)
  (define height 20)

  ;; Do sphere initialization here
  (define spheres ())
  (define spheres (cons (sphere (vec3 0 0 10001) 10000 (vec3 0.9 0.9 0.9) 'diffuse) spheres))
  (define spheres (cons (sphere (vec3 0 10001 0) 10000 (vec3 0.9 0.9 0.9) 'diffuse) spheres))
  (define spheres (cons (sphere (vec3 0 -10001 0) 10000 (vec3 0.9 0.9 0.9) 'diffuse) spheres))
  (define spheres (cons (sphere (vec3 10001 0 0) 10000 (vec3 0.75 0.25 0.25) 'diffuse) spheres))
  (define spheres (cons (sphere (vec3 -10001 0 0) 10000 (vec3 0.25 0.75 0.25) 'diffuse) spheres))
  (define spheres (cons (sphere (vec3 -0.4 -0.6 0) 0.4 (vec3 1 1 1) 'mirror) spheres))
  (define spheres (cons (sphere (vec3 0.4 -0.6 -0.2) 0.3 (vec3 1 1 1) 'diffuse) spheres))
  (define spheres (cons (sphere (vec3 0 10.98 0) 10 (vec3 5 5 5) 'emitter) spheres))

  ;; light position, camera position

  (define cam-pos (vec3 0 0 -5))
  (define fov 60) ;; width angle
  (define fov (* fov (/ 3.14159265 180))) ;; convert to rad
  (define ratio (/ height width))
  (define xtan 0.5773502692) ;; hardcoded for 60 degrees
  (define ytan (* xtan ratio))

  (define num-samples 4) 
  (define max-pos (- (* width height) 1))

  ;; xtan, ytan

  (define (draw-pixel pos) ;; pos = total_height*w + h
    (define x (quotient pos height))
    (define y (modulo pos height))
    (define shot-ray (vec3 0 0 0))

    ;; sample gives the result of several rays averaged
    (define (sample i vec)
      (cond
        ((= i num-samples) vec)
        (else (define vx (* (/ (+ x -0.5 (random) (* -0.5 width)) width) xtan))
              (define vy (* (/ (- (* 0.5 height) (+ y -0.5 (random))) height) ytan))

              (define v (vec3 vx vy 1))
              (define v (vec-u v))
              (define r (ray cam-pos v))

              (sample (+ i 1) (vec-add vec (shoot r spheres 0 (vec3 1 1 1)))) ;; shoot ray
        )
      )
    )
    (define sampled (vec-mul (sample 0 (vec3 0 0 0)) (/ 1 num-samples)))
    (display sampled)

    (pixel (+ x 1) (- height y) (color-adj sampled)) ;; Draw the pixel

    (if (> (+ 1 pos) max-pos)
        0
        (draw-pixel (+ 1 pos))
    )
  )

  (draw-pixel 0) ;; Start drawing pixels from 0, 0
)



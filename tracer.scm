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
  (rgb (expt (min (vec-x color) 1) 0.5) ;; Browser takes in from 0 - 255
       (expt (min (vec-y color) 1) 0.5) ;; Python interpreter takes 0 - 1
       (expt (min (vec-z color) 1) 0.5)
  )
)

(define (draw)
  (ht) ;; Hide turtle if not running in browser
  (seth 180) ;; Draw from top down
  (define width 100) ;; Output resolution
  (define height 100)

  ;; Do sphere initialization here
  (define spheres ())
  (define spheres (cons (sphere (vec3 0 0 10000) 9900 (vec3 0.9 0.9 0.9) 'diffuse) spheres))
  (define spheres (cons (sphere (vec3 0 10000 0) 9900 (vec3 0.9 0.9 0.9) 'diffuse) spheres))
  (define spheres (cons (sphere (vec3 0 -10000 0) 9900 (vec3 0.9 0.9 0.9) 'diffuse) spheres))
  (define spheres (cons (sphere (vec3 10000 0 0) 9885 (vec3 0.984 0.504 0.007) 'diffuse) spheres))
  (define spheres (cons (sphere (vec3 -10000 0 0) 9885 (vec3 0 0.02 0.147) 'diffuse) spheres))
  (define spheres (cons (sphere (vec3 -45 -50 20) 50 (vec3 1 1 1) 'mirror) spheres))
  (define spheres (cons (sphere (vec3 50 -50 -20) 40 (vec3 1 1 1) 'glass) spheres))
  (define spheres (cons (sphere (vec3 -15 -80 -60) 20 (vec3 0.053 0.244 0.398) 'diffuse) spheres))
  (define spheres (cons (sphere (vec3 0 1099.2 -20) 1000 (vec3 10 10 10) 'emitter) spheres))

  ;; light position, camera position

  (define cam-pos (vec3 0 0 -440))
  (define fov 60) ;; width angle
  (define fov (* fov (/ 3.14159265 180))) ;; convert to rad
  (define ratio (/ height width))
  (define xtan 0.577350269) 
  (define ytan (* xtan ratio))

  (define num-samples 5) 
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

    (color (color-adj sampled)) ;; Set pixel color
    (if (= y 0) ;; Move turtle accordingly
      (begin
        (pu)
        (goto x 0)
        (pd)
      )
      ()
    )
    (fd 1)

    (if (> (+ 1 pos) max-pos)
        0
        (draw-pixel (+ 1 pos))
    )
  )

  (draw-pixel 0) ;; Start drawing pixels from 0, 0
)



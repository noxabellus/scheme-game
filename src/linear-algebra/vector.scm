(define-library (scheme-game linear-algebra vector)
  (export
     ;; misc
     f32vector-reduce
     f32vector-length=?

     ;; vector
     f32vector-zero f32vector-one

     ;; accessors
     f32vector-x f32vector-set-x! f32vector-y f32vector-set-y!
     f32vector-z f32vector-set-z! f32vector-w f32vector-set-w!

     ;; operations
     f32vector-abs f32vector-ceiling f32vector-floor
     f32vector-round f32vector-truncate

     f32vector-min f32vector-max

     f32vector+ f32vector/scalar+ f32vector- f32vector/scalar-
     f32vector* f32vector/scalar* f32vector/ f32vector/scalar/

     f32vector-fold-min f32vector-fold-max
     f32vector-fold+  f32vector-fold-
     f32vector-fold*  f32vector-fold/

     f32vector-dot
     f32vector-magnitude-sq f32vector-magnitude f32vector-normalize

     ;; vector/2
     f32vector/2-cross f32vector/2-perp f32vector/2-cross-perp

     ;; vector/3
     f32vector/3-cross)
  (import (scheme base)
          (srfi 143)
          (srfi 144)
          (srfi 160 f32)
          (chicken type))
  (begin
    (: f32vector-reduce
       (forall (a)
         ((a float -> a) f32vector --> a)))
    (define (f32vector-reduce fn v)
      (f32vector-fold fn (f32vector-ref v 0) (f32vector-drop v 1)))

    (: f32vector-length=? (f32vector f32vector --> boolean))
    (define (f32vector-length=? v0 v1)
      (fx=? (f32vector-length v0) (f32vector-length v1)))

    (: f32vector-zero (fixnum --> f32vector))
    (define (f32vector-zero l)
      (make-f32vector l 0.0))

    (: f32vector-one (fixnum --> f32vector))
    (define (f32vector-one l)
      (make-f32vector l 1.0))

    (: f32vector-x (f32vector --> float))
    (define (f32vector-x v)
      (f32vector-ref v 0))

    (: f32vector-set-x! (f32vector float -> undefined))
    (define (f32vector-set-x! v n)
      (f32vector-set! v 0 n))

    (: f32vector-y (f32vector --> float))
    (define (f32vector-y v)
      (f32vector-ref v 1))

    (: f32vector-set-y! (f32vector float -> undefined))
    (define (f32vector-set-y! v n)
      (f32vector-set! v 1 n))

    (: f32vector-z (f32vector --> float))
    (define (f32vector-z v)
      (f32vector-ref v 2))

    (: f32vector-set-z! (f32vector float -> undefined))
    (define (f32vector-set-z! v n)
      (f32vector-set! v 2 n))

    (: f32vector-w (f32vector --> float))
    (define (f32vector-w v)
      (f32vector-ref v 3))

    (: f32vector-set-w! (f32vector float -> undefined))
    (define (f32vector-set-w! v n)
      (f32vector-set! v 3 n))

    (: f32vector-abs (f32vector --> f32vector))
    (define (f32vector-abs v)
      (f32vector-map flabs v))

    (: f32vector-ceiling (f32vector --> f32vector))
    (define (f32vector-ceiling v)
      (f32vector-map flceiling v))

    (: f32vector-floor (f32vector --> f32vector))
    (define (f32vector-floor v)
      (f32vector-map flfloor v))

    (: f32vector-round (f32vector --> f32vector))
    (define (f32vector-round v)
      (f32vector-map flround v))

    (: f32vector-truncate (f32vector --> f32vector))
    (define (f32vector-truncate v)
      (f32vector-map fltruncate v))

    (: f32vector-min (f32vector f32vector --> f32vector))
    (define (f32vector-min v0 v1)
      (f32vector-map flmin v0 v1))

    (: f32vector-max (f32vector f32vector --> f32vector))
    (define (f32vector-max v0 v1)
      (f32vector-map flmax v0 v1))

    (: f32vector+ (f32vector f32vector --> f32vector))
    (define (f32vector+ v0 v1)
      (f32vector-map fl+ v0 v1))

    (: f32vector/scalar+ (float f32vector -> f32vector))
    (define (f32vector/scalar+ n v)
      (f32vector-map (lambda (e) (fl+ n e)) v))

    (: f32vector- (f32vector f32vector --> f32vector))
    (define (f32vector- v0 v1)
      (f32vector-map fl- v0 v1))

    (: f32vector/scalar- (float f32vector -> f32vector))
    (define (f32vector/scalar- n v)
      (f32vector-map (lambda (e) (fl- n e)) v))

    (: f32vector* (f32vector f32vector --> f32vector))
    (define (f32vector* v0 v1)
      (f32vector-map fl* v0 v1))

    (: f32vector/scalar* (float f32vector -> f32vector))
    (define (f32vector/scalar* n v)
      (f32vector-map (lambda (e) (fl* n e)) v))

    (: f32vector/ (f32vector f32vector --> f32vector))
    (define (f32vector/ v0 v1)
      (f32vector-map fl/ v0 v1))

    (: f32vector/scalar/ (float f32vector -> f32vector))
    (define (f32vector/scalar/ n v)
      (f32vector-map (lambda (e) (fl/ n e)) v))

    (: f32vector-fold-min (f32vector --> float))
    (define (f32vector-fold-min v)
      (f32vector-reduce flmin v))

    (: f32vector-fold-max (f32vector --> float))
    (define (f32vector-fold-max v)
      (f32vector-reduce flmax v))

    (: f32vector-fold+ (f32vector --> float))
    (define (f32vector-fold+ v)
      (f32vector-reduce fl+ v))

    (: f32vector-fold- (f32vector --> float))
    (define (f32vector-fold- v)
      (f32vector-reduce fl- v))

    (: f32vector-fold* (f32vector --> float))
    (define (f32vector-fold* v)
      (f32vector-reduce fl* v))

    (: f32vector-fold/ (f32vector --> float))
    (define (f32vector-fold/ v)
      (f32vector-reduce fl/ v))

    (: f32vector-dot (f32vector f32vector --> float))
    (define (f32vector-dot v0 v1)
      (f32vector-fold (lambda (acc a b)
                        (fl+ acc (fl* a b)))
                      0
                      v0
                      v1))

    (: f32vector-magnitude-sq (f32vector --> float))
    (define (f32vector-magnitude-sq v)
      (f32vector-dot v v))

    (: f32vector-magnitude (f32vector --> float))
    (define (f32vector-magnitude v)
      (flsqrt (f32vector-magnitude-sq v)))

    (: f32vector-normalize (f32vector --> f32vector))
    (define (f32vector-normalize v)
      (let ((l (f32vector-magnitude v)))
        (f32vector-map (lambda (e) (fl/ e l)) v)))

    (: f32vector/2-cross (f32vector f32vector --> f32vector))
    (define (f32vector/2-cross v0 v1)
      (fl- (fl* (f32vector-x v0) (f32vector-y v1))
           (fl* (f32vector-x v1) (f32vector-y v0))))

    (: f32vector/2-perp (f32vector --> f32vector))
    (define (f32vector/2-perp v)
      (f32vector (fl- (f32vector-y v)) (f32vector-x v)))

    (: f32vector/2-cross-perp (f32vector --> float))
    (define (f32vector/2-cross-perp v)
      (f32vector-dot v (f32vector/2-perp v)))

    (: f32vector/3-cross (f32vector f32vector --> f32vector))
    (define (f32vector/3-cross v0 v1)
      (f32vector (fl- (fl* (f32vector-y v0) (f32vector-z v1))
                      (fl* (f32vector-z v0) (f32vector-y v1)))
                 (fl- (fl* (f32vector-z v0) (f32vector-x v1))
                      (fl* (f32vector-x v0) (f32vector-z v1)))
                 (fl- (fl* (f32vector-x v0) (f32vector-y v1))
                      (fl* (f32vector-y v0) (f32vector-x v1)))))))

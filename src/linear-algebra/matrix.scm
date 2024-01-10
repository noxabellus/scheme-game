(define-library (scheme-game linear-algebra matrix)
  (export
     ;; matrix
     f32matrix-zero f32matrix-one f32matrix-identity

     ;; accessors
     f32matrix-dim f32matrix-ref f32matrix-set!

     ;; operations
     f32matrix* f32matrix-translation f32matrix-scale

     ;; matrix/3
     f32matrix/3-zero f32matrix/3-one f32matrix/3-identity

     ;; accessors
     f32matrix/3-ref f32matrix/3-set!

     ;; operations
     f32matrix/3-translation f32matrix/3-rotation f32matrix/3-shear)

  (import (scheme base)
          (srfi 143)
          (srfi 144)
          (srfi 160 f32)
          (chicken type)
          (scheme-game linear-algebra vector))

  (begin
    (: f32matrix-zero (fixnum --> f32vector))
    (define (f32matrix-zero dim)
      (make-f32vector dim 0.0))

    (: f32matrix-one (fixnum --> f32vector))
    (define (f32matrix-one dim)
      (make-f32vector dim 1.0))

    (: f32matrix-identity (fixnum -> f32vector))
    (define (f32matrix-identity dim)
      (let ((m (f32matrix-zero dim)))
        (do ((i 0 (fx+ i 1)))
            ((fx=? i dim) m)
          (f32matrix-set! m i i 1.0))))

    (: f32matrix-dim (f32vector --> fixnum))
    (define (f32matrix-dim m)
      (let-values (((dim _) (fxsqrt (f32vector-length m))))
        dim))

    (: coordinate->index (f32vector fixnum fixnum --> fixnum))
    (define (coordinate->index m i j)
      (let ((dim (f32matrix-dim m)))
        (fx+ j (fx* dim i))))

    (: f32matrix-ref (f32vector fixnum fixnum --> float))
    (define (f32matrix-ref m i j)
      (f32vector-ref m (coordinate->index m i j)))

    (: f32matrix-set! (f32vector fixnum fixnum float -> undefined))
    (define (f32matrix-set! m i j n)
      (f32vector-set! m (coordinate->index m i j) n))

    (: f32matrix* (f32vector f32vector -> f32vector))
    (define (f32matrix* m0 m1)
      (let* ((k (f32matrix-dim m0))
             (m (f32matrix-zero k)))
        (do ((i 0 (fx+ i 1)))
            ((fx=? i k) m)
          (do ((j 0 (fx+ j 1)))
              ((fx=? j k))
            (do ((h 0 (fx+ h 1)))
                ((fx=? h k))
              (f32matrix-set! m i j
                              (fl+ (f32matrix-ref m i j)
                                   (fl* (f32matrix-ref m0 i h)
                                        (f32matrix-ref m1 h j)))))))))

    (: f32matrix-translation (fixnum f32vector -> f32vector))
    (define (f32matrix-translation dim v)
      (let ((m (f32matrix-identity dim))
            (l (f32vector-length v))
            (e (fx- dim 1)))
        (do ((i 0 (fx+ i 1)))
            ((fx=? i l) m)
          (f32matrix-set! m e i (f32vector-ref v i)))))

    (: f32matrix-scale (fixnum f32vector -> f32vector))
    (define (f32matrix-scale dim v)
      (let ((m (f32matrix-identity dim))
            (l (f32vector-length v)))
        (do ((i 0 (fx+ i 1)))
            ((fx=? i l) m)
          (f32matrix-set! m i i (f32vector-ref v i)))))

    (: f32matrix/3-zero (--> f32vector))
    (define (f32matrix/3-zero)
      (f32matrix-zero 3))

    (: f32matrix/3-one (--> f32vector))
    (define (f32matrix/3-one)
      (f32matrix-one 3))

    (: f32matrix/3-identity (--> f32vector))
    (define (f32matrix/3-identity)
      (f32matrix-identity 3))

    (: f32matrix/3-ref (f32vector fixnum fixnum --> float))
    (define (f32matrix/3-ref m i j)
      (let ((index (fx+ j (fx* 3 i))))
        (f32vector-ref m index)))

    (: f32matrix/3-set! (f32vector fixnum fixnum float --> undefined))
    (define (f32matrix/3-set! m i j n)
      (let ((index (fx+ j (fx* 3 i))))
        (f32vector-set! m index n)))

    (: f32matrix/3-translation (f32vector float float --> f32vector))
    (define (f32matrix/3-translation m x y)
      (f32vector 1.0 0.0 x
                 0.0 1.0 y
                 0.0 0.0 1.0))

    (: f32matrix/3-rotation (float --> f32vector))
    (define (f32matrix/3-rotation x)
      (let ((c (flcos x))
            (s (flsin x)))
        (f32vector c  (fl- s) 0.0
                   s   c      0.0
                   0.0 0.0    1.0)))

    (: f32matrix/3-shear (float float --> f32vector))
    (define (f32matrix/3-shear x y)
      (f32vector 1.0 x   0.0
                 y   1.0 0.0
                 0.0 0.0 1.0))))

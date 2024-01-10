(define-library (combinators)    
    (export
        <- ->)
        
    (import (scheme base))

    (begin
        (define (<- fn . args)
            (lambda rest
                (apply fn (append args rest))))

        (define (-> fn . fns)
            (if (null? fns)
                fn
                (let ((fns (apply -> fns)))
                    (lambda args
                        (fn (apply fns args))))))
    ))
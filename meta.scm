#! /usr/bin/csi -script

(import (scheme base)
        (scheme process-context)
        (prefix (shell) shell:))

(define args (cdr (command-line)))

(define (run) (shell:run (cd build && ./scheme-game)))
(define (build)
    (clean)
    (shell:run (mkdir build && cp scheme-game.egg ./build && cd build && chicken-install -n)))
(define (clean) (shell:run (rm -rf build)))
(define (help exit-code)
    (display "Usage: ./meta.scm [help | run | build | build-and-run | clean]\n")
    (exit exit-code))

(unless (= 1 (length args)) (help 1))
    
(case (string->symbol (car args))
    ((help) (help 0))
    ((run) (run))
    ((build) (build))
    ((build-and-run) (begin (build) (run)))
    ((clean) (clean))
    (else (help 1)))
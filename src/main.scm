(import (scheme base)
        (chicken condition)
        (prefix (sdl2)     sdl2:)
        (gl)
        (prefix (epoxy) gl:)
        (prefix (gl-utils) gl-utils:)
        (combinators)
        (linalg))

(sdl2:set-main-ready!)
(sdl2:init! '(video))

(on-exit sdl2:quit!)

(current-exception-handler
 (let ((original-handler (current-exception-handler)))
   (lambda (exception)
     (sdl2:quit!)
     (original-handler exception))))

(define window (sdl2:create-window!
                "SDL2 + OpenGL Example"
                'undefined 'undefined 640 480
                '(opengl)))

(sdl2:gl-attribute-set! 'context-profile-mask 'core)
(sdl2:gl-attribute-set! 'context-major-version 3)
(sdl2:gl-attribute-set! 'context-minor-version 3)

(define gl-context (sdl2:gl-create-context! window))

(gl-utils:check-error)

(define (main-loop)
  (when (not (sdl2:quit-requested?))
    (gl:ClearColor 0.0 0.5 1.0 1.0)
    (gl:Clear gl:COLOR_BUFFER_BIT)

    (sdl2:gl-swap-window! window)

    (sdl2:flush-events! 'first 'last)

    (sdl2:pump-events!)
    (main-loop)))

(main-loop)
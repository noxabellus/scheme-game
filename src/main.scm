(import (scheme base)
        (scheme read)
        (srfi 160 f32)
        (chicken memory)
        (scheme-game linear-algebra vector)
        (scheme-game linear-algebra matrix)
        (prefix (sdl2) sdl2:)
        (gl)
        (prefix (epoxy) gl:)
        (prefix (gl-utils) gl-utils:))

(define (with-sdl2 initialize thunk cleanup)
  ;;++ Yuck!
  ;; http://wiki.call-cc.org/man/5/Module%20(chicken%20condition)#with-exception-handler
  ;; otherwise we cleanup twice or even worse infinitely
  ((call/cc
    (lambda (k)
      (with-exception-handler
       (lambda (exception)
         (k (lambda () (raise exception))))
       (lambda ()
         (dynamic-wind
             initialize
             (lambda ()
               (let ((output (thunk)))
                 (lambda () output)))
             cleanup)))))))

(define (initialize!)
  (sdl2:set-main-ready!)
  (sdl2:init! '(video)))

(define (cleanup!)
  (sdl2:quit!))

(define vertex-shader-source
  "
#version 330 core
layout (location = 0) in vec3 aPos;

void main()
{
    gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
}
")
(define fragment-shader-source
  "
#version 330 core
out vec4 FragColor;

void main()
{
    FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);
}
")

(define (run-game!)
  (define window (sdl2:create-window! "SDL2 + OpenGL Example"
                                      'undefined 'undefined 640 480
                                      '(opengl)))

  (sdl2:gl-attribute-set! 'context-profile-mask 'core)
  (sdl2:gl-attribute-set! 'context-major-version 3)
  (sdl2:gl-attribute-set! 'context-minor-version 3)

  (define gl-context (sdl2:gl-create-context! window))

  (gl-utils:check-error)

  (define vertex-shader (gl-utils:make-shader gl:+vertex-shader+
                                              vertex-shader-source))
  (define fragment-shader (gl-utils:make-shader gl:+fragment-shader+
                                                fragment-shader-source))
  (define program (gl-utils:make-program (list vertex-shader fragment-shader)))

  (define vao (gl-utils:gen-vertex-array))

  (let ((vbo (gl-utils:gen-buffer))
        (vertices (f32vector -0.5 -0.5 0.0
                              0.5 -0.5 0.0
                              0.0  0.5 0.0)))
    (gl:bind-vertex-array vao)

    (gl:bind-buffer gl:+array-buffer+ vbo)
    (gl:buffer-data gl:+array-buffer+
                    (gl-utils:size vertices)
                    (gl-utils:->pointer vertices)
                    gl:+static-draw+)

    (gl:vertex-attrib-pointer 0
                              3
                              gl:+float+
                              gl:+false+
                              (* 3 4)
                              (address->pointer 0))
    (gl:enable-vertex-attrib-array 0)
    (gl:bind-vertex-array 0))


  ;; main loop
  (let loop ()
    (unless (sdl2:quit-requested?)
      (gl:ClearColor 0.0 0.5 1.0 1.0)
      (gl:Clear gl:COLOR_BUFFER_BIT)

      (gl:use-program program)
      (gl:bind-vertex-array vao)
      (gl:draw-arrays gl:+triangles+ 0 3)

      (sdl2:gl-swap-window! window)
      (sdl2:flush-events! 'first 'last)
      (sdl2:pump-events!)
      (loop))))

(with-sdl2 initialize! run-game! cleanup!)

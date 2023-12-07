					; A macro that composes a middleware stack and
					; some basic middleware examples.
					;
					; "Middleware" is the term used by PEP 333 and
					; other WSGIs.
					; Middleware is a function wrapper around the
					; application *app* handler.
					;
					; A middleware function takes an app handler,
					; and returns an app handler.
					; The actual application handler may
					; be nested within several middleware functions:
					;
					;(mw1 (mw2 (m3 (m4 app))))
					;
(define-library (gateway middleware)
  (import (kawa base))
  (export middleware/stack)
  (export middleware+logging)

					; example middleware that logs the environment and the response
  (define (middleware+logging app)
    (lambda (env)
      (format #t "middleware+logging env: ~a~%" env)
      (let ((resp (app env)))
	(format #t "middleware+logging resp: ~a~%" resp)
	resp)))

					; A middleware stack can be constructed with
					; this macro, which takes a list of middleware functions ending with the single
					; app function.
					; The macro nests the provided middleware.
  (define-syntax middleware/stack
    (syntax-rules ()
      ((_ mw app)
       (mw app))
      ((_ mw mw* ... app)
       (mw (middleware/stack mw* ... app))))))

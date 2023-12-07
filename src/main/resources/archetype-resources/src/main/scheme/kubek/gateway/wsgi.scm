					; Web Server Gateway Interface
					; The WSGI spec procedure, *app*
					; A default is provided.
					; This parameter should be set to a
					; handler provided by a web framework,
					; E.g. (*app* (lambda (env) ... )
(define-library (gateway wsgi)
  (export *app*)
  (import (kawa base))

  ; make-parameter does not work with servlet container -
  ; after updating parameter still get default - maybe multiple threads
  ; that do not share the *app* closure?
  #;
  (define *app*				;
  (make-parameter			;
  (lambda (env)				;
  `(200 ((content-type . "text/plain")) "Default WSGI handler"))))

  (define default-app
    (lambda (env)
      `(200 ((content-type . "text/plain")) "Default WSGI handler")))

  ; *app* is a function that when called with no arguments will
  ; return a value.
  ; When called with an argument will set it's value to the value
  ; of the argument.
  (define *app*
    (let ((**app** default-app))
      (lambda ( . app)
	(cond ((null? app) **app**)
	      (else (set! **app** (car app)))))))
  
  )

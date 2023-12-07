					;
					; Makes an application that will dispatch to a specific
					; handler given http method and uri
					;
					; Note that these handlers take the form
					;   (lambda (uri params) ...)
					;
					; which is different from the WSGI app which is
					;   (lambda (env)

(define-library (gateway routing)
  (export make-router-app)

  (import (kawa base))
  (import (kawa regex))
  (import (misc))
  (import (srfi 1))

					; register a handler proc for the method and path
					; the key in the routing table association list is a
					; pair of ( method . uri )
  (define (cons-route entry routing-table)
    (let-values (((method uri proc) (apply values entry)))
      (alist-cons `(,(string-upcase (stringify method)) . ,uri)
		  proc
		  routing-table)))

  (define (make-routing-table routes)
    (cond ((null? routes)
	   '())
	  (else (cons-route (car routes) (make-routing-table (cdr routes))))))

					; look up the handler proc using the given method and path
  (define (lookup-route routing-table method uri)

    (define (pred? entry)
      (and (regex-match (cdr (car entry)) uri)
	   (string-ci=? (car (car entry)) method)))

    (let ((found (find pred? routing-table)))
      (cond (found (cdr found))
	    (else #f))))

					; Returns a WSGI compliant function that will call the matching
					; handler for a given request method and uri.
  (define (make-router-app routes . rest)
    (define routing-table (make-routing-table (append routes rest)))

    (lambda (env)
					; find the specific handler for this env
      (let ((method (assoc-ref 'request-method env))
	    (uri    (assoc-ref 'request-uri env))
	    (params (assoc-ref 'parameters env)))
	(define handler (lookup-route routing-table method uri))

					; use earlier handler spec for now - TODO change this to lambda (env) ?
	(handler uri params))))

  )

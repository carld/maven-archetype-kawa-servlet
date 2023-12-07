(module-extends servlet)

(import (gateway servlet))
(import (gateway routing))
(import (gateway wsgi))
(import (gateway middleware))
(import (kawa base))

(define router-app

  (make-router-app

	'()  ; make-router-app is a lambda ( routes . rest ), the first argument is a list


   `(get "^.*/hello/world$"
	 ,(lambda (uri params)
	    `(200
	      ((Content-Type . "text/plain"))
	      "Hello world!")))

   ))

; register the new WSGI compliant app
(*app* (middleware/stack
	middleware+logging
	router-app))

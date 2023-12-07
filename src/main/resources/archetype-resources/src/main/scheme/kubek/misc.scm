(define-library (misc)
  (export make-number-list
	  iter-map/vector
	  java-map->alist
	  list-join
	  find-param1
	  flatten
	  stringify
	  assoc-ref
	  )

  (import (kawa base))

  (define (stringify maybe-symbol)
    (cond ((symbol? maybe-symbol) (symbol->string maybe-symbol))
	  ((string? maybe-symbol) maybe-symbol)
	  (else (error "stringify: neither symbol nor string: " maybe-symbol))))

  (define (assoc-ref k alist)
    (let ((v (assoc k alist)))
      (cond (v (cdr v))
	    (else #f))))
  
  (define (make-number-list from to)
    (if (> from to)
        '()
        (cons from (make-number-list (+ 1 from) to))))

  (define (iter-map fn iter)
    (let ((val (iter)))
      (cond (val (cons (fn val) (iter-map fn iter)))
            (else '()))))

  (define (iter-map/vector fn iter)
    (list->vector (iter-map fn iter)))

					; turn a java Map<> into an association list
  (define (java-map->alist m :: java.util.Map)
    (let* ((set :: java.util.Set (m:entrySet))
	   (iter :: java.util.Iterator  (set:iterator)))
      (iter-map (lambda (entry :: java.util.Map:Entry)
		  `(,(entry:getKey) . ,(entry:getValue)))
		(lambda ()
		  (cond ((iter:hasNext)
			 (iter:next))
			(else #f))))))

  (define (find-param1 alist key nil)
    (let ((entry (assoc key alist)))
      ; entry:getValue returns a string[]
      (cond (entry (cond ((instance? (cdr entry) string[])
			  ((cdr entry) 0))
			 (else
			  (cdr entry))
			 ))
	    (else  nil))))

					; (define-syntax (intersperser stx)
					;   (syntax-case stx (sep:)
					;     ((_ sep: x e0 e1 ... en)
					;      #`(cons e0 (cons x (intersperser sep: x e1 ... en))))
					;     ((_ sep: x en)
					;      #`(cons en '())
					;      )))

					; also known as intersperse
  (define (list-join delimiter list0)
    (cond ((null? list0) '())
          ((null? (cdr list0)) list0) ; the last element does not get a delimiter
          (else (cons (car list0) (cons delimiter (list-join delimiter (cdr list0)  ))))))

  (define (flatten x)
    (cond ((null? x) '())
	  ((pair? x) (append (flatten (car x)) (flatten (cdr x))))
	  (else (list x))))

  )

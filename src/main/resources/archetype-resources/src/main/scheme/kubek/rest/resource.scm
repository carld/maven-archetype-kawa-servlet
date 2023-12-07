(define-library (rest resource)

  (export def-rest-resource)

  (import (kawa base))
  (import (kawa regex))
  (import (guenchi json))
  (import (ssql))
  (import (misc))
  (import (srfi 1))

  (define headers `((Content-Type .  "application/hal+json")))

  (define-syntax respond-with
    (syntax-rules ()
      ((_ body* ...)
       (list 200 headers body* ...))))

  (define-syntax def-rest-resource
    (syntax-rules ()
      ((_ name (option* ...) (field* ...))

       (begin
	 (define sql-table-name (find-param1 (option* ...) 'table-name name))
	 (define sql-primary-key (find-param1 (option* ...) 'primary-key 'id))
	 (define sql-page-limit (string->number (find-param1 (option* ...) 'limit "20")))
	 (define sql-columns  (map (lambda (e) (if (pair? e) (car e) e))
				   (field* ...)))

	 (list
					; get a list of resources
	  `(get ,(format "^.*/~a/?$" name)
		,(lambda (uri params)
		   (define page (string->number (find-param1 params "page" "0")))
		   (respond-with
		    (ssql-query/json-string
		     `(select ,sql-columns
			      (from ,sql-table-name)
			      (limit ,sql-page-limit)
			      (offset ,(* sql-page-limit page)))))))

					; get a single resource
	  `(get ,(format "^.*/~a/([^\/]+)$" name)
		,(lambda (uri params)
		   (define id (regex-match "[^\/]+$" uri))
		   (respond-with
		    (ssql-query/json-string
		     `(select ,sql-columns
			      (from ,sql-table-name)
			      (where (= ,sql-primary-key ,id)))))))

	  `(post ,(format "^.*/~a/?$" name)
		 ,(lambda (uri params)
		    (define columns (remove (lambda (e) (eqv? e sql-primary-key)) sql-columns))
		    (respond-with
		     (let* ((result
			     (ssql-execute-params
			      `(insert (into ,sql-table-name ,columns)
				       (values ,(make-list (length columns) '?)))
			      params)))
		       (json->string `(("result" . ,result)))))))

	  `(put ,(format "^.*/~a/([^\/]+)$" name)
		,(lambda (uri params)
		   (define id (regex-match "[^\/]+$" uri))
		   (define columns (remove (lambda (e) (eqv? e sql-primary-key)) sql-columns))
		   (define assignments (map (lambda (p) `(= ,(string->symbol (car p)) ?))
					    params))
		   (respond-with
		    (let* ((result
			    (ssql-execute-params
				`(update ,sql-table-name
					 (set ,assignments)
					 (where (= ,sql-primary-key ,id)))
				params)))
		      (json->string `(("result" . ,result))))))))))))


  )

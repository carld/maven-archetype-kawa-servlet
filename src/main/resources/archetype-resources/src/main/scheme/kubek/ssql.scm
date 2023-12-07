					; this module composes the sql and ssql modules
(define-library (ssql)
  (import (sql))
  (import (ssql str))
  (import (kawa base))
  (import (guenchi json))

  (export ssql->str
	  ssql-query/json-string
	  ssql-execute
	  ssql-execute-params
	  )

  (define (ssql-query/json-string exp)
    (json->string (sql-query/json (sql-connect) (ssql->str exp))))

  (define (ssql-execute exp)
    (sql-execute (sql-connect) (ssql->str exp)))

  (define (ssql-execute-params exp params)
    (sql-execute-params (sql-connect) (ssql->str exp) params)))

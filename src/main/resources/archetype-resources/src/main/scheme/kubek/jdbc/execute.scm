(define-library (jdbc execute)
  (export sql-execute 
          sql-execute-params)
  (import (kawa base))
  (import (class java.sql
		 Connection
		 Statement
		 PreparedStatement
		 ))
  (import (srfi 69))
  (import (misc))
  
					; executeUpdate returns number of rows affected
  (define (sql-execute connection :: Connection sql #!key (timeout :: int 3)) :: int
    (define statement :: Statement (connection:createStatement))
    (statement:setQueryTimeout timeout)
    (statement:executeUpdate sql))
  
  (define (sql-execute-params connection :: Connection sql params) 
    (define statement :: PreparedStatement (connection:prepareStatement sql))
    (connection:setAutoCommit #f)

    (define column-numbers (make-number-list 1 (length params)))

    (format #t "DEBUG execute-params ~a ~a ~a~%" params column-numbers)
    
    (for-each
     (lambda (column-number param)
       (sql-execute-bind statement column-number param))
     column-numbers
     params)
    
    (define result (statement:executeUpdate))
    (connection:commit)
    result
    )

  (define (sql-execute-bind statement :: PreparedStatement colnumber param)
    (format #t "DEBUG: binding: ~a ; ~a ; ~a ; ~%" colnumber param)
    (define value0 ((cdr param) 0))
    (format #t "DEBUG: binding value ~a ~%" value0)
    (cond ((number? value0)
	   (statement:setInt colnumber value0))
	  (else
	   (statement:setString colnumber value0)))))

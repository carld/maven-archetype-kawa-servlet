
(define-library (jdbc query)

  (export sql-query
          sql-query/json)

  (import (jdbc connection))
  (import (jdbc types))
  (import (kawa base))
  (import (misc))
  (import (unit-test))
  (import (srfi 69))

  (import (class java.sql
		 Connection
		 ResultSet
		 ResultSetMetaData
		 SQLException
		 Statement
		 ))

  (define (record-get-value rs :: ResultSet coltype :: int col :: int)
    (let ((value (invoke rs (hash-table-ref type-method-hash coltype) col)))
					;(format #t "type ~s col ~s value ~s~%" coltype col value)
      value))

  (define (get-columns result-set :: ResultSet metadata :: ResultSetMetaData)
    (define colvector (list->vector (make-number-list 1 (metadata:getColumnCount))))
    (vector-map (lambda (col)
                  (record-get-value result-set (metadata:getColumnType col) col))
		colvector))

  (define (get-columns/json result-set :: ResultSet metadata :: ResultSetMetaData)
    (define colvector (list->vector (make-number-list 1 (metadata:getColumnCount))))
    (map (lambda (col)
           `(,(metadata:getColumnName col) .
             ,(format #f "~a" (record-get-value result-set (metadata:getColumnType col) col))))
         colvector))

					; returns a vector of association lists
					; with the sql column name used as the association key 
  (define (sql-query/json connection :: Connection sql :: String #!key (timeout 3))
    (define statement ::java.sql.Statement (connection:createStatement))
    (statement:setQueryTimeout timeout)
    (define rs ::java.sql.ResultSet (statement:executeQuery sql))
    ;; column - the first column is 1, the second is 2 ...
    (define md ::java.sql.ResultSetMetaData (rs:getMetaData))

    (define return-results (iter-map/vector (lambda (e) (get-columns/json rs md))
                                            (lambda ()  (rs:next))))
    return-results)

					; returns the results as a vector of vectors:
					; a vector of rows, where each row is a vector of values
  (define (sql-query connection :: Connection sql :: String #!key (timeout 3))
    (define statement ::java.sql.Statement (connection:createStatement))
    (statement:setQueryTimeout timeout)
    (define rs ::java.sql.ResultSet (statement:executeQuery sql))
    ;; column - the first column is 1, the second is 2 ...
    (define md ::java.sql.ResultSetMetaData (rs:getMetaData))

    (define return-results (iter-map/vector (lambda (e) (get-columns rs md))
                                            (lambda ()  (rs:next))))
    return-results)

  )


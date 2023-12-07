; Database connectivity properties are in a file, database.properties:
;   database.url
;   database.driver
;   database.username
;   database.password
; Ensure the JDBC driver is in CLASSPATH
; TODO add connection pooling?
(define-library (jdbc connection)

  (export sql-connect)
  (import (kawa base))
  (import (class java.util
		 ResourceBundle
		 PropertyResourceBundle
		 )
          (class java.sql
		 Connection
		 DriverManager
		 ))

					; load the resource database.properties
  (define rd (PropertyResourceBundle:getBundle "database"))

					; register the database driver
  (define driver (java.lang.Class:forName (rd:getString "database.driver")))

  (define (sql-connect) :: Connection
    (DriverManager:getConnection
     (rd:getString "database.url")
     (rd:getString "database.username")
     (rd:getString "database.password")))

  )

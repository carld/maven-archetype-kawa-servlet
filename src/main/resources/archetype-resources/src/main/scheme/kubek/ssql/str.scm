					; This library converts a scheme sql like language represented as a quoted list
					; to a string representing SQL.
					;  (select (c1 c2 c3 c4) (from t1) (where (and (= c1 1) (= c2 'hello'))))
					; It is based on an evaluator, as used for implementing Lisp interpreters.

(define-library (ssql str)
  (export ssql->str)
  (import (kawa base))

					; evaluate the ssql expression list
  (define (ssql-evlist exp)
    (cond ((null? exp) '())
	  (else (cons (ssql-ev (car exp)) (ssql-evlist (cdr exp))))))

					; evaluate the ssql expression
  (define (ssql-ev exp)
    (cond ((number? exp) (format "~a" exp))
	  ((symbol? exp) (format "~a" exp))
	  ((string? exp) (format "'~a'" exp))
	  ((list?  exp)  (cond
					; the values list is placed within parenthesis
			  ((equal? (car exp) 'values) (string-append "values " "(" (ssql-ev (cdr exp)) ")"))
					; the into columns list is placed within parenthesis
			  ((equal? (car exp) 'into)  (string-append "into " (ssql-ev (cadr exp)) " " "(" (ssql-ev (cddr exp)) ")"))
					; sql keywords are like scheme function names / macro names at the head of a list
			  ((sql-keyword? (car exp)) (string-append (ssql-ev (car exp)) " " (string-join (ssql-evlist (cdr exp)) " ")))
					; sql operators need to be made infix from prefix
			  ((sql-operator? (car exp))  (string-append (ssql-ev (cadr exp)) " " (ssql-ev (car exp)) " " (ssql-ev (caddr exp))))
					; any other list is join with commas
			  ((sql-function? (car exp)) (string-append (ssql-ev (car exp)) "(" (string-join (ssql-evlist (cdr exp)) ", ") ")"))
			  (else (string-join (ssql-evlist exp) ", "))
			  ))
	  (else (error "unexpected ssql: " exp))))

  (define (sql-keyword? exp)
    (case exp
      ((select from inner outer join on where limit offset group by insert into values update set) #t)
      (else #f)))

  (define (sql-operator? exp)
    (case exp
      ((= > != >= < <= and or not) #t)
      (else #f )))

  (define (sql-function? exp)
    (case exp
      ((min max avg) #t)
      (else #f)))
  
  (define (ssql->str exp)
    (let ((sql-str
	   (ssql-ev exp)))
      ;(format #t "DEBUG SSQL: ~s~%" sql-str)
      sql-str))
  )

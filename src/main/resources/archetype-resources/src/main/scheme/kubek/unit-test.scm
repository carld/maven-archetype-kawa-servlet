(define-library (unit-test)
(export unit-test)
(import (kawa base))

(define-syntax (unit-test stx)
  (syntax-case stx ()
    ((_ expression expected equal?)
     #`(let ((result expression))
      (if (equal? result expected)
        (format #t "unit-test passed: ~s = ~s, got: ~s ~%" 'expression 'expected result)
        (format #t "unit-test failed: ~s != ~s, got: ~s ~%" 'expression 'expected result))))

    ((_ expression expected)
      #`(unit-test expression expected equal?))

    ((_ expression)
      #`(unit-test expression 'not-false (lambda (a b) a))
    ))))

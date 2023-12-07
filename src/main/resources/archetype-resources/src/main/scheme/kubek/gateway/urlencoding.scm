(define-library (gateway urlencoding)

  (export url-decode )
  (import (kawa base))

					; split line on & to get key=value pairs and then split each on =
					; returns an association list
  (define (url-decode line)
    (map (lambda (nv)
	   (let ((nvsplit (string-split nv "=")))
	     `( ,(car nvsplit) . ,(string[] (cadr nvsplit)))))
	 (string-split line "&")))

  )

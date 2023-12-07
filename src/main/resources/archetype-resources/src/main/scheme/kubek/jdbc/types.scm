(define-library (jdbc types)
  (import (kawa base))
  (import (srfi 69))
  (import (class java.sql Types))
  (export type-method-hash)

  (define type-method-hash
    (alist->hash-table
     `((,Types:DECIMAL .  getBigDecimal)
       (,Types:TIME   .   getTime)
       (,Types:TIMESTAMP .  getTimestamp)
       (,Types:DATE     .  getDate)
       (,Types:VARCHAR  .  getString)
       (,Types:NUMERIC  .  getBigDecimal)
       (,Types:INTEGER  .  getLong)
       (,Types:BIGINT   .  getLong)
       (,Types:BOOLEAN  .   getBoolean)
       (,Types:CHAR  .   getChar)
       )))

  )

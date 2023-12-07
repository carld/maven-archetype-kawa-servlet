; This wrapper library composes several submodules that enable SQL functionality
;
(define-library (sql)

  (export
    sql-connect
    sql-execute
    sql-execute-params
    sql-query
    sql-query/json
    sql-metadata-table
    sql-metadata-table/json
    sql-metadata-column
    sql-metadata-column/json
  )

  (import (kawa base))
  (import (jdbc connection))
  (import (jdbc execute))
  (import (jdbc query))
  (import (jdbc metadata))

  )

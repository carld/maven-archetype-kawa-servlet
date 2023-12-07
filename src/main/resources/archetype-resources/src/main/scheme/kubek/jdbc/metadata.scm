(define-library (jdbc metadata)
  (export sql-metadata-table
          sql-metadata-table/json
          sql-metadata-column
          sql-metadata-column/json
          sql-metadata-result-set
          sql-metadata-result-set/json
	  )
  (import (kawa base))
  (import (misc))
  (import (unit-test))
  (import (jdbc connection))

  (import (class java.sql
		 Connection
		 ResultSet
		 ResultSetMetaData
		 SQLException
		 Statement
		 Types
		 ))

  (define (sql-metadata-result-set rs :: ResultSet)
    (define md ::java.sql.ResultSetMetaData (rs:getMetaData))
    (define colvector (list->vector (make-number-list 1 (md:getColumnCount))))
    (vector-map (lambda (c)
                  `(,(md:getColumnName c) . ,(md:getColumnType c)))
		colvector))

  (define (sql-metadata-result-set/json rs :: ResultSet)
    (define md (sql-metadata-result-set rs))
    (vector-map (lambda (c)
                  `((("column_name" . ,(car c))
                     ("column_type" . ,(cdr c)))))
		md))

  (define (sql-metadata-table 
           connection :: Connection
           #!key 
           (catalog-name-pattern #!null) 
           (schema-name-pattern #!null) 
           (table-name-pattern "%")
           (types #!null)
           (name :: string "TABLE_NAME")) ; TABLE_TYPE, TABLE_CAT, TABLE_SCHEM, TYPE_CAT, TYPE_SCHEM, TYPE_NAME
    (define metadata (connection:getMetaData))
					; getTables String catalog, String schemaPattern, String tableNamePattern, String[] types
    (define rs (metadata:getTables catalog-name-pattern schema-name-pattern table-name-pattern types))
					; retrieve the table names using the result set iterator
    (iter-map/vector (lambda (e) (rs:getString name))
                     (lambda ()  (rs:next))))

  (define (sql-metadata-table/json 
           connection :: Connection
           #!key 
           (catalog-name-pattern #!null) 
           (schema-name-pattern #!null) 
           (table-name-pattern "%")
           (types #!null)
           (name :: string "TABLE_NAME"))
    (vector-map 
     (lambda (table)
       `(("table_name" . ,table)))
     (sql-metadata-table connection 
			 catalog-name-pattern: catalog-name-pattern 
			 schema-name-pattern: schema-name-pattern 
			 table-name-pattern: table-name-pattern
			 types: types
			 name: name)))

  (define (sql-metadata-column 
           connection :: Connection
           #!key
           (catalog-name-pattern #!null) 
           (schema-name-pattern #!null) 
           (table-name-pattern #!null)
           (column-name-pattern #!null)
           (name :: string "COLUMN_NAME")) ; DATA_TYPE, IS_AUTOINCREMENT, IS_NULLABLE, COLUMN_SIZE,
    (define metadata (connection:getMetaData))
					;getColumns(String catalog, String schemaPattern, String tableNamePattern, String columnNamePattern)
    (define rs (metadata:getColumns catalog-name-pattern schema-name-pattern table-name-pattern column-name-pattern))
					; retrieve the column names using the result set iterator
    (iter-map/vector (lambda (e) (rs:getString name))
	             (lambda ()  (rs:next))))

  (define (sql-metadata-column/json 
           connection :: Connection
           #!key 
           (catalog-name-pattern #!null)
           (schema-name-pattern #!null)
           (table-name-pattern #!null)
           (column-name-pattern #!null)
           (name :: string "COLUMN_NAME"))
    (vector-map 
     (lambda (column)
       `(("column_name" . ,column)))
     (sql-metadata-column
      connection
      catalog-name-pattern: catalog-name-pattern 
      schema-name-pattern: schema-name-pattern 
      table-name-pattern: table-name-pattern
      column-name-pattern: column-name-pattern
      name: name)))

  )

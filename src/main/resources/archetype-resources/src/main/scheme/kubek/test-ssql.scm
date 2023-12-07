(import (ssql))
(import (unit-test))

(unit-test (ssql->str `(select (c1 c2 c3 c4)
			       (from (t1))
			       (where (and (= c1 1)
					   (= c2 "yo!")))))
	   "SELECT c1, c2, c3, c4 FROM t1 WHERE c1 = 1 AND c2 = 'yo!'"
	   string-ci=?
	   )

(unit-test (ssql->str `(select (c1 c2 c3) (from t1)))
	   "SELECT c1, c2, c3 FROM t1"
	   string-ci=?
	   )

(unit-test (ssql->str `(select * (from t1)))
	   "SELECT * FROM t1"
	   string-ci=?
	   )

(unit-test (ssql->str `(select (c1 c2 c3) from t1))
	   "SELECT c1, c2, c3 FROM t1"
	   string-ci=?
	   )

(unit-test (ssql->str `(select (c1 c2 c3) (from t1) (limit 10) (offset 3)))
	   "SELECT c1, c2, c3 FROM t1 LIMIT 10 OFFSET 3"
	   string-ci=?
	   )

(unit-test (ssql->str `(select (c1 c2 c3) (from t1 (join t2 on (= t1.id t2.xid))) (limit 10) (offset 3)))
	   "SELECT c1, c2, c3 FROM t1 JOIN t2 ON t1.id = t2.xid LIMIT 10 OFFSET 3"
	   string-ci=?
	   )

(unit-test (ssql->str `(select (max c1) (from t1) (group by c1)))
	   "SELECT max(c1) FROM t1 GROUP BY c1"
	   string-ci=?)

(unit-test (ssql->str `(insert (into t1 (c1 c2 c3))
			       (values (1 2 "hello"))))
	   "INSERT INTO t1 (c1, c2, c3) VALUES (1, 2, 'hello')"
	   string-ci=?
	   )

(unit-test (ssql->str `(insert (into t1 (c1 c2 c3))
			       (values (? ? ?))))
	   "INSERT INTO t1 (c1, c2, c3) VALUES (?, ?, ?)"
	   string-ci=?
	   )

(unit-test (ssql->str `(update t1 (set (and (= c1 1)
					    (= c2 "hello")))))
	   "UPDATE t1 SET c1 = 1 AND c2 = 'hello'"
	   string-ci=?
	   )

(unit-test (ssql->str `(update t1 (set (= c2 "hello"))
			       (where (= c1 1))))
	   "UPDATE t1 SET c2 = 'hello' WHERE c1 = 1"
	   string-ci=?
	   )


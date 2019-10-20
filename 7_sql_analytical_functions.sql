---Partition, over, first value, rank : IN SQL

---Reference: https://oracle-base.com/articles/misc/analytic-functions
--SYNTAX
analytic_function([ arguments ]) OVER (analytic_clause)
[ query_partition_clause ] [ order_by_clause [ windowing_clause ] ]

--Usage of AVG with OVER, PARTITION

SELECT empno, deptno, sal,
       AVG(sal) OVER (PARTITION BY deptno) AS avg_dept_sal
FROM   emp;



--USAGE OF FIRST_VALUE with OVER, PARTITION
--return the first salary reported in each department.

SELECT empno, deptno, sal,
       FIRST_VALUE(sal IGNORE NULLS) OVER (PARTITION BY deptno ORDER BY sal ASC NULLS LAST) AS first_val_in_dept
FROM   emp;



--USAGE OF AVG with OVER, PARTITION, ORDER BY
--The addition of the order_by_clause without a windowing_clause means the query is now returning a running average.
--The default windowing_clause is RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW, not ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW. The fact it is RANGE, not ROWS, means it includes all rows with the same value as the value in the current row, even if they are further down the result set. As a result, the window may extend beyond the current row, even though you may not think this is the case.

SELECT empno, deptno, sal,
       AVG(sal) OVER (PARTITION BY deptno ORDER BY sal
                      RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS range_avg,
       AVG(sal) OVER (PARTITION BY deptno ORDER BY sal
                      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS rows_avg
FROM   emp;

--OUTPUT
EMPNO     DEPTNO        SAL  RANGE_AVG   ROWS_AVG
---------- ---------- ---------- ---------- ----------
 7934         10       1300       1300       1300
 7782         10       2450       1875       1875
 7839         10       5000 2916.66667 2916.66667

 7369         20        800        800        800
 7876         20       1100        950        950
 7566         20       2975       1625       1625
 7788         20       3000       2175    1968.75
 7902         20       3000       2175       2175



RANK() OVER ([ query_partition_clause ] order_by_clause)
SELECT empno,
       deptno,
       sal,
       RANK() OVER (PARTITION BY deptno ORDER BY sal) AS myrank
FROM   emp;

SELECT empno,
       deptno,
       sal,
       DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal) AS myrank
FROM   emp;

SELECT empno,
       deptno,
       sal,
       MIN(sal) KEEP (DENSE_RANK FIRST ORDER BY sal) OVER (PARTITION BY deptno) AS lowest,
       MAX(sal) KEEP (DENSE_RANK LAST ORDER BY sal) OVER (PARTITION BY deptno) AS highest
FROM   emp
ORDER BY deptno, sal;

---LAG : https://oracle-base.com/articles/misc/lag-lead-analytic-functions
The LAG function is used to access data from a previous row. The following query returns the salary from the previous row to calculate the difference between the salary of the current row and that of the previous row. Notice that the ORDER BY of the LAG function is used to order the data by salary.

LAG
  { ( value_expr [, offset [, default]]) [ { RESPECT | IGNORE } NULLS ]
  | ( value_expr [ { RESPECT | IGNORE } NULLS ] [, offset [, default]] )
  }
  OVER ([ query_partition_clause ] order_by_clause)


SELECT empno,
         ename,
         job,
         sal,
         LAG(sal, 1, 0) OVER (ORDER BY sal) AS sal_prev,
         sal - LAG(sal, 1, 0) OVER (ORDER BY sal) AS sal_diff
  FROM   emp;

  SELECT deptno,
         empno,
         ename,
         job,
         sal,
         LAG(sal, 1, 0) OVER (PARTITION BY deptno ORDER BY sal) AS sal_prev
  FROM   emp;


---LEAD :
The LEAD function is used to return data from rows further down the result set. The following query returns the salary from the next row to calculate the difference between the salary of the current row and the following row.

LEAD
  { ( value_expr [, offset [, default]] ) [ { RESPECT | IGNORE } NULLS ]
  | ( value_expr [ { RESPECT | IGNORE } NULLS ] [, offset [, default]] )
  }
  OVER ([ query_partition_clause ] order_by_clause)


SELECT empno,
       ename,
       job,
       sal,
       LEAD(sal, 1, 0) OVER (ORDER BY sal) AS sal_next,
       LEAD(sal, 1, 0) OVER (ORDER BY sal) - sal AS sal_diff
FROM   emp;


SELECT deptno,
       empno,
       ename,
       job,
       sal,
       LEAD(sal, 1, 0) OVER (PARTITION BY deptno ORDER BY sal) AS sal_next
FROM   emp;



---Ref: https://oracle-base.com/articles/misc/string-aggregation-techniques---listagg
---Similar to collect list; User defined aggregate function can also be created
SELECT deptno, LISTAGG(ename, ',') WITHIN GROUP (ORDER BY ename) AS employees
FROM   emp
GROUP BY deptno;


---ROW NUMBER
SELECT deptno,
       LTRIM(MAX(SYS_CONNECT_BY_PATH(ename,','))
       KEEP (DENSE_RANK LAST ORDER BY curr),',') AS employees
FROM   (SELECT deptno,
               ename,
               ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY ename) AS curr,
               ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY ename) -1 AS prev
        FROM   emp)
GROUP BY deptno
CONNECT BY prev = PRIOR curr AND deptno = PRIOR deptno
START WITH curr = 1;


---COLLECT function
SELECT deptno,
       tab_to_string(CAST(COLLECT(ename) AS t_varchar2_tab)) AS employees
FROM   emp
GROUP BY deptno;


---PERCENT_RANK
The PERCENT_RANK analytic function assigns value between 0-1 which represents the position of the current row relative to the set as a percentage. The following example displays the top 80% of the rows based on the value.
SELECT val
FROM   (SELECT val,
               PERCENT_RANK() OVER (ORDER BY val) AS val_percent_rank
        FROM   rownum_order_test)
WHERE  val_percent_rank >= 0.8;


---NTILE
SELECT val
FROM   (SELECT val,
               NTILE(3) OVER (ORDER BY val) AS val_ntile
        FROM   rownum_order_test)
WHERE  val_ntile = 3;


---Reference: https://oracle-base.com/articles/misc/corr-analytic-function---corr
---Correlation calculate
SELECT empno,
       ename,
       deptno,
       sal,
       job,
       CORR(SYSDATE - hiredate, sal) OVER (PARTITION BY deptno) AS corr_val
FROM   emp;



---Reference: https://oracle-base.com/articles/misc/nth_value-analytic-function---nth_value
---Nth value
SELECT empno,
       ename,
       deptno,
       sal,
       NTH_VALUE(sal, 2) FROM FIRST OVER (PARTITION BY deptno ORDER BY sal) AS third_lowest_sal,
       NTH_VALUE(sal, 2) FROM LAST OVER (PARTITION BY deptno ORDER BY sal
                                         ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS third_highest_sal
FROM   emp;

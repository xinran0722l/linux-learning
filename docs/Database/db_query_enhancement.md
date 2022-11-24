## 查询增强

- 为了方便演示，先展示测试表

```SQL
#共使用表emp,dept和salgrade三张

mysql> select * from dept;
+--------+------------+----------+
| deptno | dname      | loc      |
+--------+------------+----------+
|     10 | ACCOUNTING | NEW YORK |
|     20 | RESEARCH   | DALLAS   |
|     30 | SALES      | CHICAGO  |
|     40 | OPERATIONS | BOSHTON  |
+--------+------------+----------+
4 rows in set (0.00 sec)

mysql> select * from salgrade;
+-------+---------+---------+
| grade | losal   | hisal   |
+-------+---------+---------+
|     1 |  700.00 | 1200.00 |
|     2 | 1201.00 | 1400.00 |
|     3 | 1401.00 | 2000.00 |
|     4 | 2001.00 | 3000.00 |
|     5 | 3001.00 | 9999.00 |
+-------+---------+---------+
5 rows in set (0.00 sec)

mysql> select * from emp;
+-------+--------+-----------+------+------------+---------+---------+--------+
| empno | ename  | job       | mgr  | hiredate   | sal     | comm    | deptno |
+-------+--------+-----------+------+------------+---------+---------+--------+
|  7369 | SMITH  | CLERK     | 7902 | 1990-12-17 |  800.00 |    NULL |     20 |
|  7499 | ALLEN  | SALESMAN  | 7698 | 1991-02-20 | 1600.00 |  300.00 |     30 |
|  7521 | WARD   | SALESMAN  | 7968 | 1991-02-22 | 1250.00 |  500.00 |     30 |
|  7566 | JONES  | MANAGER   | 7839 | 1991-04-02 | 2975.00 |    NULL |     20 |
|  7654 | MARTIN | SALESMAN  | 7968 | 1991-09-28 | 1250.00 | 1400.00 |     30 |
|  7698 | BLAKE  | MANAGER   | 7839 | 1991-05-01 | 2850.00 |    NULL |     30 |
|  7782 | CLARK  | MANAGER   | 7839 | 1991-06-09 | 2450.00 |    NULL |     10 |
|  7788 | SCOTT  | ANALYST   | 7566 | 1991-04-19 | 3000.00 |    NULL |     20 |
|  7839 | KING   | PRESIDENT | NULL | 1991-11-17 | 5000.00 |    NULL |     10 |
|  7844 | TURNER | SALESMAN  | 7698 | 1991-09-08 | 1500.00 |    NULL |     30 |
|  7900 | JAMES  | CLERK     | 7698 | 1991-12-03 |  950.00 |    NULL |     30 |
|  7902 | FORD   | ANALYST   | 7566 | 1991-12-03 | 3000.00 |    NULL |     20 |
|  7934 | MILLER | CLERK     | 7782 | 1991-01-23 | 1300.00 |    NULL |     10 |
+-------+--------+-----------+------+------------+---------+---------+--------+
13 rows in set (0.00 sec)
```

### WHERE

- 使用where子句,查找1991.11.11后入职的员工

```SQL
-- 在MySQL中，日期类型可以直接比较
mysql> select * from emp
    -> WHERE hiredate > '1991-11-11';
+-------+-------+-----------+------+------------+---------+------+--------+
| empno | ename | job       | mgr  | hiredate   | sal     | comm | deptno |
+-------+-------+-----------+------+------------+---------+------+--------+
|  7839 | KING  | PRESIDENT | NULL | 1991-11-17 | 5000.00 | NULL |     10 |
|  7900 | JAMES | CLERK     | 7698 | 1991-12-03 |  950.00 | NULL |     30 |
|  7902 | FORD  | ANALYST   | 7566 | 1991-12-03 | 3000.00 | NULL |     20 |
+-------+-------+-----------+------+------------+---------+------+--------+
3 rows in set (0.00 sec)
```
- LIKE(模糊查询)

```SQL
-- % 表示0到多个字符 _表示单个字符

#查找名字以大写S开头的信息
mysql>  select ename,sal from emp
    -> WHERE ename like 'S%';
+-------+---------+
| ename | sal     |
+-------+---------+
| SMITH |  800.00 |
| SCOTT | 3000.00 |
+-------+---------+
2 rows in set (0.00 sec)

-- 显示第三个字符为大写O的所有员工的姓名和工资
mysql> select ename,sal from emp
    -> where ename like '__O%';
+-------+---------+
| ename | sal     |
+-------+---------+
| SCOTT | 3000.00 |
+-------+---------+
1 row in set (0.00 sec)

-- 如何显示没有上级的员工的情况
mysql> select * from emp
    -> where mgr is NULL;
+-------+-------+-----------+------+------------+---------+------+--------+
| empno | ename | job       | mgr  | hiredate   | sal     | comm | deptno |
+-------+-------+-----------+------+------------+---------+------+--------+
|  7839 | KING  | PRESIDENT | NULL | 1991-11-17 | 5000.00 | NULL |     10 |
+-------+-------+-----------+------+------------+---------+------+--------+
1 row in set (0.00 sec)
```
- 查询表emp的结构 (DESC命令)

```SQL
mysql> DESC emp;
+----------+--------------------+------+-----+---------+-------+
| Field    | Type               | Null | Key | Default | Extra |
+----------+--------------------+------+-----+---------+-------+
| empno    | mediumint unsigned | NO   |     | 0       |       |
| ename    | varchar(20)        | NO   |     |         |       |
| job      | varchar(9)         | NO   |     |         |       |
| mgr      | mediumint unsigned | YES  |     | NULL    |       |
| hiredate | date               | NO   |     | NULL    |       |
| sal      | decimal(7,2)       | NO   |     | NULL    |       |
| comm     | decimal(7,2)       | YES  |     | NULL    |       |
| deptno   | mediumint unsigned | NO   |     | 0       |       |
+----------+--------------------+------+-----+---------+-------+
8 rows in set (0.01 sec)
```

### order by(排序)

- 如何按照工资的从低到高的顺序，显示员工的信息

```SQL
mysql> select * from emp
    -> order by sal;
+-------+--------+-----------+------+------------+---------+---------+--------+
| empno | ename  | job       | mgr  | hiredate   | sal     | comm    | deptno |
+-------+--------+-----------+------+------------+---------+---------+--------+
|  7369 | SMITH  | CLERK     | 7902 | 1990-12-17 |  800.00 |    NULL |     20 |
|  7900 | JAMES  | CLERK     | 7698 | 1991-12-03 |  950.00 |    NULL |     30 |
|  7521 | WARD   | SALESMAN  | 7968 | 1991-02-22 | 1250.00 |  500.00 |     30 |
|  7654 | MARTIN | SALESMAN  | 7968 | 1991-09-28 | 1250.00 | 1400.00 |     30 |
|  7934 | MILLER | CLERK     | 7782 | 1991-01-23 | 1300.00 |    NULL |     10 |
|  7844 | TURNER | SALESMAN  | 7698 | 1991-09-08 | 1500.00 |    NULL |     30 |
|  7499 | ALLEN  | SALESMAN  | 7698 | 1991-02-20 | 1600.00 |  300.00 |     30 |
|  7782 | CLARK  | MANAGER   | 7839 | 1991-06-09 | 2450.00 |    NULL |     10 |
|  7698 | BLAKE  | MANAGER   | 7839 | 1991-05-01 | 2850.00 |    NULL |     30 |
|  7566 | JONES  | MANAGER   | 7839 | 1991-04-02 | 2975.00 |    NULL |     20 |
|  7788 | SCOTT  | ANALYST   | 7566 | 1991-04-19 | 3000.00 |    NULL |     20 |
|  7902 | FORD   | ANALYST   | 7566 | 1991-12-03 | 3000.00 |    NULL |     20 |
|  7839 | KING   | PRESIDENT | NULL | 1991-11-17 | 5000.00 |    NULL |     10 |
+-------+--------+-----------+------+------------+---------+---------+--------+
13 rows in set (0.00 sec)
```

- 按照部门号升序而员工的工资降序排列，显示员工信息

```SQL
mysql> select * from emp
    -> order by deptno , sal desc;
+-------+--------+-----------+------+------------+---------+---------+--------+
| empno | ename  | job       | mgr  | hiredate   | sal     | comm    | deptno |
+-------+--------+-----------+------+------------+---------+---------+--------+
|  7839 | KING   | PRESIDENT | NULL | 1991-11-17 | 5000.00 |    NULL |     10 |
|  7782 | CLARK  | MANAGER   | 7839 | 1991-06-09 | 2450.00 |    NULL |     10 |
|  7934 | MILLER | CLERK     | 7782 | 1991-01-23 | 1300.00 |    NULL |     10 |
|  7788 | SCOTT  | ANALYST   | 7566 | 1991-04-19 | 3000.00 |    NULL |     20 |
|  7902 | FORD   | ANALYST   | 7566 | 1991-12-03 | 3000.00 |    NULL |     20 |
|  7566 | JONES  | MANAGER   | 7839 | 1991-04-02 | 2975.00 |    NULL |     20 |
|  7369 | SMITH  | CLERK     | 7902 | 1990-12-17 |  800.00 |    NULL |     20 |
|  7698 | BLAKE  | MANAGER   | 7839 | 1991-05-01 | 2850.00 |    NULL |     30 |
|  7499 | ALLEN  | SALESMAN  | 7698 | 1991-02-20 | 1600.00 |  300.00 |     30 |
|  7844 | TURNER | SALESMAN  | 7698 | 1991-09-08 | 1500.00 |    NULL |     30 |
|  7521 | WARD   | SALESMAN  | 7968 | 1991-02-22 | 1250.00 |  500.00 |     30 |
|  7654 | MARTIN | SALESMAN  | 7968 | 1991-09-28 | 1250.00 | 1400.00 |     30 |
|  7900 | JAMES  | CLERK     | 7698 | 1991-12-03 |  950.00 |    NULL |     30 |
+-------+--------+-----------+------+------------+---------+---------+--------+
13 rows in set (0.00 sec)
```

### 分页查询

- 基本语法

```SQL
select ... limit start, rows
表示从start + 1行开始取，去除rows行，start从0开始计算
```
- 按员工的id升序取出，每页显示3条记录，分别显示第一页，第二页，第三页

```SQL
#第一页
mysql> select * from emp
    -> order by empno
    -> limit 0,3;
+-------+-------+----------+------+------------+---------+--------+--------+
| empno | ename | job      | mgr  | hiredate   | sal     | comm   | deptno |
+-------+-------+----------+------+------------+---------+--------+--------+
|  7369 | SMITH | CLERK    | 7902 | 1990-12-17 |  800.00 |   NULL |     20 |
|  7499 | ALLEN | SALESMAN | 7698 | 1991-02-20 | 1600.00 | 300.00 |     30 |
|  7521 | WARD  | SALESMAN | 7968 | 1991-02-22 | 1250.00 | 500.00 |     30 |
+-------+-------+----------+------+------------+---------+--------+--------+
3 rows in set (0.00 sec)

#第二页
mysql> select * from emp
    -> order by empno
    -> limit 3,3;
+-------+--------+----------+------+------------+---------+---------+--------+
| empno | ename  | job      | mgr  | hiredate   | sal     | comm    | deptno |
+-------+--------+----------+------+------------+---------+---------+--------+
|  7566 | JONES  | MANAGER  | 7839 | 1991-04-02 | 2975.00 |    NULL |     20 |
|  7654 | MARTIN | SALESMAN | 7968 | 1991-09-28 | 1250.00 | 1400.00 |     30 |
|  7698 | BLAKE  | MANAGER  | 7839 | 1991-05-01 | 2850.00 |    NULL |     30 |
+-------+--------+----------+------+------------+---------+---------+--------+
3 rows in set (0.00 sec)

#第三页
mysql> select * from emp
    -> order by empno
    -> limit 6,3;
+-------+-------+-----------+------+------------+---------+------+--------+
| empno | ename | job       | mgr  | hiredate   | sal     | comm | deptno |
+-------+-------+-----------+------+------------+---------+------+--------+
|  7782 | CLARK | MANAGER   | 7839 | 1991-06-09 | 2450.00 | NULL |     10 |
|  7788 | SCOTT | ANALYST   | 7566 | 1991-04-19 | 3000.00 | NULL |     20 |
|  7839 | KING  | PRESIDENT | NULL | 1991-11-17 | 5000.00 | NULL |     10 |
+-------+-------+-----------+------+------------+---------+------+--------+
3 rows in set (0.00 sec)

#推导分页的公式
SELECT * FROM emp
	ORDER BY empno
	LIMIT 每页显示记录数 * (第几页 - 1),每页显示记录数
#note limit后需要一个准确的数字
```

- 按雇员的empno降序取出，每页显示5条记录，分别显示第3页，第五页的sql语句

```SQL
#第三页
SELECT * FROM emp
	ORDER BY empno
	LIMIT 10,5;

#第五页
SELECT * FROM emp
	ORDER BY empno
	LIMIT 20,5
```

### 增强group by

- 显示每种岗位的员工总数，平均工资

```SQL
mysql> select count(*),avg(sal),job
    -> from emp
    -> group by job;
+----------+-------------+-----------+
| count(*) | avg(sal)    | job       |
+----------+-------------+-----------+
|        3 | 1016.666667 | CLERK     |
|        4 | 1400.000000 | SALESMAN  |
|        3 | 2758.333333 | MANAGER   |
|        2 | 3000.000000 | ANALYST   |
|        1 | 5000.000000 | PRESIDENT |
+----------+-------------+-----------+
5 rows in set (0.00 sec)
```
- 显示员工总数，以及获得补助(comm字段，列) 的员工数

```SQL
#获得补助就是comm字段非NULL，count(列)不会统计NULL

mysql> select count(*),count(comm) from emp;
+----------+-------------+
| count(*) | count(comm) |
+----------+-------------+
|       13 |           3 |
+----------+-------------+
1 row in set (0.00 sec)

-- 统计所有没有获得补助的员工数量
mysql> select count(if(comm is null,1,null)) from emp;
+--------------------------------+
| count(if(comm is null,1,null)) |
+--------------------------------+
|                             10 |
+--------------------------------+
1 row in set (0.00 sec)
```

- 显示管理的总人数

```SQL
mysql> select count(distinct mgr) from emp;
+---------------------+
| count(distinct mgr) |
+---------------------+
|                   6 |
+---------------------+
1 row in set (0.00 sec)
```
- 显示员工工资的最大差额

```SQL
mysql> select max(sal) - min(sal) from emp;
+---------------------+
| max(sal) - min(sal) |
+---------------------+
|             4200.00 |
+---------------------+
1 row in set (0.00 sec)
```

- 优先级

```SQL
如果select语句同时包含 group by, having,limit, order by
那么它们的顺序是 group by, having,order by, limit

SELECT column1,column2 ... FROM table_name
	group by column
	having condition
	order by column
	limit start,rows; 
```

- 统计各部门的平均工资，并大于1K，并按照平均工资降序排列，取出前两行记录

```SQL
mysql> select deptno,AVG(sal) as avg_sal
    -> from emp
    -> group by deptno 
    -> having avg_sal > 1000
    -> order by avg_sal DESC
    -> limit 0,2;
+--------+-------------+
| deptno | avg_sal     |
+--------+-------------+
|     10 | 2916.666667 |
|     20 | 2443.750000 |
+--------+-------------+
2 rows in set (0.00 sec)
```


## 多表查询

```SQL
在默认情况下，当两张表查询时：
从第一张表中，取出一行，和第二张表的每一行进行组合，返回结果[含有两张表的所有列]

一共返回的记录数为  第一张表行数 * 第二张表的行数

这种多表查询默认处理返回的结果，称为 笛卡尔集

处理多表的关键就是写出正确的过滤条件

note: 多表查询的条件不能少于 表的个数-1， 否则会出现笛卡尔集
```

```SQL
#回顾下dept表，共4行信息

mysql> select * from dept;
+--------+------------+----------+
| deptno | dname      | loc      |
+--------+------------+----------+
|     10 | ACCOUNTING | NEW YORK |
|     20 | RESEARCH   | DALLAS   |
|     30 | SALES      | CHICAGO  |
|     40 | OPERATIONS | BOSHTON  |
+--------+------------+----------+
4 rows in set (0.00 sec)

#emp表，共13行信息

mysql> select * from emp;
+-------+--------+-----------+------+------------+---------+---------+--------+
| empno | ename  | job       | mgr  | hiredate   | sal     | comm    | deptno |
+-------+--------+-----------+------+------------+---------+---------+--------+
|  7369 | SMITH  | CLERK     | 7902 | 1990-12-17 |  800.00 |    NULL |     20 |
|  7499 | ALLEN  | SALESMAN  | 7698 | 1991-02-20 | 1600.00 |  300.00 |     30 |
|  7521 | WARD   | SALESMAN  | 7968 | 1991-02-22 | 1250.00 |  500.00 |     30 |
|  7566 | JONES  | MANAGER   | 7839 | 1991-04-02 | 2975.00 |    NULL |     20 |
|  7654 | MARTIN | SALESMAN  | 7968 | 1991-09-28 | 1250.00 | 1400.00 |     30 |
|  7698 | BLAKE  | MANAGER   | 7839 | 1991-05-01 | 2850.00 |    NULL |     30 |
|  7782 | CLARK  | MANAGER   | 7839 | 1991-06-09 | 2450.00 |    NULL |     10 |
|  7788 | SCOTT  | ANALYST   | 7566 | 1991-04-19 | 3000.00 |    NULL |     20 |
|  7839 | KING   | PRESIDENT | NULL | 1991-11-17 | 5000.00 |    NULL |     10 |
|  7844 | TURNER | SALESMAN  | 7698 | 1991-09-08 | 1500.00 |    NULL |     30 |
|  7900 | JAMES  | CLERK     | 7698 | 1991-12-03 |  950.00 |    NULL |     30 |
|  7902 | FORD   | ANALYST   | 7566 | 1991-12-03 | 3000.00 |    NULL |     20 |
|  7934 | MILLER | CLERK     | 7782 | 1991-01-23 | 1300.00 |    NULL |     10 |
+-------+--------+-----------+------+------------+---------+---------+--------+
13 rows in set (0.00 sec)

而直接查询两张表的结果如下，共53行，13 * 4 = 52
mysql> select * from emp,dept;
+-------+--------+-----------+------+------------+---------+---------+--------+--------+------------+----------+
| empno | ename  | job       | mgr  | hiredate   | sal     | comm    | deptno | deptno | dname      | loc      |
+-------+--------+-----------+------+------------+---------+---------+--------+--------+------------+----------+
|  7369 | SMITH  | CLERK     | 7902 | 1990-12-17 |  800.00 |    NULL |     20 |     40 | OPERATIONS | BOSHTON  |
|  7369 | SMITH  | CLERK     | 7902 | 1990-12-17 |  800.00 |    NULL |     20 |     30 | SALES      | CHICAGO  |
|  7369 | SMITH  | CLERK     | 7902 | 1990-12-17 |  800.00 |    NULL |     20 |     20 | RESEARCH   | DALLAS   |
|  7369 | SMITH  | CLERK     | 7902 | 1990-12-17 |  800.00 |    NULL |     20 |     10 | ACCOUNTING | NEW YORK |
|  7499 | ALLEN  | SALESMAN  | 7698 | 1991-02-20 | 1600.00 |  300.00 |     30 |     40 | OPERATIONS | BOSHTON  |
|  7499 | ALLEN  | SALESMAN  | 7698 | 1991-02-20 | 1600.00 |  300.00 |     30 |     30 | SALES      | CHICAGO  |
|  7499 | ALLEN  | SALESMAN  | 7698 | 1991-02-20 | 1600.00 |  300.00 |     30 |     20 | RESEARCH   | DALLAS   |
|  7499 | ALLEN  | SALESMAN  | 7698 | 1991-02-20 | 1600.00 |  300.00 |     30 |     10 | ACCOUNTING | NEW YORK |
|  7521 | WARD   | SALESMAN  | 7968 | 1991-02-22 | 1250.00 |  500.00 |     30 |     40 | OPERATIONS | BOSHTON  |
|  7521 | WARD   | SALESMAN  | 7968 | 1991-02-22 | 1250.00 |  500.00 |     30 |     30 | SALES      | CHICAGO  |
|  7521 | WARD   | SALESMAN  | 7968 | 1991-02-22 | 1250.00 |  500.00 |     30 |     20 | RESEARCH   | DALLAS   |
|  7521 | WARD   | SALESMAN  | 7968 | 1991-02-22 | 1250.00 |  500.00 |     30 |     10 | ACCOUNTING | NEW YORK |
|  7566 | JONES  | MANAGER   | 7839 | 1991-04-02 | 2975.00 |    NULL |     20 |     40 | OPERATIONS | BOSHTON  |
|  7566 | JONES  | MANAGER   | 7839 | 1991-04-02 | 2975.00 |    NULL |     20 |     30 | SALES      | CHICAGO  |
|  7566 | JONES  | MANAGER   | 7839 | 1991-04-02 | 2975.00 |    NULL |     20 |     20 | RESEARCH   | DALLAS   |
|  7566 | JONES  | MANAGER   | 7839 | 1991-04-02 | 2975.00 |    NULL |     20 |     10 | ACCOUNTING | NEW YORK |
|  7654 | MARTIN | SALESMAN  | 7968 | 1991-09-28 | 1250.00 | 1400.00 |     30 |     40 | OPERATIONS | BOSHTON  |
|  7654 | MARTIN | SALESMAN  | 7968 | 1991-09-28 | 1250.00 | 1400.00 |     30 |     30 | SALES      | CHICAGO  |
|  7654 | MARTIN | SALESMAN  | 7968 | 1991-09-28 | 1250.00 | 1400.00 |     30 |     20 | RESEARCH   | DALLAS   |
|  7654 | MARTIN | SALESMAN  | 7968 | 1991-09-28 | 1250.00 | 1400.00 |     30 |     10 | ACCOUNTING | NEW YORK |
|  7698 | BLAKE  | MANAGER   | 7839 | 1991-05-01 | 2850.00 |    NULL |     30 |     40 | OPERATIONS | BOSHTON  |
|  7698 | BLAKE  | MANAGER   | 7839 | 1991-05-01 | 2850.00 |    NULL |     30 |     30 | SALES      | CHICAGO  |
|  7698 | BLAKE  | MANAGER   | 7839 | 1991-05-01 | 2850.00 |    NULL |     30 |     20 | RESEARCH   | DALLAS   |
|  7698 | BLAKE  | MANAGER   | 7839 | 1991-05-01 | 2850.00 |    NULL |     30 |     10 | ACCOUNTING | NEW YORK |
|  7782 | CLARK  | MANAGER   | 7839 | 1991-06-09 | 2450.00 |    NULL |     10 |     40 | OPERATIONS | BOSHTON  |
|  7782 | CLARK  | MANAGER   | 7839 | 1991-06-09 | 2450.00 |    NULL |     10 |     30 | SALES      | CHICAGO  |
|  7782 | CLARK  | MANAGER   | 7839 | 1991-06-09 | 2450.00 |    NULL |     10 |     20 | RESEARCH   | DALLAS   |
|  7782 | CLARK  | MANAGER   | 7839 | 1991-06-09 | 2450.00 |    NULL |     10 |     10 | ACCOUNTING | NEW YORK |
|  7788 | SCOTT  | ANALYST   | 7566 | 1991-04-19 | 3000.00 |    NULL |     20 |     40 | OPERATIONS | BOSHTON  |
|  7788 | SCOTT  | ANALYST   | 7566 | 1991-04-19 | 3000.00 |    NULL |     20 |     30 | SALES      | CHICAGO  |
|  7788 | SCOTT  | ANALYST   | 7566 | 1991-04-19 | 3000.00 |    NULL |     20 |     20 | RESEARCH   | DALLAS   |
|  7788 | SCOTT  | ANALYST   | 7566 | 1991-04-19 | 3000.00 |    NULL |     20 |     10 | ACCOUNTING | NEW YORK |
|  7839 | KING   | PRESIDENT | NULL | 1991-11-17 | 5000.00 |    NULL |     10 |     40 | OPERATIONS | BOSHTON  |
|  7839 | KING   | PRESIDENT | NULL | 1991-11-17 | 5000.00 |    NULL |     10 |     30 | SALES      | CHICAGO  |
|  7839 | KING   | PRESIDENT | NULL | 1991-11-17 | 5000.00 |    NULL |     10 |     20 | RESEARCH   | DALLAS   |
|  7839 | KING   | PRESIDENT | NULL | 1991-11-17 | 5000.00 |    NULL |     10 |     10 | ACCOUNTING | NEW YORK |
|  7844 | TURNER | SALESMAN  | 7698 | 1991-09-08 | 1500.00 |    NULL |     30 |     40 | OPERATIONS | BOSHTON  |
|  7844 | TURNER | SALESMAN  | 7698 | 1991-09-08 | 1500.00 |    NULL |     30 |     30 | SALES      | CHICAGO  |
|  7844 | TURNER | SALESMAN  | 7698 | 1991-09-08 | 1500.00 |    NULL |     30 |     20 | RESEARCH   | DALLAS   |
|  7844 | TURNER | SALESMAN  | 7698 | 1991-09-08 | 1500.00 |    NULL |     30 |     10 | ACCOUNTING | NEW YORK |
|  7900 | JAMES  | CLERK     | 7698 | 1991-12-03 |  950.00 |    NULL |     30 |     40 | OPERATIONS | BOSHTON  |
|  7900 | JAMES  | CLERK     | 7698 | 1991-12-03 |  950.00 |    NULL |     30 |     30 | SALES      | CHICAGO  |
|  7900 | JAMES  | CLERK     | 7698 | 1991-12-03 |  950.00 |    NULL |     30 |     20 | RESEARCH   | DALLAS   |
|  7900 | JAMES  | CLERK     | 7698 | 1991-12-03 |  950.00 |    NULL |     30 |     10 | ACCOUNTING | NEW YORK |
|  7902 | FORD   | ANALYST   | 7566 | 1991-12-03 | 3000.00 |    NULL |     20 |     40 | OPERATIONS | BOSHTON  |
|  7902 | FORD   | ANALYST   | 7566 | 1991-12-03 | 3000.00 |    NULL |     20 |     30 | SALES      | CHICAGO  |
|  7902 | FORD   | ANALYST   | 7566 | 1991-12-03 | 3000.00 |    NULL |     20 |     20 | RESEARCH   | DALLAS   |
|  7902 | FORD   | ANALYST   | 7566 | 1991-12-03 | 3000.00 |    NULL |     20 |     10 | ACCOUNTING | NEW YORK |
|  7934 | MILLER | CLERK     | 7782 | 1991-01-23 | 1300.00 |    NULL |     10 |     40 | OPERATIONS | BOSHTON  |
|  7934 | MILLER | CLERK     | 7782 | 1991-01-23 | 1300.00 |    NULL |     10 |     30 | SALES      | CHICAGO  |
|  7934 | MILLER | CLERK     | 7782 | 1991-01-23 | 1300.00 |    NULL |     10 |     20 | RESEARCH   | DALLAS   |
|  7934 | MILLER | CLERK     | 7782 | 1991-01-23 | 1300.00 |    NULL |     10 |     10 | ACCOUNTING | NEW YORK |
+-------+--------+-----------+------+------------+---------+---------+--------+--------+------------+----------+
52 rows in set (0.00 sec)
```

- 显示员工名，员工工资及所在部门 [笛卡尔集]

```SQL
#员工名，员工工资来自emp表
#部门名来自dept表
#需要对emp和dept查询

mysql> select ename,sal,dname from emp,dept
    -> where emp.deptno = dept.deptno;
+--------+---------+------------+
| ename  | sal     | dname      |
+--------+---------+------------+
| SMITH  |  800.00 | RESEARCH   |
| ALLEN  | 1600.00 | SALES      |
| WARD   | 1250.00 | SALES      |
| JONES  | 2975.00 | RESEARCH   |
| MARTIN | 1250.00 | SALES      |
| BLAKE  | 2850.00 | SALES      |
| CLARK  | 2450.00 | ACCOUNTING |
| SCOTT  | 3000.00 | RESEARCH   |
| KING   | 5000.00 | ACCOUNTING |
| TURNER | 1500.00 | SALES      |
| JAMES  |  950.00 | SALES      |
| FORD   | 3000.00 | RESEARCH   |
| MILLER | 1300.00 | ACCOUNTING |
+--------+---------+------------+
13 rows in set (0.00 sec)

#当需要再显示deptno字段信息时
#note: 需要指定某个表的列的时候，使用 表.列名

mysql> select ename,sal,dname,emp.deptno
    -> from emp,dept
    -> where emp.deptno = dept.deptno;
+--------+---------+------------+--------+
| ename  | sal     | dname      | deptno |
+--------+---------+------------+--------+
| SMITH  |  800.00 | RESEARCH   |     20 |
| ALLEN  | 1600.00 | SALES      |     30 |
| WARD   | 1250.00 | SALES      |     30 |
| JONES  | 2975.00 | RESEARCH   |     20 |
| MARTIN | 1250.00 | SALES      |     30 |
| BLAKE  | 2850.00 | SALES      |     30 |
| CLARK  | 2450.00 | ACCOUNTING |     10 |
| SCOTT  | 3000.00 | RESEARCH   |     20 |
| KING   | 5000.00 | ACCOUNTING |     10 |
| TURNER | 1500.00 | SALES      |     30 |
| JAMES  |  950.00 | SALES      |     30 |
| FORD   | 3000.00 | RESEARCH   |     20 |
| MILLER | 1300.00 | ACCOUNTING |     10 |
+--------+---------+------------+--------+
13 rows in set (0.00 sec)
```
- 显示部门号为10的部门名，员工名和工资

```SQL
mysql> select ename,sal,dname,emp.deptno
    -> from emp,dept
    -> where emp.deptno = dept.deptno AND emp.deptno = 10;
+--------+---------+------------+--------+
| ename  | sal     | dname      | deptno |
+--------+---------+------------+--------+
| CLARK  | 2450.00 | ACCOUNTING |     10 |
| KING   | 5000.00 | ACCOUNTING |     10 |
| MILLER | 1300.00 | ACCOUNTING |     10 |
+--------+---------+------------+--------+
3 rows in set (0.00 sec)
```

- 显示各个员工的姓名，工资，以及工资的级别

```SQL
#先回顾下表salgrade
mysql> select * from salgrade;
+-------+---------+---------+
| grade | losal   | hisal   |
+-------+---------+---------+
|     1 |  700.00 | 1200.00 |
|     2 | 1201.00 | 1400.00 |
|     3 | 1401.00 | 2000.00 |
|     4 | 2001.00 | 3000.00 |
|     5 | 3001.00 | 9999.00 |
+-------+---------+---------+
5 rows in set (0.00 sec)


mysql> select ename,sal,grade
    -> from emp,salgrade
    -> where sal between losal AND hisal;
+--------+---------+-------+
| ename  | sal     | grade |
+--------+---------+-------+
| SMITH  |  800.00 |     1 |
| ALLEN  | 1600.00 |     3 |
| WARD   | 1250.00 |     2 |
| JONES  | 2975.00 |     4 |
| MARTIN | 1250.00 |     2 |
| BLAKE  | 2850.00 |     4 |
| CLARK  | 2450.00 |     4 |
| SCOTT  | 3000.00 |     4 |
| KING   | 5000.00 |     5 |
| TURNER | 1500.00 |     3 |
| JAMES  |  950.00 |     1 |
| FORD   | 3000.00 |     4 |
| MILLER | 1300.00 |     2 |
+--------+---------+-------+
13 rows in set (0.00 sec)
```

#### 多表查询的自连接

```SQL
自连接的特点
	把同一张表当作两张表使用
	需要给表取别名		表名	表的别名
	列名不明确(重复)时，可以指定列的别名	列名 as 列的别名
```

- 显示公司员工和他上级的名字

```SQL
mysql> select worker.ename AS '员工名', boss.ename AS '上级名'
    -> from emp worker, emp boss
    -> where worker.mgr = boss.empno;
+-----------+-----------+
| 员工名    | 上级名    |
+-----------+-----------+
| FORD      | JONES     |
| SCOTT     | JONES     |
| JAMES     | BLAKE     |
| TURNER    | BLAKE     |
| ALLEN     | BLAKE     |
| MILLER    | CLARK     |
| CLARK     | KING      |
| BLAKE     | KING      |
| JONES     | KING      |
| SMITH     | FORD      |
+-----------+-----------+
10 rows in set (0.00 sec)

#note：from emp worker, emp boss中，emp和worker的关系为worker时emp的别名，可以省略
```

### 子查询

- 子查询
	* 子查询是指嵌入在其他sql语句中的select子句，也叫嵌套查询
- 单行子查询
	* 指只返回一行数据的子查询语句
- 多行子查询
	* 指返回多行数据的子查询，用关键字 in


- 如何显示与SMITH同一部门的所有员工(单行查询)

```SQL
#先查询SMITH的部门编号
mysql> select deptno from emp
    -> where ename = 'SMITH';
+--------+
| deptno |
+--------+
|     20 |
+--------+
1 row in set (0.00 sec)

#根据得到的部门编号再筛选
mysql> select * from emp
    -> where deptno = (
    -> select deptno from emp
    -> where ename = 'SMITH'
    -> );
+-------+-------+---------+------+------------+---------+------+--------+
| empno | ename | job     | mgr  | hiredate   | sal     | comm | deptno |
+-------+-------+---------+------+------------+---------+------+--------+
|  7369 | SMITH | CLERK   | 7902 | 1990-12-17 |  800.00 | NULL |     20 |
|  7566 | JONES | MANAGER | 7839 | 1991-04-02 | 2975.00 | NULL |     20 |
|  7788 | SCOTT | ANALYST | 7566 | 1991-04-19 | 3000.00 | NULL |     20 |
|  7902 | FORD  | ANALYST | 7566 | 1991-12-03 | 3000.00 | NULL |     20 |
+-------+-------+---------+------+------------+---------+------+--------+
4 rows in set (0.00 sec)
```

- 如何查询和部门10的工作相同的员工的,名字、岗位、工资、部门号，但是不包含10自己的(多行子查询)

```SQL
#首先查询部门为10的岗位
mysql> select job from emp
    -> where deptno = 10;
+-----------+
| job       |
+-----------+
| MANAGER   |
| PRESIDENT |
| CLERK     |
+-----------+
3 rows in set (0.00 sec)

#在进行多行子查询
mysql> select ename,job,sal,deptno from emp
    -> where job IN (
    -> select distinct job from emp
    -> where deptno = 10
    -> );
+--------+-----------+---------+--------+
| ename  | job       | sal     | deptno |
+--------+-----------+---------+--------+
| SMITH  | CLERK     |  800.00 |     20 |
| JONES  | MANAGER   | 2975.00 |     20 |
| BLAKE  | MANAGER   | 2850.00 |     30 |
| CLARK  | MANAGER   | 2450.00 |     10 |
| KING   | PRESIDENT | 5000.00 |     10 |
| JAMES  | CLERK     |  950.00 |     30 |
| MILLER | CLERK     | 1300.00 |     10 |
+--------+-----------+---------+--------+
7 rows in set (0.00 sec)

#最后过滤出不包含10的信息
mysql> select ename,job,sal,deptno from emp
    -> where job IN (
    -> select distinct job from emp
    -> where deptno = 10
    -> ) AND deptno <> 10;
+-------+---------+---------+--------+
| ename | job     | sal     | deptno |
+-------+---------+---------+--------+
| SMITH | CLERK   |  800.00 |     20 |
| JONES | MANAGER | 2975.00 |     20 |
| BLAKE | MANAGER | 2850.00 |     30 |
| JAMES | CLERK   |  950.00 |     30 |
+-------+---------+---------+--------+
4 rows in set (0.00 sec)

#note: != 和 <> 都是不等于
```

#### 将子查询当作临时表

待补充


#### all和any

- 显示工资比部门30的所有员工的工资高的员工的姓名，工资和部门号

```SQL
#使用all
mysql> select ename,sal,deptno from emp
    -> where sal > all(
    -> select sal from emp
    -> where deptno = 30
    -> );
+-------+---------+--------+
| ename | sal     | deptno |
+-------+---------+--------+
| JONES | 2975.00 |     20 |
| SCOTT | 3000.00 |     20 |
| KING  | 5000.00 |     10 |
| FORD  | 3000.00 |     20 |
+-------+---------+--------+
4 rows in set (0.00 sec)

#使用max()
mysql> select ename,sal,deptno from emp
    -> where sal > (
    -> select MAX(sal) from emp
    -> where deptno = 30
    -> );
+-------+---------+--------+
| ename | sal     | deptno |
+-------+---------+--------+
| JONES | 2975.00 |     20 |
| SCOTT | 3000.00 |     20 |
| KING  | 5000.00 |     10 |
| FORD  | 3000.00 |     20 |
+-------+---------+--------+
4 rows in set (0.00 sec)
```

- 如何显示工资比部门30的其中一个员工的工资高的员工的姓名，工资和部门号

```SQL
#使用any
mysql> select ename,sal,deptno from emp
    -> where sal > any(
    -> select sal from emp
    -> where deptno = 30
    -> );
+--------+---------+--------+
| ename  | sal     | deptno |
+--------+---------+--------+
| ALLEN  | 1600.00 |     30 |
| WARD   | 1250.00 |     30 |
| JONES  | 2975.00 |     20 |
| MARTIN | 1250.00 |     30 |
| BLAKE  | 2850.00 |     30 |
| CLARK  | 2450.00 |     10 |
| SCOTT  | 3000.00 |     20 |
| KING   | 5000.00 |     10 |
| TURNER | 1500.00 |     30 |
| FORD   | 3000.00 |     20 |
| MILLER | 1300.00 |     10 |
+--------+---------+--------+
11 rows in set (0.00 sec)

#使用min()
mysql> select ename,sal,deptno from emp
    -> where sal > (
    -> select min(sal) from emp
    -> where deptno = 30
    -> );
+--------+---------+--------+
| ename  | sal     | deptno |
+--------+---------+--------+
| ALLEN  | 1600.00 |     30 |
| WARD   | 1250.00 |     30 |
| JONES  | 2975.00 |     20 |
| MARTIN | 1250.00 |     30 |
| BLAKE  | 2850.00 |     30 |
| CLARK  | 2450.00 |     10 |
| SCOTT  | 3000.00 |     20 |
| KING   | 5000.00 |     10 |
| TURNER | 1500.00 |     30 |
| FORD   | 3000.00 |     20 |
| MILLER | 1300.00 |     10 |
+--------+---------+--------+
11 rows in set (0.00 sec)
```
 
#### 多列子查询

- 多列子查询指查询返回多个列数据的子查询

- 查询与ALLEN的部门和岗位完全相同的所有员工(并且不含SMITH)

```SQL
mysql> select * from emp
    -> where (deptno,job) = (
    -> select deptno,job from emp
    -> where ename = 'ALLEN'
    -> ) AND ename <> 'ALLEN';
+-------+--------+----------+------+------------+---------+---------+--------+
| empno | ename  | job      | mgr  | hiredate   | sal     | comm    | deptno |
+-------+--------+----------+------+------------+---------+---------+--------+
|  7521 | WARD   | SALESMAN | 7968 | 1991-02-22 | 1250.00 |  500.00 |     30 |
|  7654 | MARTIN | SALESMAN | 7968 | 1991-09-28 | 1250.00 | 1400.00 |     30 |
|  7844 | TURNER | SALESMAN | 7698 | 1991-09-08 | 1500.00 |    NULL |     30 |
+-------+--------+----------+------+------------+---------+---------+--------+
3 rows in set (0.00 sec)
```

 ##### 子查询练习

- 查找每个部门工资高于本部门平均工资的员工资料

```SQL
#这里会用到将一个子查询当作一个临时表使用
#首先得到每个部門的部門號和對應的平均工資
mysql> select deptno,AVG(sal) as avg_sal from emp
    -> group by deptno;
+--------+-------------+
| deptno | avg_sal     |
+--------+-------------+
|     20 | 2443.750000 |
|     30 | 1566.666667 |
|     10 | 2916.666667 |
+--------+-------------+
3 rows in set (0.00 sec)

#將上面的結果當作子查詢，和emp表進行多表查詢
mysql> SELECT ename,sal,temp.avg_sal,emp.`deptno`
    ->  FROM emp,(
    ->          SELECT deptno,AVG(sal) AS avg_sal
    ->          FROM emp
    ->          GROUP BY deptno
    ->          ) temp
    ->          WHERE emp.deptno = temp.deptno AND emp.sal > temp.avg_sal;
+-------+---------+-------------+--------+
| ename | sal     | avg_sal     | deptno |
+-------+---------+-------------+--------+
| ALLEN | 1600.00 | 1566.666667 |     30 |
| JONES | 2975.00 | 2443.750000 |     20 |
| BLAKE | 2850.00 | 1566.666667 |     30 |
| SCOTT | 3000.00 | 2443.750000 |     20 |
| KING  | 5000.00 | 2916.666667 |     10 |
| FORD  | 3000.00 | 2443.750000 |     20 |
+-------+---------+-------------+--------+
6 rows in set (0.00 sec)
```

- 查找每個部門工資最高的人的詳細資料

```SQL
#首先查找部門最高工資
mysql> select deptno,max(sal) from emp
    -> group by deptno;
+--------+----------+
| deptno | max(sal) |
+--------+----------+
|     20 |  3000.00 |
|     30 |  2850.00 |
|     10 |  5000.00 |
+--------+----------+
3 rows in set (0.00 sec)

#再根據上賣弄的最高工資進行多表查詢
mysql> SELECT *
    ->  FROM emp, (
    ->          SELECT deptno,MAX(sal)AS max_sal
    ->          FROM emp
    ->          GROUP BY deptno
    ->  ) temp
    ->  WHERE emp.deptno = temp.deptno AND emp.sal = temp.max_sal;
+-------+-------+-----------+------+------------+---------+------+--------+--------+---------+
| empno | ename | job       | mgr  | hiredate   | sal     | comm | deptno | deptno | max_sal |
+-------+-------+-----------+------+------------+---------+------+--------+--------+---------+
|  7698 | BLAKE | MANAGER   | 7839 | 1991-05-01 | 2850.00 | NULL |     30 |     30 | 2850.00 |
|  7788 | SCOTT | ANALYST   | 7566 | 1991-04-19 | 3000.00 | NULL |     20 |     20 | 3000.00 |
|  7839 | KING  | PRESIDENT | NULL | 1991-11-17 | 5000.00 | NULL |     10 |     10 | 5000.00 |
|  7902 | FORD  | ANALYST   | 7566 | 1991-12-03 | 3000.00 | NULL |     20 |     20 | 3000.00 |
+-------+-------+-----------+------+------------+---------+------+--------+--------+---------+
4 rows in set (0.00 sec)
```
- 查詢每個部門的信息(部門名，編號，地址)和人員數量

```SQL
#先查詢每個部門的人數
mysql> select deptno,count(*) from emp
    -> group by deptno;
+--------+----------+
| deptno | count(*) |
+--------+----------+
|     20 |        4 |
|     30 |        6 |
|     10 |        3 |
+--------+----------+
3 rows in set (0.00 sec)

#再將上賣弄的結果作爲一張臨時表進行多表查詢
mysql> SELECT dname,dept.deptno,loc,tmp.per_num AS '人數'
    ->  FROM dept,(
    ->          SELECT COUNT(*) AS per_num,deptno FROM emp
    ->          GROUP BY deptno
    ->  ) tmp
    ->  WHERE tmp.deptno = dept.`deptno`;
+------------+--------+----------+--------+
| dname      | deptno | loc      | 人數   |
+------------+--------+----------+--------+
| ACCOUNTING |     10 | NEW YORK |      3 |
| RESEARCH   |     20 | DALLAS   |      4 |
| SALES      |     30 | CHICAGO  |      6 |
+------------+--------+----------+--------+
3 rows in set (0.00 sec)

#另一種寫法，簡化寫法
mysql> SELECT tmp.*,dname,loc
    ->  FROM dept,(
    ->          SELECT COUNT(*) AS per_num,deptno FROM emp
    ->          GROUP BY deptno
    ->  ) tmp
    ->  WHERE tmp.deptno = dept.`deptno`;
+---------+--------+------------+----------+
| per_num | deptno | dname      | loc      |
+---------+--------+------------+----------+
|       3 |     10 | ACCOUNTING | NEW YORK |
|       4 |     20 | RESEARCH   | DALLAS   |
|       6 |     30 | SALES      | CHICAGO  |
+---------+--------+------------+----------+
3 rows in set (0.00 sec)
```


#### 表的复制和去重

- 复制表

```SQL
#先创建一张表
CREATE TABLE my_table01
	( id INT,
	`name` VARCHAR(32),
	sal DOUBLE,
	job VARCHAR(32),
	deptno INT);

#查询下表结构
mysql> DESC my_table01;
+--------+-------------+------+-----+---------+-------+
| Field  | Type        | Null | Key | Default | Extra |
+--------+-------------+------+-----+---------+-------+
| id     | int         | YES  |     | NULL    |       |
| name   | varchar(32) | YES  |     | NULL    |       |
| sal    | double      | YES  |     | NULL    |       |
| job    | varchar(32) | YES  |     | NULL    |       |
| deptno | int         | YES  |     | NULL    |       |
+--------+-------------+------+-----+---------+-------+
5 rows in set (0.00 sec)

#此时是一张空表,接着插入数据
INSERT INTO my_table01 (id,`name`,sal,job,deptno)
	SELECT empno,ename,sal,job,deptno FROM emp;
#从emp表取出相关字段插入my_table01中,这种方法不需要VALUES关键字

#自我复制(每执行一次就指数级增长一次)
INSERT INTO my_table01
	SELECT * FROM my_table01
```
- 去重

```SQL
#首先创建一张表my_table02
CREATE TABLE my_table02 LIKE emp; -- 此语句将emp表的结构(所有字段)复制到LIKE关键字前面的表名中

mysql> desc my_table02;
+----------+--------------------+------+-----+---------+-------+
| Field    | Type               | Null | Key | Default | Extra |
+----------+--------------------+------+-----+---------+-------+
| empno    | mediumint unsigned | NO   |     | 0       |       |
| ename    | varchar(20)        | NO   |     |         |       |
| job      | varchar(9)         | NO   |     |         |       |
| mgr      | mediumint unsigned | YES  |     | NULL    |       |
| hiredate | date               | NO   |     | NULL    |       |
| sal      | decimal(7,2)       | NO   |     | NULL    |       |
| comm     | decimal(7,2)       | YES  |     | NULL    |       |
| deptno   | mediumint unsigned | NO   |     | 0       |       |
+----------+--------------------+------+-----+---------+-------+
8 rows in set (0.00 sec)

#拷贝数据到my_table02
INSERT INTO my_table02
	SELECT * FROM emp;


#去重
#先创建一张临时表my_tmp,该表的结构和my_table02相同
#把my_table02的数据通过distinct处理后复制到my_tmp
#清除my_table02的数据
#将my_tmp的记录复制到my_table02
#drop掉临时表my_tmp


#先创建一张临时表my_tmp,该表的结构和my_table02相同
CREATE TABLE my_tmp LIKE my_table02;

#把my_table02的数据通过distinct处理后复制到my_tmp
INSERT INTO my_tmp
	SELECT DISTINCT * FROM my_table02;

#清除my_table02的数据
DELETE FROM my_table02;

#将my_tmp的记录复制到my_table02
mysql> insert into my_table02
    -> select * from my_tmp;
Query OK, 13 rows affected (0.01 sec)
Records: 13  Duplicates: 0  Warnings: 0

#drop掉临时表my_tmp
mysql> drop table my_tmp;
Query OK, 0 rows affected (0.01 sec)
```

#### 合并查询

- 有时需要合并多个select语句的结果,可以使用集合操作符号
	* ```union```,```union all```

- ```union all```用于取得2各结果集的并集,不会去重

```SQL
#得到5条数据
mysql> SELECT ename,sal,job FROM emp
    ->  WHERE sal > 2500;
+-------+---------+-----------+
| ename | sal     | job       |
+-------+---------+-----------+
| JONES | 2975.00 | MANAGER   |
| BLAKE | 2850.00 | MANAGER   |
| SCOTT | 3000.00 | ANALYST   |
| KING  | 5000.00 | PRESIDENT |
| FORD  | 3000.00 | ANALYST   |
+-------+---------+-----------+
5 rows in set (0.00 sec)

#得到3条数据
mysql> SELECT ename,sal,job FROM emp
    ->  WHERE job = 'MANAGER';
+-------+---------+---------+
| ename | sal     | job     |
+-------+---------+---------+
| JONES | 2975.00 | MANAGER |
| BLAKE | 2850.00 | MANAGER |
| CLARK | 2450.00 | MANAGER |
+-------+---------+---------+
3 rows in set (0.00 sec)

#使用union all得到8条数据(不会去重)
mysql> SELECT ename,sal,job FROM emp WHERE sal > 2500
    -> UNION ALL
    -> SELECT ename,sal,job FROM emp WHERE job = 'MANAGER';
+-------+---------+-----------+
| ename | sal     | job       |
+-------+---------+-----------+
| JONES | 2975.00 | MANAGER   |
| BLAKE | 2850.00 | MANAGER   |
| SCOTT | 3000.00 | ANALYST   |
| KING  | 5000.00 | PRESIDENT |
| FORD  | 3000.00 | ANALYST   |
| JONES | 2975.00 | MANAGER   |
| BLAKE | 2850.00 | MANAGER   |
| CLARK | 2450.00 | MANAGER   |
+-------+---------+-----------+
8 rows in set (0.00 sec)
```

- union,与union all相似,但会去重

```SQL
mysql> SELECT ename,sal,job FROM emp WHERE sal > 2500
    -> UNION
    -> SELECT ename,sal,job FROM emp WHERE job = 'MANAGER';
+-------+---------+-----------+
| ename | sal     | job       |
+-------+---------+-----------+
| JONES | 2975.00 | MANAGER   |
| BLAKE | 2850.00 | MANAGER   |
| SCOTT | 3000.00 | ANALYST   |
| KING  | 5000.00 | PRESIDENT |
| FORD  | 3000.00 | ANALYST   |
| CLARK | 2450.00 | MANAGER   |
+-------+---------+-----------+
6 rows in set (0.00 sec)   
```

#### 外连接

- 前面的查询,是利用where子句对两张或多张表,形成笛卡尔集进行筛选
	* 根据```关联条件```,显示所有匹配的记录,匹配不上的,不显示
- 为了解决上述问题,需要使用```外连接```
	* 左外连接(如果左侧的表完全显示,那么就是左外连接)
	* 右外连接(如果右侧的表完全显示,那么就是右外连接)

- 外连接的语法

```SQL
#左连接
select ... from 表1 left join 表2 on 条件

#右链接
select ... from 表1 right join 表2 on 条件
```

```SQL
#演示外连接
#先创建stu
CREATE TABLE stu (
	id INT,
	`name` VARCHAR(32));
	
INSERT INTO stu VALUES(1,'jack'),(2,'tom'),(3,'kity'),(4,'nono');

mysql> select * from stu;
+------+------+
| id   | name |
+------+------+
|    1 | jack |
|    2 | tom  |
|    3 | kity |
|    4 | nono |
+------+------+
4 rows in set (0.00 sec)

#创建exam
CREATE TABLE exam (
	id INT,
	grade INT);
	
INSERT INTO exam VALUES(1,56),(2,76),(11,8);

mysql> select * from exam;
+------+-------+
| id   | grade |
+------+-------+
|    1 |    56 |
|    2 |    76 |
|   11 |     8 |
+------+-------+
3 rows in set (0.00 sec)
```

- 使用左连接(显示所有人的成绩,若无,也要显示该人的姓名和id号,成绩显示为空)

```SQL
#之前的查询方法(无法实现题目要求)
mysql> SELECT `name`,stu.id,grade
    ->  FROM stu,exam
    ->  WHERE stu.id = exam.`id`;
+------+------+-------+
| name | id   | grade |
+------+------+-------+
| jack |    1 |    56 |
| tom  |    2 |    76 |
+------+------+-------+
2 rows in set (0.00 sec)

#使用左连接
mysql> SELECT `name`,stu.id,grade
    ->  FROM stu LEFT JOIN exam
    ->  ON stu.id = exam.id;
+------+------+-------+
| name | id   | grade |
+------+------+-------+
| jack |    1 |    56 |
| tom  |    2 |    76 |
| kity |    3 |  NULL |
| nono |    4 |  NULL |
+------+------+-------+
4 rows in set (0.00 sec)
```
- 使用右外连接(显示所有成绩,如果没有名字匹配,显示空)

```SQL
mysql>  SELECT `name`,stu.id,grade
    ->  FROM stu RIGHT JOIN exam
    ->  ON stu.id = exam.`id`;
+------+------+-------+
| name | id   | grade |
+------+------+-------+
| jack |    1 |    56 |
| tom  |    2 |    76 |
| NULL | NULL |     8 |
+------+------+-------+
3 rows in set (0.00 sec)
```
- 现有需求列出部门名称和这些部门的员工名称和工作,同时显示出没有员工的部门

```SQL
#使用右外连接完成(结果在输出的最后一行)
mysql> SELECT dname,ename,job
    ->  FROM emp RIGHT JOIN dept
    ->  ON emp.deptno = dept.deptno;
+------------+--------+-----------+
| dname      | ename  | job       |
+------------+--------+-----------+
| ACCOUNTING | MILLER | CLERK     |
| ACCOUNTING | KING   | PRESIDENT |
| ACCOUNTING | CLARK  | MANAGER   |
| RESEARCH   | FORD   | ANALYST   |
| RESEARCH   | SCOTT  | ANALYST   |
| RESEARCH   | JONES  | MANAGER   |
| RESEARCH   | SMITH  | CLERK     |
| SALES      | JAMES  | CLERK     |
| SALES      | TURNER | SALESMAN  |
| SALES      | BLAKE  | MANAGER   |
| SALES      | MARTIN | SALESMAN  |
| SALES      | WARD   | SALESMAN  |
| SALES      | ALLEN  | SALESMAN  |
| OPERATIONS | NULL   | NULL      |
+------------+--------+-----------+
14 rows in set (0.00 sec)
```

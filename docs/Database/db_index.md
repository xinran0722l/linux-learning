## MySQL索引

- 索引时提高数据库性能的最具性价比的
- 索引的类型
	* 主键索引,主键自动的为主索引(类型Primary Key)
	* 唯一索引(UNIQUE)
	* 普通索引(index)
	* 全文索引(fulltext) [适用于MyISAM,存储引擎]
		- fulltext性能不佳,一般用Solr和ElasticSearch替代

- 索引使用语法

```sql
#添加索引(建新表测试 id, name) index_use.sql
create [UNIQUE] index index_name ON table_name (col_name[(length)]
[ASC | DESC], ... );

alter table table_name ADD INDEX [index_name] (index_col_name,...);

#添加主键(索引)
alter table 表名 ADD primary key (列名,...);

#删除索引
DROP index index_name ON table_name;

alter table table_name DROP index index_name;

#删除主键索引
alter table table_name DROP primary key;
```

#### 索引使用

```sql
#创建一个测试表t25
CREATE TABLE t25 (
	id INT,
	`name` VARCHAR(32)
	);

-- 查询表是否有索引
mysql> show indexes from t25;
Empty set (0.00 sec)

-- 添加唯一索引
CREATE UNIQUE INDEX id_index ON t25(id);

#再次查询t25的索引
mysql> show indexes from t25;
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| Table | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible | Expression |
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| t25   |          0 | id_index |            1 | id          | A         |           0 |     NULL |   NULL | YES  | BTREE      |         |               | YES     | NULL       |
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
1 row in set (0.00 sec)

-- 添加普通索引,方式一:
-- create index id_index ON t25(id);
-- 方式二:
-- alter table t25 ADD index id_index(id);

#如何选择 普通索引 和 唯一索引
#如果某列的值不重复,优先使用UNIQUE索引,否则用普通索引


#创建主键索引
CREATE TABLE t26 (
	id INT,
	`name` VARCHAR(32)
	);

ALTER TABLE t26 ADD PRIMARY KEY (id);

mysql> show indexes from t26;
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| Table | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible | Expression |
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| t26   |          0 | PRIMARY  |            1 | id          | A         |           0 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
1 row in set (0.00 sec)

#主键索引也可以再定义表时直接添加
#例如定义表,定义id字段时, id INT primary key,

#删除索引
DROP INDEX id_index ON t25;

mysql> show indexes from t25;
Empty set (0.00 sec)

-- 删除主键索引
ALTER TABLE t26 DROP PRIMARY KEY;

mysql> show indexes from t26;
Empty set (0.00 sec)


-- 修改索引,先删除,再添加

-- 查看索引
-- 方式一
SHOW INDEX FROM t25; 
-- 方式二
SHOW INDEXES FROM t25;
-- 方式三
SHOW KEYS FROM t25;
-- 方式四
DESC t25;
```

#### 索引补充

- 较频繁的作为查询条件的字段应该创建索引
- 唯一性太差的字段不适合单独创建索引,即使频繁作为查询条件
- 更新非常频繁的字段不适合创建索引
- 不会出现再WHERE子句中的字段不该创建索引

## MySQL事务

- 事务用于保证数据的一致性,它由```一组相关的DML语句组成```,该组的DML语句要么全部成功,要么全部失败
	* DML语句(update,insert,delete)
	* 转账就要用事务来处理,用以保证数据的一致性
	
```sql
#以tom给king转账100元为例
#首先从tom取出100元
update tab_name set money = money - 100
	where name = 'tom';
#再给king加100元
update tab_name set money = money+100
	where name = 'kong'
如果给第一条成功,但第二条失败了,就会造成数据丢失
所以事务就是为了解决这种需求的
```

#### 事务和锁
	* 当执行事务操作时(DML),mysql会在表上加锁,防止其他用户改表
- MySQL数据库控制台事务的几个重要操作

```sql
start transaction	#开始一个事务
savepoint	 #保存点名,设置保存点
rollback to #保存点名,回退事务
rollback	#回退全部事务
commit	#提交事务,所有的操作生效,不能回退
```
#### 事务补充

- 回退事务

```sql
先介绍下保存点(savepoint)
保存点是事务中的点,用于取消部分事务
当结束事务时(commit),会自动删除该事务所定义的所有保存点,
当执行回退事务时,通过指定保存点可以回退到指定的点
```
- 提交事务

```sql
使用commit语句可以提交事务
当执行了commit之后,会确认事务的变化,结束事务,删除保存点,释放锁,数据生效
其他会话可以查看到事务变化后的新数据
```

#### 事务演示

```sql
CREATE TABLE t27(
	id INT,
	`name` VARCHAR(32)
	);

-- 开始一个事务
mysql> start transaction;
Query OK, 0 rows affected (0.00 sec)

-- 设置保存点 a
mysql> savepoint a;
Query OK, 0 rows affected (0.00 sec)

-- 执行DML操作
mysql> insert into t27 values(100,'tom');
Query OK, 1 row affected (0.00 sec)

mysql> select * from t27;
+------+------+
| id   | name |
+------+------+
|  100 | tom  |
+------+------+
1 row in set (0.00 sec)

-- 设置保存点 b
mysql> savepoint b;
Query OK, 0 rows affected (0.00 sec);

-- 执行DML操作
mysql> insert into t27 values(200,'jack');
Query OK, 1 row affected (0.00 sec)

mysql> select * from t27;
+------+------+
| id   | name |
+------+------+
|  100 | tom  |
|  200 | jack |
+------+------+
2 rows in set (0.00 sec)

-- 回退到b
mysql> rollback to b;
Query OK, 0 rows affected (0.00 sec)

mysql> select * from t27;
+------+------+
| id   | name |
+------+------+
|  100 | tom  |
+------+------+
1 row in set (0.00 sec)
-- 回退到事务最初
mysql> rollback;
Query OK, 0 rows affected (0.01 sec)

mysql> select * from t27;
Empty set (0.00 sec)

-- 提交事务
mysql> commit;
Query OK, 0 rows affected (0.00 sec)

mysql> select * from t27;
Empty set (0.00 sec)
```

####事务注意事项

- 如果开启一个事务,没有创建保存点,则执行rollback会回到事务开始的状态

```sql
以表t27为例,此时为空表
mysql> select * from t27;
Empty set (0.00 sec)

#插入一条数据
mysql> insert into t27 values(300,'milan');
Query OK, 1 row affected (0.00 sec)

mysql> select * from t27;
+------+-------+
| id   | name  |
+------+-------+
|  300 | milan |
+------+-------+
1 row in set (0.00 sec)

#开启一个事务
mysql> start transaction;
Query OK, 0 rows affected (0.00 sec)

#插入两条数据
mysql> insert into t27 values(400,'kong');
Query OK, 1 row affected (0.00 sec)

mysql> insert into t27 values(500,'scott');
Query OK, 1 row affected (0.00 sec)

直接回退到最初
mysql> rollback;
Query OK, 0 rows affected (0.01 sec)

mysql> select * from t27;
+------+-------+
| id   | name  |
+------+-------+
|  300 | milan |
+------+-------+
1 row in set (0.00 sec)
```
- 事务没有提交时,可以创建多个保存点
- 事务没有提交时,可以选择回退到某个保存点
- InnoDB存储引擎支持事务,MyISAM不支持
- 开始一个事务有两种语法
	* ```start transaction```
	* ```set autocommit=off```

#### 事务隔离级别

- 多个连接开启各自事务,操作数据库中数据时,数据库系统要负责隔离操作
	* 以保证各个连接再获取数据时的准确性
- 如果不考虑隔离性,可能会引发如下问题
	* 脏读
	* 不可重复读
	* 幻读

- 脏读(dirty read)
	* 当一个事务读取另一个事务尚未提交的修改时,产生脏读
- 不可重复读(nonrepeatable read)
	* 同一查询再同一事务中多次进行,由于其他提交事务所做的DML,每次返回不同的结果集,此时发生不可重复读
- 幻读(phantom read)
	* 同一查询在同一事务中多次进行,由于其他提交事务所作的插入操作,每次返回不同的结果集,此时发生幻读

| mysql隔离级别 | 脏读 | 不可重复读 | 幻读 | 加锁读 | 
| :---: | :---: | :---: | :---: | :---: |
| 读未提交<br/>Read uncommitted | V | V | V | 不加锁 |
| 读已提交<br/>Read committed | x | V | V | 不加锁 |
| 可重复读<br/>Repeatable read | x | x | x | 不加锁 |
| 可串行化<br/>Serializable | x | x | x | 加锁 |

说明: V可能出现,x不会出现


- 隔离级别的演示(以sqlyog和cmd演示)

```sql
-- 查看当前MySQL的隔离级别, sqlyog
SELECT @@transaction_isolation;

#将cmd隔离级别设置为Read uncommitted
mysql> set session transaction isolation level read uncommitted;
Query OK, 0 rows affected (0.00 sec)

mysql> select @@transaction_isolation;
+-------------------------+
| @@transaction_isolation |
+-------------------------+
| READ-UNCOMMITTED        |
+-------------------------+
1 row in set (0.00 sec)

-- 两个连接同时启动事务
mysql> start transaction;
Query OK, 0 rows affected (0.00 sec)

-- 创建数据库,sqlyog
CREATE TABLE `account`(
	id INT,
	`name` VARCHAR(32),
	money INT
);

#cmd查看刚创建的表account
mysql> select * from account;
Empty set (0.00 sec)

#查看cmd此时的隔离级别
mysql> select @@transaction_isolation;
+-------------------------+
| @@transaction_isolation |
+-------------------------+
| READ-UNCOMMITTED        |
+-------------------------+
1 row in set (0.00 sec)

-- 对表account添加数据 sqlyog (事务未提交)
INSERT INTO `account` VALUES(100,'tom',1000);

#cmd此时可以查看sqlyog连接中未提交的事务,此时就是脏读
mysql> select * from account;
+------+------+-------+
| id   | name | money |
+------+------+-------+
|  100 | tom  |  1000 |
+------+------+-------+
1 row in set (0.00 sec)


-- 在sqlyog中执行更改(未提交)
UPDATE ACCOUNT SET money = 800 WHERE id = 100;
-- 在sqlyog中再插入一条数据
INSERT INTO `account` VALUES(200,'jack',2000);
-- 提交事务
commit;


#此时cmd连接中能看到所有操作,此时就是不可重复读
mysql> select * from account;
+------+------+-------+
| id   | name | money |
+------+------+-------+
|  100 | tom  |   800 |
|  200 | jack |  2000 |
+------+------+-------+
2 rows in set (0.00 sec)

```

- 读已提交

```sql
-- 再次启动事务,sqlyog
START TRANSACTION;

#修改cmd中的隔离级别
mysql> set session transaction isolation level read committed;
Query OK, 0 rows affected (0.00 sec)

#查看修改后的隔离级别 cmd
mysql> select @@transaction_isolation;
+-------------------------+
| @@transaction_isolation |
+-------------------------+
| READ-COMMITTED          |
+-------------------------+
1 row in set (0.00 sec)

#两个连接再次开启事务
START TRANSACTION;

-- 再次添加一条新数据 sqlyog
INSERT INTO `account` VALUES(300,'scott',8000);
-- sqlyog中可以查看

#cmd连接中无法查看,未出现脏读
mysql> select * from `account`;
+------+------+-------+
| id   | name | money |
+------+------+-------+
|  100 | tom  |   800 |
|  200 | jack |  2000 |
+------+------+-------+
2 rows in set (0.00 sec)

-- 通过sqlyog修改数据
UPDATE `account` SET money = 1800 WHERE id=200;
-- 提交
commit;

#此时cmd中可以读取所有修改
mysql> select * from `account`;
+------+-------+-------+
| id   | name  | money |
+------+-------+-------+
|  100 | tom   |   800 |
|  200 | jack  |  1800 |
|  300 | scott |  8000 |
+------+-------+-------+
3 rows in set (0.00 sec)


-- 两边同时开启事务
START TRANSACTION;

-- sqlyog中追加数据
INSERT INTO `account` VALUES(400,'milan',6000);
-- 通过sqlyog修改数据
UPDATE `account` SET money = 100 WHERE id = 300;

-- sqlyog中可以查看上述操作
SELECT * FROM `account`;

#cmd中无法查看
mysql> select * from `account`;
+------+-------+-------+
| id   | name  | money |
+------+-------+-------+
|  100 | tom   |   800 |
|  200 | jack  |  1800 |
|  300 | scott |  8000 |
+------+-------+-------+
3 rows in set (0.00 sec)

-- sqlyog中提交事务
COMMIT;

#cmd中仍旧无法查看
mysql> select * from `account`;
+------+-------+-------+
| id   | name  | money |
+------+-------+-------+
|  100 | tom   |   800 |
|  200 | jack  |  1800 |
|  300 | scott |  8000 |
+------+-------+-------+
3 rows in set (0.00 sec)
```

- cmd中设置隔离级别为可串行化

```sql
mysql> set session transaction isolation level serializable;
Query OK, 0 rows affected (0.00 sec)

#查看隔离级别
mysql> select @@transaction_isolation;
+-------------------------+
| @@transaction_isolation |
+-------------------------+
| SERIALIZABLE            |
+-------------------------+
1 row in set (0.00 sec)

# 两个连接同时开启事务
START TRANSACTION;

-- sqlyog中添加数据
INSERT INTO `account` VALUES(500,'jerry',88000);
-- sqlyog中修改数据
UPDATE `account` SET money = 900 WHERE id = 300;

#此时cmd查看表`account`(光标会卡住,因为有锁)
mysql> select * from `account`;

-- sqlyog中提交事务
COMMIT;

#cmd中的查询会得到结果(超时等待太久会报错)
mysql> select * from `account`;
+------+-------+-------+
| id   | name  | money |
+------+-------+-------+
|  100 | tom   |   800 |
|  200 | jack  |  1800 |
|  300 | scott |   100 |
|  400 | milan |  6000 |
|  500 | jerry | 88000 |
+------+-------+-------+
5 rows in set (10.52 sec)
```

- 查看当前会话隔离级别

```sql
mysql> select @@transaction_isolation;
+-------------------------+
| @@transaction_isolation |
+-------------------------+
| SERIALIZABLE            |
+-------------------------+
1 row in set (0.00 sec)
```

- 查看系统当前隔离级别

```sql
mysql> select @@global.transaction_isolation;
+--------------------------------+
| @@global.transaction_isolation |
+--------------------------------+
| REPEATABLE-READ                |
+--------------------------------+
1 row in set (0.00 sec)
```

- 设置当前会话隔离级别

```sql
SET SESSION TRANSACTION ISOLATION LEVEL [你要设置的级别]
```

- 设置系统当前隔离级别

```sql
SET global TRANSACTION ISOLATION LEVEL [你要设置的级别]
```

- mysql默认的事务隔离级别为```repeatable read```
- 全局修改事务隔离级别可以在文件my.ini中添加语句


#### 事务ACID

- 事务的acid特性
- 原子性(Atomicity)
	* 指事务时一个不可分割的工作单位,事务中的操作要么都成功,要么都失败
- 一致性(Consistency)
	* 事务必须使数据库从一个一致性状态变换到另一个一致性状态
- 隔离性(Isolation)
	* 多个用户并发访问数据库时,数据库为每一个用户开启的事务,不能被其他事务的操作数据干扰,多个并发事务之间要相互隔离
- 持久性(Durability)
	* 一个事务一旦提交,它对数据库中数据的改变就是永久性的,接下来即使数据库发生故障也不该对其产生影响


## mysql存储引擎

- MySQL的表类型由存储引擎(Storage Engines)决定,主要包括MyISAM,InnoDB,Memory等
- MySQL数据表主要支持6种类型,分别是```CSV``` ```Memory``` ```ARCHIVE``` ```MRG MYISAM``` ```MYISAM``` ```innodb```
- 这6种又分两类
	* 一类是```事务安全型```(transaction-safe) 如InnoDB
	* 其余都属于第二类,```非事务安全型```(non-transaction-safe) [mysiam和memory]

- 查看所有的存储引擎

```sql
mysql> show engines;
+--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
| Engine             | Support | Comment                                                        | Transactions | XA   | Savepoints |
+--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
| MEMORY             | YES     | Hash based, stored in memory, useful for temporary tables      | NO           | NO   | NO         |
| MRG_MYISAM         | YES     | Collection of identical MyISAM tables                          | NO           | NO   | NO         |
| CSV                | YES     | CSV storage engine                                             | NO           | NO   | NO         |
| FEDERATED          | NO      | Federated MySQL storage engine                                 | NULL         | NULL | NULL       |
| PERFORMANCE_SCHEMA | YES     | Performance Schema                                             | NO           | NO   | NO         |
| MyISAM             | YES     | MyISAM storage engine                                          | NO           | NO   | NO         |
| InnoDB             | DEFAULT | Supports transactions, row-level locking, and foreign keys     | YES          | YES  | YES        |
| ndbinfo            | NO      | MySQL Cluster system information storage engine                | NULL         | NULL | NULL       |
| BLACKHOLE          | YES     | /dev/null storage engine (anything you write to it disappears) | NO           | NO   | NO         |
| ARCHIVE            | YES     | Archive storage engine                                         | NO           | NO   | NO         |
| ndbcluster         | NO      | Clustered, fault-tolerant tables                               | NULL         | NULL | NULL       |
+--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
11 rows in set (0.00 sec)
```

- 存储引擎细节描述

```sql
MyISAM 不支持事务,不支持外键,但访问速度快,对事务完整性没有要求

InnoDB 具有提交,回滚和崩溃恢复能力的事务安全
	但相比MyISAM,InnoDB的写入速度慢且占用更多的磁盘空间(用来保留数据和索引)

memory使用存在内存种的内容来创建表,每个memory表只实际对应一个磁盘文件
	memory类型的表访问非常快,因为它的数据在内存中,并且默认使用hash索引
	但是一旦服务关闭,表中数据就会丢失,表的结构还在
```

- myisam演示

```sql
-- myisam添加数据快,不支持外键和事务,支持表级锁
CREATE TABLE t28(
	id INT,
	`name` VARCHAR(32) 
	) ENGINE MYISAM;

#开启事务
START TRANSACTION;
#设置保存点
SAVEPOINT t1
#添加数据
INSERT INTO t28 VALUES(1,'jack');
#查看表
mysql> select * from t28;
+------+------+
| id   | name |
+------+------+
|    1 | jack |
+------+------+
1 row in set (0.01 sec)

#回退至保存点t1
ROLLBACK TO t1;	#sqlyog中执行成功,但会收到一条警告

#再次查询,无法回退
mysql> select * from t28;
+------+------+
| id   | name |
+------+------+
|    1 | jack |
+------+------+
1 row in set (0.00 sec)
```
- memory存储引擎演示

```sql
-- memory存储引擎,存储在内存,默认支持索引(hash),如果MySQL服务停止,则数据丢失,但表结构还在
CREATE TABLE t29(
	id INT,
	`name` VARCHAR(32)
	) ENGINE MEMORY;
INSERT INTO t29 VALUES(1,'jack'),(2,'tom'),(3,'jira');

#查看信息
mysql> select * from t29;
+------+------+
| id   | name |
+------+------+
|    1 | jack |
|    2 | tom  |
|    3 | jira |
+------+------+
3 rows in set (0.00 sec)

#windows下停止MySQL服务
net stop mysql

#开启MySQL服务
net start mysql

#此时t29中的数据已经丢失,但表结构还在
mysql> DESC t29;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | int         | YES  |     | NULL    |       |
| name  | varchar(32) | YES  |     | NULL    |       |
+-------+-------------+------+-----+---------+-------+
2 rows in set (0.00 sec)
```   

- 存储引擎选择
1. 如果应用不需要事务,只处理基本的CRUD,那么MyISAM适合
2. 如果需要支持事务,选择InnoDB
3. Memory由于是内存存储引擎,经典用法是用户的在线状态

- 指令修改存储引擎
 
```sql
mysql> alter table t29 ENGINE = INNODB;
Query OK, 3 rows affected (0.03 sec)
Records: 3  Duplicates: 0  Warnings: 0
```

#### 视图(view)

- emp表的字段很多,某些字段可能存储了重要信息,若我们希望某用户```只能查询指定的字段```
	* 就可以使用视图
- 视图是一个```虚拟表```,其内容由查询定义.同真实的表一样,视图包含列,数据来自对应的真实表(基表)
	* 通过视图可以修改基表的数据
	* 基表的改变,也会影响到视图的数据
- 创建视图的```基表可以是多个```


- 创建视图

```sql
CREATE VIEW emp_view01
	AS 
	SELECT empno,ename,job,deptno FROM emp;
```

- 查看视图结构

```sql
mysql> DESC emp_view01;
+--------+--------------------+------+-----+---------+-------+
| Field  | Type               | Null | Key | Default | Extra |
+--------+--------------------+------+-----+---------+-------+
| empno  | mediumint unsigned | NO   |     | 0       |       |
| ename  | varchar(20)        | NO   |     |         |       |
| job    | varchar(9)         | NO   |     |         |       |
| deptno | mediumint unsigned | NO   |     | 0       |       |
+--------+--------------------+------+-----+---------+-------+
4 rows in set (0.00 sec)
```
- 查找视图中的数据

```sql
mysql> select * from emp_view01;
+-------+--------+-----------+--------+
| empno | ename  | job       | deptno |
+-------+--------+-----------+--------+
|  7369 | SMITH  | CLERK     |     20 |
|  7499 | ALLEN  | SALESMAN  |     30 |
|  7521 | WARD   | SALESMAN  |     30 |
|  7566 | JONES  | MANAGER   |     20 |
|  7654 | MARTIN | SALESMAN  |     30 |
|  7698 | BLAKE  | MANAGER   |     30 |
|  7782 | CLARK  | MANAGER   |     10 |
|  7788 | SCOTT  | ANALYST   |     20 |
|  7839 | KING   | PRESIDENT |     10 |
|  7844 | TURNER | SALESMAN  |     30 |
|  7900 | JAMES  | CLERK     |     30 |
|  7902 | FORD   | ANALYST   |     20 |
|  7934 | MILLER | CLERK     |     10 |
+-------+--------+-----------+--------+
13 rows in set (0.00 sec)
```

- 查看创建视图的指令

```sql
mysql> SHOW CREATE view emp_view01;
+------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------+----------------------+
| View       | Create View                                                                                                                                                                                                         | character_set_client | collation_connection |
+------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------+----------------------+
| emp_view01 | CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `emp_view01` AS select `emp`.`empno` AS `empno`,`emp`.`ename` AS `ename`,`emp`.`job` AS `job`,`emp`.`deptno` AS `deptno` from `emp` | utf8mb3              | utf8mb3_general_ci   |
+------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------+----------------------+
1 row in set (0.00 sec)
```

- 删除视图

```sql
mysql> DROP view emp_view01;
Query OK, 0 rows affected (0.01 sec)
```

- 创建视图后,取数据库查看,对应视图的只有一个视图结构文件(视图名.frm)
- 视图的数据变化会影响到基表,基表的数据变化也会影响到视图(insert update delete)

```sql
先查询基表emp,下面对emp中ename为SMITH的员工进行修改
mysql> select * from emp;
+-------+--------+-----------+------+------------+---------+---------+--------+
| empno | ename  | job       | mgr  | hiredate   | sal     | comm    | deptno |
+-------+--------+-----------+------+------------+---------+---------+--------+
|  7369 | SMITH  | CLERK     | 7902 | 1990-12-17 |  800.00 |    NULL |     20 |
...

mysql> select * from emp_view01;
+-------+--------+-----------+--------+
| empno | ename  | job       | deptno |
+-------+--------+-----------+--------+
|  7369 | SMITH  | CLERK     |     20 |
...


#通过视图对SMITH进行修改
mysql> update emp_view01 set job = 'MANAGER'
    -> where ename = 'SMITH';
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0

#查询基表emp
mysql> select * from emp;
+-------+--------+-----------+------+------------+---------+---------+--------+
| empno | ename  | job       | mgr  | hiredate   | sal     | comm    | deptno |
+-------+--------+-----------+------+------------+---------+---------+--------+
|  7369 | SMITH  | MANAGER   | 7902 | 1990-12-17 |  800.00 |    NULL |     20 |
...

#查询视图
mysql> select * from emp_view01;
+-------+--------+-----------+--------+
| empno | ename  | job       | deptno |
+-------+--------+-----------+--------+
|  7369 | SMITH  | MANAGER   |     20 |

#直接修改基表
mysql> update emp
    -> set job = 'SALESMAN'
    -> where empno = 7369;
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> select * from emp;
+-------+--------+-----------+------+------------+---------+---------+--------+
| empno | ename  | job       | mgr  | hiredate   | sal     | comm    | deptno |
+-------+--------+-----------+------+------------+---------+---------+--------+
|  7369 | SMITH  | SALESMAN  | 7902 | 1990-12-17 |  800.00 |    NULL |     20 |
...

mysql> select * from emp_view01;
+-------+--------+-----------+--------+
| empno | ename  | job       | deptno |
+-------+--------+-----------+--------+
|  7369 | SMITH  | SALESMAN  |     20 |
```
- 视图中可以再使用视图
	* 从视图emp_view01中取出字段empno,ename创建视图emp_view02;

```sql
#emp_view02的真实数据来源同emp_view01相同,均来自基表emp
CREATE VIEW emp_view02
	AS
	SELECT empno,ename FROM emp_view01;

mysql> SELECT * FROM emp_view02;
+-------+--------+
| empno | ename  |
+-------+--------+
|  7369 | SMITH  |
|  7499 | ALLEN  |
|  7521 | WARD   |
|  7566 | JONES  |
|  7654 | MARTIN |
|  7698 | BLAKE  |
|  7782 | CLARK  |
|  7788 | SCOTT  |
|  7839 | KING   |
|  7844 | TURNER |
|  7900 | JAMES  |
|  7902 | FORD   |
|  7934 | MILLER |
+-------+--------+
13 rows in set (0.00 sec)
```

-视图使用场景
- 安全
	* 一些数据表有重要信息,有些字段是保密的,这时可以创建一个视图,在这种视图中只保留一部分字段
- 性能
	* 关系数据库的数据常常会分表存储,使用外键建立这些表之间的关系,查询数据库通常会用到连接(JOIN),这样不但麻烦
	* 效率也较低,如果建立一个视图,将相关的表和字段结合在一起,可以避免使用join查询
- 灵活
	* 如果系统中有一张旧表,由于设计原因即将被废弃,然而很多应用都基于这张表,不易修改
	* 这是就可以建立视图,视图中的数据直接映射到新建的表


###### 视图练习

- 针对表emp,dept,salgrade三张,建立一个视图emp_view03,可以显示员工编号,员工名,员工部门名称和薪水级别

```sql
#首先得到三张表中符合题目的数据
mysql> SELECT empno,ename,dname,grade
    ->  FROM emp,dept,salgrade
    ->  WHERE emp.deptno = dept.deptno AND
    ->  (sal BETWEEN losal AND hisal);
+-------+--------+------------+-------+
| empno | ename  | dname      | grade |
+-------+--------+------------+-------+
|  7900 | JAMES  | SALES      |     1 |
|  7369 | SMITH  | RESEARCH   |     1 |
|  7934 | MILLER | ACCOUNTING |     2 |
|  7654 | MARTIN | SALES      |     2 |
|  7521 | WARD   | SALES      |     2 |
|  7844 | TURNER | SALES      |     3 |
|  7499 | ALLEN  | SALES      |     3 |
|  7902 | FORD   | RESEARCH   |     4 |
|  7788 | SCOTT  | RESEARCH   |     4 |
|  7782 | CLARK  | ACCOUNTING |     4 |
|  7698 | BLAKE  | SALES      |     4 |
|  7566 | JONES  | RESEARCH   |     4 |
|  7839 | KING   | ACCOUNTING |     5 |
+-------+--------+------------+-------+
13 rows in set (0.00 sec

#再根据上述数据创建视图
CREATE VIEW emp_view03
	AS
	SELECT empno,ename,dname,grade
	FROM emp,dept,salgrade
	WHERE emp.deptno = dept.deptno AND
	(sal BETWEEN losal AND hisal)

#查询视图emp_view03的结构
mysql> DESC emp_view03;
+-------+--------------------+------+-----+---------+-------+
| Field | Type               | Null | Key | Default | Extra |
+-------+--------------------+------+-----+---------+-------+
| empno | mediumint unsigned | NO   |     | 0       |       |
| ename | varchar(20)        | NO   |     |         |       |
| dname | varchar(20)        | NO   |     |         |       |
| grade | mediumint unsigned | NO   |     | 0       |       |
+-------+--------------------+------+-----+---------+-------+
4 rows in set (0.00 sec)


mysql> select * from emp_view03;
+-------+--------+------------+-------+
| empno | ename  | dname      | grade |
+-------+--------+------------+-------+
|  7900 | JAMES  | SALES      |     1 |
|  7369 | SMITH  | RESEARCH   |     1 |
|  7934 | MILLER | ACCOUNTING |     2 |
|  7654 | MARTIN | SALES      |     2 |
|  7521 | WARD   | SALES      |     2 |
|  7844 | TURNER | SALES      |     3 |
|  7499 | ALLEN  | SALES      |     3 |
|  7902 | FORD   | RESEARCH   |     4 |
|  7788 | SCOTT  | RESEARCH   |     4 |
|  7782 | CLARK  | ACCOUNTING |     4 |
|  7698 | BLAKE  | SALES      |     4 |
|  7566 | JONES  | RESEARCH   |     4 |
|  7839 | KING   | ACCOUNTING |     5 |
+-------+--------+------------+-------+
13 rows in set (0.00 sec)
```

## MySQL用户管理

- MySQL中的用户,都存储在系统数据库MySQL中的user表中
	* user表中重要字段说明
	* host: 允许登陆的位置,localhost表示该用户只允许本机登录,也可以指定ip
	* authentication_string: 密码,通过MySQL中的MD5加密之后的密码
- 创建用户

```sql
create user '用户名'@'允许登录位置' identified by '密码'
#创建用户,同时指定密码
```

- 删除用户

```sql
DROP user '用户名'@'允许登录位置'
```

- 创建新用户

```sql
CREATE USER 'hsp_stu'@'localhost' IDENTIFIED BY 'zhenzhu.c'
```
- 查看所有用户

```sql
mysql> SELECT `host`,`user`,authentication_string
    ->  FROM mysql.user;
+-----------+------------------+------------------------------------------------------------------------+
| host      | user             | authentication_string                                                  |
+-----------+------------------+------------------------------------------------------------------------+
| localhost | hsp_stu          | $A$005$bRZKbN6???/BO]'Co|NtIpRu7wxUwaDldS.cha9Ht.2WA6cTPjKV43ItameH6 |
| localhost | mysql.infoschema | $A$005$THISISACOMBINATIONOFINVALIDSALTANDPASSWORDTHATMUSTNEVERBRBEUSED |
| localhost | mysql.session    | $A$005$THISISACOMBINATIONOFINVALIDSALTANDPASSWORDTHATMUSTNEVERBRBEUSED |
| localhost | mysql.sys        | $A$005$THISISACOMBINATIONOFINVALIDSALTANDPASSWORDTHATMUSTNEVERBRBEUSED |
| localhost | root             | $A$005$/Xj{Q5V        xo#     kP,\w]4n7OxoEGQnVw0LWEm1.Gzk/DsbU3BObsznodFnvHsi9 |
+-----------+------------------+------------------------------------------------------------------------+
5 rows in set (0.00 sec)
```
- 普通用户登录

```sql
>mysql -u hsp_stu -p
Enter password: *********
Welcome to the MySQL monitor.
...

#不同用户登陆后看到的数据不不同
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| performance_schema |
+--------------------+
2 rows in set (0.00 sec)
```

- 删除用户

```sql
DROP USER 'hsp_stu'@'localhost'
```

###### 权限管理

- 授权用户

```sql
grant 权限列表 on *.对象名 to '用户名'@'登录位置' [identified by '密码']

#权限列表
grant select on ...
grant select,delete,create on ...
grant all [privileges] on ...	#表示赋予该用户在该对象上的所有权限

#特别说明
*.* 表示本系统中的所有数据库的所有对象(表,视图,存储过程)
库.* 表示某个数据库中的所有数据对象(表,视图,存储过程)

#identified by 可以省略,也可以写出
如果用户存在,就是修改该用户的密码
如果用户不存在,就是创建该用户
```

- 取消授权

```sql
revoke 权限列表 on 库.对象名 from '用户名'@'登陆位置';
```

- 权限生效指令

```sql
若权限没有生效,可以执行如下命令
FLUSH PRIVILEGES;
```

- 权限管理练习

```sql
-- 创建用户huohuo和密码,从本地登录
CREATE USER 'huohuo'@'localhost' IDENTIFIED BY '123456';

-- 由root创建testdb,表news
CREATE DATABASE testdb;
CREATE TABLE news(
	id INT,
	content VARCHAR(32)
	);
-- 向news中添加一条测试数据
INSERT INTO news VALUES(100,'bj新闻')

mysql> select * from news;
+------+----------+
| id   | content  |
+------+----------+
|  100 | bj新闻   |
+------+----------+
1 row in set (0.00 sec)


-- 给用户huohuo分配查看news表和添加news的权限
GRANT SELECT,INSERT
	ON testdb.`news`
	TO 'huohuo'@'localhost';

#huohuo可以查看到testdb
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| performance_schema |
| testdb             |
+--------------------+
3 rows in set (0.00 sec)

#查看成功
mysql> use testdb;
Database changed
mysql> select * from news;
+------+----------+
| id   | content  |
+------+----------+
|  100 | bj新闻   |
+------+----------+
1 row in set (0.00 sec)

#向其中添加数据
mysql> insert into news
    -> values(200,'sh新闻');
Query OK, 1 row affected (0.00 sec)

mysql> select * from news;
+------+----------+
| id   | content  |
+------+----------+
|  100 | bj新闻   |
|  200 | sh新闻   |
+------+----------+
2 rows in set (0.00 sec)

mysql> #测试update能否成功,Error
mysql> UPDATE news
    -> SET content = 'gz新闻'
    -> where id = 100;
ERROR 1142 (42000): UPDATE command denied to user 'huohuo'@'localhost' for table 'news'


#通过root用户回收权限(回收huohuo的所有权限)
REVOKE ALL ON testdb.`news` FROM 'huohuo'@'localhost';
REVOKE select,insert ON testdb.`news` FROM 'huohuo'@'localhost';	#第二种写法

-- 删除huohuo
DROP USER 'huohuo'@'localhost';
```


















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


































































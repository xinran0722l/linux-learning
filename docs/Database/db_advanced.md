## mysql 约束

- 约束用于确保数据库的数据满足特定的规则
	* Mysql中的约束如下
	1. not null
	2. unique
	3. primary key
	4. foreign
	5. check

#### primary key(主键)

```sql
字段名	字段类型 primary key

#用于唯一的标识表行的数据,当定义主键约束后,该列不能重复
```

- primary key演示

```sql
CREATE TABLE t17(
	id INT PRIMARY KEY, -- 标识id列是主键
	`name` VARCHAR(32),
	email VARCHAR(32)
	);
	
-- 主键列的值是不可重复
INSERT INTO t17
	VALUES(1,'jack','jack@sohu.com')

INSERT INTO t17
	VALUES(2,'tom','tom@sohu.com');

INSERT INTO t17	-- Error
	VALUES(1,'jira','jira@sohu.com');

mysql> SELECT * FROM t17;
+----+------+---------------+
| id | name | email         |
+----+------+---------------+
|  1 | jack | jack@sohu.com |
|  2 | tom  | tom@sohu.com  |
+----+------+---------------+
2 rows in set (0.00 sec)

mysql> desc t17;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | int         | NO   | PRI | NULL    |       |
| name  | varchar(32) | YES  |     | NULL    |       |
| email | varchar(32) | YES  |     | NULL    |       |
+-------+-------------+------+-----+---------+-------+
3 rows in set (0.00 sec)
```

- primary key不能重复且不能为NULL

```sql
INSERT INTO t17
	VALUES(NULL,'ji','ji@sohu.com');
-- Column 'id' cannot be null

```

- 一张表最多只能由一个主键,但可以是复合主键(比如id+name)

```sql
-- 主键的指定方式有两种 
-- 直接在字段名后指定: 字段名 primary key
-- 在表定义最后写 primary key(列名);

CREATE TABLE t18 (
	id INT PRIMARY KEY,
	`name` VARCHAR(32) PRIMARY KEY, -- error
	email VARCHAR(32)
	);	
#复合主键(id+name做主键),只有id+name同时重复时才Error
CREATE TABLE t18(
	id INT,
	`name` VARCHAR(32),
	email VARCHAR(32),
	PRIMARY KEY (id,`name`)
	);
INSERT INTO t18
	VALUES(1,'tom','tom@qq.com');
INSERT INTO t18	-- 可以成功
	VALUES(1,'jack','jack@qq.com');
INSERT INTO t18	-- Error
	VALUES(1,'tom','333@qq.com');
```

- 使用desc 表名,可以看到primary key的情况

```sql
mysql> desc t18;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | int         | NO   | PRI | NULL    |       |
| name  | varchar(32) | NO   | PRI | NULL    |       |
| email | varchar(32) | YES  |     | NULL    |       |
+-------+-------------+------+-----+---------+-------+
3 rows in set (0.00 sec)
```

#### not null(非空)

- 如果在列上定义了not null,那么当插入数据时,必须为列提供数据

```sql
字段名	字段类型 not null DEAFULT (此处写入一个值)
```

#### unique(唯一)

- 当定义了唯一约束后,该列值是不能重复的

```sql
字段名	字段类型 unique

#如果没有指定NOT NULL,则unique字段可以有多个NULL
#一张表可以有多个unique字段
```

```sql
CREATE TABLE t21(
	id INT UNIQUE,	-- 表示id列不可重复,但可为NULL,且该表可指定多个unique
	`name` VARCHAR(32),
	email VARCHAR(32)
	);
INSERT INTO t21
	VALUES(1,'jack','jack@sohu.com');
INSERT INTO t21	-- Error
	VALUES(1,'tom','tom@sohu.com');
```

- 如果没有指定NOT NULL,则unique字段可以有多个NULL

```sql
INSERT INTO t21	-- 执行3次
	VALUES(NULL,'jira','jira@sohu.com');

mysql> select * from t21;
+------+------+---------------+
| id   | name | email         |
+------+------+---------------+
|    1 | jack | jack@sohu.com |
| NULL | jira | jira@sohu.com |
| NULL | jira | jira@sohu.com |
| NULL | jira | jira@sohu.com |
+------+------+---------------+
4 rows in set (0.00 sec)
#如果某字段定义如 id INT UNIQUE NOT NULL, 效果类似于 primary key
```
- 一张表可以有多个unique字段

```sql
CREATE TABLE t22(
	id INT UNIQUE, #表示id列不可重复
	`name` VARCHAR(32) UNIQUE, #表示name列不可重复
	email VARCHAR(32)
	);

mysql> desc t22;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | int         | YES  | UNI | NULL    |       |
| name  | varchar(32) | YES  | UNI | NULL    |       |
| email | varchar(32) | YES  |     | NULL    |       |
+-------+-------------+------+-----+---------+-------+
3 rows in set (0.00 sec)
```

#### foreign key(外键)

- 用于定义主表和从表之间的关系
- 外键约束要定义在从表上,主表必须具有主键约束或unique约束
- 当定义外键约束后,要求外键列数据必须在主表的主键列存在或为NULL


```sql
FOREIGN KEY (本表字段名) REFERENCES
主表名(主键名或unique字段名)

外键指向的表的字段,要求是primary key 或 unique
表的类型为innodb,才支持外键
外键字段的类型要和主键字段的类型一致(长度可以不同)
外键字段的值,必须在主键字段中出现过,或者为NULL [前提是外键字段允许为NULL]
一旦建立外键关系,数据就不能随意删除
```
 
```sql
-- 先创建主表my_class
CREATE TABLE my_class(
	id INT PRIMARY KEY, -- 班级编号
	`name` VARCHAR(32) NOT NULL DEFAULT ''
	);
	
-- 再创建从表
CREATE TABLE my_stu(
	id INT PRIMARY KEY, -- 学生编号
	`name` VARCHAR(32) NOT NULL DEFAULT '',
	class_id INT, -- 学生所在班级编号
	-- 下面指定外键关系
	FOREIGN KEY (class_id) REFERENCES my_class(id)
	);

-- 测试数据
INSERT INTO my_class
	VALUES(100,'java'),(200,'web');

INSERT INTO my_stu
	VALUES(1,'tom',100);
INSERT INTO my_stu
	VALUES(2,'jack',200);
INSERT INTO my_stu -- 这里ERROR,因为id为300的班级不存在
	VALUES(3,'jira',300);

#若为my_class添加id为300的班级,则再my_stu插入的jira可成功
INSERT INTO my_class
	VALUES(300,'php')
INSERT INTO my_stu
	VALUES(3,'jira',300)

mysql> select * from my_class;
+-----+------+
| id  | name |
+-----+------+
| 100 | java |
| 200 | web  |
| 300 | php  |
+-----+------+
3 rows in set (0.00 sec)

mysql> select * from my_stu;
+----+------+----------+
| id | name | class_id |
+----+------+----------+
|  1 | tom  |      100 |
|  2 | jack |      200 |
|  3 | jira |      300 |
+----+------+----------+
3 rows in set (0.00 sec)
```
- 外键字段的值,必须在主键字段中出现过,或者为NULL [前提是外键字段允许为NULL]

```sql
INSERT INTO my_stu
	VALUES(4,'marry',NULL);

mysql> select * from my_stu;
+----+-------+----------+
| id | name  | class_id |
+----+-------+----------+
|  1 | tom   |      100 |
|  2 | jack  |      200 |
|  3 | jira  |      300 |
|  4 | marry |     NULL |
+----+-------+----------+
4 rows in set (0.00 sec)
```
#### check

- 用于强制行数据必须满足的条件
- 假定再sal列上定义了check约束,并要求sal列值在1K~2K之间
	* 如果不在1K~2K之间就会Error

```sql
列名	类型	check(check条件)
user 表
id,name,sex(man,woman),sal(大于100小于900)
```

```sql
#创建用于测试check的表t23
CREATE TABLE t23 (
	id INT PRIMARY KEY,
	`name` VARCHAR(32),
	sex VARCHAR(6) CHECK (sex IN ('man','woman')),
	sal DOUBLE CHECK (sal > 1000 AND sal < 2000)
	);

#插入违反check规则的数据
mysql> INSERT INTO t23
    -> values(1,'jack','mid',1);
ERROR 3819 (HY000): Check constraint 't23_chk_1' is violated.
```
























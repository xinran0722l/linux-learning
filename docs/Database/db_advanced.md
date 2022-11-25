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
#### 商品表设计

```sql
-- 现有一个商店的数据库shop_db,记录客户及购物情况,由下面3各表组成:
-- 商品goods(商品号goods_id,商品名goods_name,单价unitprice,商品类别category,供应商provider);
-- 客户customer(客户号customer_id,姓名name,住址address,邮件email,性别sex,身份证card_id);
-- 购买purchase(购买订单号order_id,客户号customer_id,商品号goods_id,购买数量nums);
-- 
-- 设计要求如下
-- 建表,在定义中要求声明[进行合理设计]:
-- 每个表的主外键
-- 客户的姓名不能为空值
-- 邮箱不能重复
-- 客户的性别[男|女]
-- 单价unitprice在1.0~9999.99之间

#新建数据库数据库shop_db
CREATE DATABASE shop_db;

#商品goods(商品号goods_id,商品名goods_name,单价unitprice,商品类别category,供应商provider);
CREATE TABLE goods(
	goods_id INT PRIMARY KEY,
	goods_name VARCHAR(64) NOT NULL DEFAULT '',
	unitprice DECIMAL(10,2) NOT NULL DEFAULT 0 
		CHECK (unitprice >= 1.0 AND unitprice <= 9999.99),
	category INT NOT NULL DEFAULT 0,
	provider VARCHAR(64) NOT NULL DEFAULT ''
	);

#客户customer(客户号customer_id,姓名name,住址address,邮件email,性别sex,身份证card_id);
CREATE TABLE customer(
	customer_id CHAR(8) PRIMARY KEY, -- 设定为char考虑到后面可能不是纯数字
	`name` VARCHAR(64) NOT NULL DEFAULT '',
	address VARCHAR(64) NOT NULL DEFAULT '',
	email VARCHAR(32) UNIQUE NOT NULL,
	-- sex varchar(6) check (sex = '男' OR sex = '女'),
	sex ENUM('男','女') NOT NULL,
	card_id CHAR(18) UNIQUE
	);
	
#购买purchase(购买订单号order_id,客户号customer_id,商品号goods_id,购买数量nums);
CREATE TABLE purchase (
	order_id INT UNSIGNED PRIMARY KEY,
	customer_id CHAR(8) NOT NULL DEFAULT '', -- customer_id为外键,需要和customer表关联
	goods_id INT NOT NULL DEFAULT 0, -- goods_id要和goods表关联,外键约束在后
	nums INT NOT NULL DEFAULT 0,
	FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
	FOREIGN KEY (goods_id) REFERENCES goods(goods_id)
	);

mysql> DESC goods;
+------------+---------------+------+-----+---------+-------+
| Field      | Type          | Null | Key | Default | Extra |
+------------+---------------+------+-----+---------+-------+
| goods_id   | int           | NO   | PRI | NULL    |       |
| goods_name | varchar(64)   | NO   |     |         |       |
| unitprice  | decimal(10,2) | NO   |     | 0.00    |       |
| category   | int           | NO   |     | 0       |       |
| provider   | varchar(64)   | NO   |     |         |       |
+------------+---------------+------+-----+---------+-------+
5 rows in set (0.00 sec)

mysql> DESC customer;
+-------------+-------------------+------+-----+---------+-------+
| Field       | Type              | Null | Key | Default | Extra |
+-------------+-------------------+------+-----+---------+-------+
| customer_id | char(8)           | NO   | PRI | NULL    |       |
| name        | varchar(64)       | NO   |     |         |       |
| address     | varchar(64)       | NO   |     |         |       |
| email       | varchar(32)       | NO   | UNI | NULL    |       |
| sex         | enum('男','女')   | NO   |     | NULL    |       |
| card_id     | char(18)          | YES  | UNI | NULL    |       |
+-------------+-------------------+------+-----+---------+-------+
6 rows in set (0.00 sec)

mysql> DESC purchase;
+-------------+--------------+------+-----+---------+-------+
| Field       | Type         | Null | Key | Default | Extra |
+-------------+--------------+------+-----+---------+-------+
| order_id    | int unsigned | NO   | PRI | NULL    |       |
| customer_id | char(8)      | NO   | MUL |         |       |
| goods_id    | int          | NO   | MUL | 0       |       |
| nums        | int          | NO   |     | 0       |       |
+-------------+--------------+------+-----+---------+-------+
4 rows in set (0.00 sec)
```

#### 自增长

- 在某张表中,存在一个id列(整数),该列从1开始,自动增长

```sql
字段名 整形 primary key auto_increment

#添加自动增长的字段方式
insert into tab_name(字段1,字段2...)
	valuse(null,'值'...)	#若tab_name的字段1为自增长,即使填入null,也会按照自增长顺序写入
insert into tab_name(字段2...) 
	values(值1,值2...)	#若tab_name的字段1为自增长,不填写字段1,依旧会自增长
insert into tab_name
	values(null,值1...)	#同样自增长

自增长一般配合primary key使用
自增长也可以单独使用[但是需要配合一个unique]
自增长修饰的字段为整型,(使用小数的情况非常少)
自增长默认从1开始,也可以通过下面的命令修改
	alter table 表名 auto_increment = 新的开始值;
如果添加数据时,给自增长字段(列)指定值,则以指定值为准,
	若表创建时指定了自增长,推荐按照自增长规则来添加数据
```

- 演示自增长

```sql
CREATE TABLE t24(
	id INT PRIMARY KEY AUTO_INCREMENT,
	email VARCHAR(32) NOT NULL DEFAULT '',
	`name` VARCHAR(32) NOT NULL DEFAULT ''
	);

mysql> select * from t24;
Empty set (0.00 sec)

mysql> desc t24;
+-------+-------------+------+-----+---------+----------------+
| Field | Type        | Null | Key | Default | Extra          |
+-------+-------------+------+-----+---------+----------------+
| id    | int         | NO   | PRI | NULL    | auto_increment |
| email | varchar(32) | NO   |     |         |                |
| name  | varchar(32) | NO   |     |         |                |
+-------+-------------+------+-----+---------+----------------+
3 rows in set (0.00 sec)

#插入一条id为null的数据
INSERT INTO t24
	VALUES(NULL, 'jack@qq.com','jack');

#写入数据会变为1,从1开始自增
mysql> select * from t24;
+----+-------------+------+
| id | email       | name |
+----+-------------+------+
|  1 | jack@qq.com | jack |
+----+-------------+------+
1 row in set (0.00 sec)

#再插入一条id为null的数据
INSERT INTO t24
	VALUES(NULL,'tom@qq.com','tom')

mysql> select * from t24;
+----+-------------+------+
| id | email       | name |
+----+-------------+------+
|  1 | jack@qq.com | jack |
|  2 | tom@qq.com  | tom  |
+----+-------------+------+
2 rows in set (0.00 sec)

#指明不填id的情况
INSERT INTO t24
	(email,`name`) VALUES('jira@qq.com','jira')

mysql> select * from t24;
+----+-------------+------+
| id | email       | name |
+----+-------------+------+
|  1 | jack@qq.com | jack |
|  2 | tom@qq.com  | tom  |
|  3 | jira@qq.com | jira |
+----+-------------+------+
3 rows in set (0.00 sec)
```

- 修改自增长的默认值

```sql
CREATE TABLE t25 (
	id INT PRIMARY KEY AUTO_INCREMENT,
	email VARCHAR(32) NOT NULL DEFAULT '',
	`name` VARCHAR(32) NOT NULL DEFAULT ''
	);

#让自增长从100开始
ALTER TABLE t25 AUTO_INCREMENT = 100;

INSERT INTO t25
	VALUES(NULL,'git@qq.com','git')
mysql> select * from t25;
+-----+------------+------+
| id  | email      | name |
+-----+------------+------+
| 100 | git@qq.com | git  |
+-----+------------+------+
1 row in set (0.00 sec)

#指定自增长的值,后续数据都将从指定值开始
INSERT INTO t25
	VALUES(666,'Mozilla@qq.com','Mozilla');

mysql> select * from t25;
+-----+----------------+---------+
| id  | email          | name    |
+-----+----------------+---------+
| 100 | git@qq.com     | git     |
| 666 | Mozilla@qq.com | Mozilla |
+-----+----------------+---------+
2 rows in set (0.00 sec)

#由于前面指定了666,所以会从667开始自增
INSERT INTO t25
	VALUES(NULL,'googl@qq.com','google')

mysql> select * from t25;
+-----+----------------+---------+
| id  | email          | name    |
+-----+----------------+---------+
| 100 | git@qq.com     | git     |
| 666 | Mozilla@qq.com | Mozilla |
| 667 | googl@qq.com   | google  |
+-----+----------------+---------+
3 rows in set (0.00 sec)
```













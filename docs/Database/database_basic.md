## 数据库三层结构

- 所谓安装Mysql数据库，就是在主机安装一个数据库管理系统(DBMS),这个管理程序可以管理多个数据库
- 一个数据库中可以创建多个表，以保存数据
- 数据库管理系统(DBMS,DataBase Manage System)，数据库和表的关系

- sql语句分类

```sql
DDL	数据定义语句	[create 表，库...]
DML	数据操作语句	[增加inster 修改update 删除delete]
DQL	数据查询语句	[select]
DCL	数据控制语句	[管理数据库：比如用户权限 grant revoke]
```
#### 创建数据库

```sql
# 创建一个名为database_db01的数据库
CREATE DATABASE base_db01;
# 删除数据库
DROP DATABASE base_db01
#创建一个使用utf8字符集的base_db02数据库
CREATE DATABASE base_db02 CHARACTER SET utf8mb3
#创建一个使用utf8字符集,并带校对规则的base_db03数据库
CREATE DATABASE base_db03 CHARACTER SET utf8 COLLATE utf8_bin

#此select用于base_db02/03中的t1表，用来测试两个db的校对规则
SELECT * FROM t1 WHERE NAME = 'tom'
```
#### 查询，删除数据库

```sql
#查看当前数据库服务器中的所有数据库
SHOW DATABASES
#查看前面创建的base_db01数据库的定义信息
SHOW CREATE DATABASE base_db01
#删除前面创建的base_db01数据库
DROP DATABASE base_db01
```

#### 备份数据库

```SQL
#mysqldump命令需要在DOS命令行中执行
mysqldump -u 用户名 -p -B 数据库1 数据库2 数据库n > 文件名.sql

#恢复数据库(进入MySQL中在执行)
Source 文件名.sql
```
- 练习：备份base_db02/03两个库中的数据，并恢复

```SQL
mysqldump -u root -p -B base_db02 base_db03 > D:\\bak.sql
Enter PASSWORD: ********
#D:\\bak.sql内容就是创建两个db，及其中的内容
#也可以全部执行该备份文件的sql语句来手动恢复


#恢复数据库(需要进入MySQL，在其中执行)
SOURCE D:\\bak.sql

#备份一个数据库中的多张表
#和备份多个数据库不同的是不加-B参数，若有-B参数，则是备份多个数据库
mysqldump -u 用户名 -p 数据库 表1 表2 表n > D:\\文件名.sql
```

#### 创建表

```SQL
CREATE TABLE table_bane 
(
	field1 datatype,
	field2 datatype,
	field3 datatype
)character set 字符集 collate 校对规则 engine 引擎

field	指定列名
datatype	指定列类型(字段类型)
character set	若不指定则为所在数据库字符集
collate	若不指定则为所在数据库校对规则
engine	引擎(设计内容较多)
```
- 练习

```SQL
#创建一个user表，数据类型的定义如下
#id	整形
#name	字符串
#password	字符串
#date	日期

CREATE TABLE `user` (
	id INT,
	`name` VARCHAR(255),
	`password` VARCHAR(255),
	`date` DATE
)CHARACTER SET utf8mb3 COLLATE utf8mb3_bin ENGINE INNODB;`user``user`
```

#### MySQL常用数据类型(列类型，字段类型)

```SQL
		BIT(M)	位类型，M指定位数，默认值1，范围1~64
数值类型	TINYINT [UNSIGEND] 占1个字节	带符号的范围是-128到127， 无符号0到255，默认有符号
		SAMLLINT [UNSIGEND] 2个字节	带符号是 负的2^15到2^15-1,无符号0到2^16-1
		MEDIUMINT [UNSIGEND] 3个字节	带符号是 负的2*23到2^23-1,无符号0到2^24-1
		INT [UNSIGEND] 4个字节		带符号是 负的2^31到2^31-1,无符号是0到2^32-1
		BIGINT [UNSIGEND] 8个字节		带符号是 负的2^63到2^32-1,无符号是0到2^64-1

		FLOAT [UNSIGEND] 	4个字节
		DOUBLE [UNSIGEND] 标识符float精度更大的小数，占用8个字节
		DECIMAL(M,D) [UNSIGEND]		定点数M指定长度，D表示小数点的位数


文本，二进制	CHAR(size) char(20)	固定长度字符串，最大255
		VARCHAR(size) varchar(20)	可变长度字符串 0~65535 [即：2^16-1]
		BLOB LONGBLOB		二进制数据 BLOB 0~2^16-1 LONGBLOB 0~2^32-1
		TEXT LONGTEXT		文本TEXT 0~2^16 LONGTEXT 0~2^32

时间日期	DATE/DATETIME/TimeStamp	日期类型(YYYY-MM-DD) (YYYY-MM-DD HH:MM:SS),
						TimeStamp表示时间戳，它可用于自动记录insert，update操作的时间
```

- 创建表练习

```SQL
#创建表emp，使用适当的数据类型，字段如下
#id	整形
#name 字符型
#sex	字符型
#brithday 日期型
#entry_date	日期型
#job	字符型
#Salary 小数型
#resume	文本型

CREATE TABLE `emp` (
	id INT,
	`name` VARCHAR(255),
	`sex` CHAR(1),
	birthday DATE,
	entry__date DATE,
	job VARCHAR(255),
	salary DOUBLE,
	`resume` TEXT
) CHARSET utf8mb3 COLLATE utf8mb3_bin ENGINE INNODB;


INSERT INTO `emp`
	VALUES(100,'小旋风','男','2021-06-06',
		'2022-11-11 11:11:11','巡山的',3000,'大王叫我来巡山');


SELECT * FROM `emp`;
```

#### 修改表

- 使用ALTER TABLE语句追加，修改，删除列(字段)

```sql
#添加列
ALTER TABLE tablename
ADD	(column datatype [DEFAULT expr]
	[, column datatype] ... );

#修改列
ALTER TABLE tablename
MODIFY	(cloumn datatype [DEFAULT expr]
		[, column datatype] ... );

#删除列 
ALTER TABLE tablename
DROP	(column);

#查看表结构
desc tablename;

#修改表名
Rename table 表名 to 新表名

#修改字符集
alter table 表名 character set 字符集;
```

- 修改表emp练习

```sql
#emp上增加一个image列，varchar类型(在resume后面增加)
ALTER TABLE emp 
ADD (image VARCHAR(32) NOT NULL DEFAULT '')
AFTER RESUME;

DESC emp;

#修改job列，使其长度位80,一条语句分多行，需要选中全部才能真正改变
ALTER TABLE emp
	MODIFY job VARCHAR(80) NOT NULL DEFAULT ''

#删除sex列
ALTER TABLE emp
DROP sex

#表名改为employee
RENAME TABLE emp TO employee

DESC employee
#修改表的字符集为utf-8
ALTER TABLE employee CHARACTER SET utf8

#列名name修改为user_name
ALTER TABLE employee 
	CHANGE `name` `user_name` VARCHAR(64) NOT NULL DEFAULT ''
```


## 数据库的CRUD

#### insert

- 使用INSERT语句向表中插入数据

```sql
INSERT INTO table_name [ (column [, column...]) ]
VALUES	(value [, value...] )

#note
插入的数据应与字段的数据类型相同
	若将'abc'添加到 int类型的字段会报错
数据的长度应在列的规定范围内
	不能将一个80长度的字符串加入到长度为40的字段中
在values中列出的数据位置必须与被加入的列的排列位置相对应
	和函数传参相同
字符和日期型数据应包含在单引号中

列可以插入空值[前提是该字段允许为空]
	insert into tablename value(null)
insert into table_name (列名...) values().().()
	这种形式可以添加多条记录
	例： INSERT INTO goods (id, goods_name,price)
			VALUES (50,'windwos',3333), (60,'MacOS',4444), (70,'Linux',5555)
	
		SELECT * FROM goods;
如果给表中所有字段添加数据，可以不在表名后面加上字段名称

当不给某个字段值的时侯，如果有默认值就会添加默认值，否则报错
insert into goods(id,price)
	values (70,9889)	#这种形式可以成功，省略了中间的goods_name,且创建字段时未指定not null
 
```
- 插入练习

```SQL
  #创建一张商品记录表goods(id int ,goods_name varchar(10), price double)
  # 添加2条记录
  
  CREATE TABLE `goods` (
	id INT,
	goods_name VARCHAR(10),
	price DOUBLE
  ); 
  
  INSERT INTO `goods` (id,goods_name,price) 
	VALUES(10,'手机',998); 
	
INSERT INTO `goods` (id,goods_name,price)
	VALUES(11,'pad',1999)
	
SELECT * FROM goods
```


#### update

- 使用update语句修改表中数据

```SQL
UPDATE table_name
	SET col_name1=expr1 [, col_name2=expr2 ...]
	[WHERE where_definition]

#note
UPDATE 可以用新值更新原有表行中的各列
SET 字句指示要修改哪些列和要给予哪些值
WHERE 子句指定应更新哪些行，若无WHERE子句，则更新所有行
若需要修改多个字段，可以通过 set 字段1=值1，字段2=值2...
```

- update练习

```SQL
#演示update
#修改employee表中的数据
#1.将所有员工薪水修改为5K
#由于没带WHERE条件，会修改表下所有记录!!!
update employee
	set salary=5000; 
	
select * from employee

#2.将小旋风的薪水修改为3k
update employee set salary=3000 where user_name='小旋风';

#3.将金角的薪水在原有基础上增加2k
update employee set salary=salary + 2000 where user_name='金角';
```

#### delete

- 使用delete语句删除表中数据

```SQL
delete from table_name
	[WHERE where_definition]

#note
如果不使用where子句，将删除表中所有数据
Delete语句不能删除某一列的值(可使用update设为null或'')
	UPDATE employee SET job='' WHERE user_name='金角';
使用delete语句仅删除记录，不删除表本身，
	如果要删除表，使用drop table语句	drop table 表名;
```

- delete练习

```SQL
#删除表employee中名为金角的记录
DELETE FROM employee WHERE user_name='金角'

#删除表employee中所有记录
DELETE FROM employee; 

SELECT * FROM employee
```

#### select


```SQL
SELECT [DISTINCT] * | {column1, column2, column3 ... }
	FROM table_name;

#note
Select 指定查询哪些列的数据
column 指定列名
星号代表查询所有列
FROM指定查询哪张表
DISTINCT可选，指显示结果时，是否去掉重复数据
``` 


- select练习

```SQL
create table `student` (
	id int not null default 1,
	`student_name` varchar(20) not null default '',
	`chinese` float not null default 0.0,
	`english` float not null default 0.0,
	`math` float not null default 0.0
);

#CHARACTER SET utf8mb3 COLLATE utf8mb3_bin ENGINE INNODB

insert into `student`(id,`student_name`,chinese,english,math) values(1,'ak',89,78,90);
insert into `student` values(2,'Bob',67,98,56)
insert into `student` values(3,'Cc',87,78,77)
insert into `student` values(4,'Dear',88,98,90)
insert into `student` values (5,'Eva',82,84,67)
insert into `student` values(6,'fibo',55,85,45)
insert into `student` values(7,'Girl',75,65,30)

select * from student

#查询表中所有学生的信息
select * from student;
#查询表中所有学生的姓名和对应的英语成绩
select `student_name`,english from student;
#过滤表中重复数据 distinot
select distinct english from student	#可以去重

select distinct `student_name`,english from student #无法去重
#要查询的记录，每个字段都相同，才会去重
```
- select 运算和别名

```SQL
#运算
SELECT *| {column1 | expression, column2 | expression, ...}
	FROM table_name;

#别名
SELECT column_name as 别名 from 表名;
```

```SQL
#统计每个学生的总分
SELECT `student_name`,(chinese + english+math) FROM student

#在所有学生总分上再加10分
SELECT `student_name`,(chinese+english+math + 10) FROM student

#使用别名表示学生分数
SELECT `student_name` AS '姓名',(chinese+english+math+10) AS '总分'
	FROM student
```

- where子句中经常使用的运算符


| 运算符 |描述  |
| :---: | :----: |
|> < <= >= =<> != | 大于，小于，大于(小于)等于，不等于 |
| BETWEEN...AND... | 显示在某一区间的值 |
| IN(set) | 显示在in列表中的值，如in(100,200) |
|LIKE ‘张pattern’	| 模糊查询 |
| NOT LIKE '' | 模糊查询  |  
| IS NULL | 判断是否未空 |
| and | 多个条件同时成立 |
| or | 多个条件任一成立 |
| not | 不成立 |


```SQL
#查询姓名为Cc的成绩
SELECT * FROM `student`
	WHERE `student_name` = 'Cc'
	
#查询英语成绩大于90分的同学
SELECT * FROM `student`
	WHERE `english` > 90

#查询总分大于200的所有同学
SELECT * FROM `student`
	WHERE (chinese + english + math) > 200
	
#查询math大于60且id大于4的学生成绩
SELECT * FROM student
	WHERE math > 60 AND id > 4

#查询英语大于语文的成绩
SELECT * FROM student
	WHERE english > chinese

#查询总分大于200且数学小于语文成绩的姓E的同学
#E% 表示名字以E开头的就可以，LIKE是模糊查询
SELECT * FROM student
	WHERE (chinese+english+math) > 200 AND 
	math < chinese AND student_name LIKE 'E%'
	
#查询英语成绩在80-90之间的同学
SELECT * FROM student
	WHERE english <= 90 AND english >= 80
	
SELECT * FROM student 
	WHERE english BETWEEN 80 AND 90 -- between .. and .. 是闭区间(包含两头)

#查询数学分数为89，90，91的同学 
SELECT * FROM student
	WHERE math BETWEEN 89 AND 91

SELECT * FROM student
	WHERE math = 89 OR math = 90 OR math = 91
	
SELECT * FROM student
	WHERE math IN (89,90,91)
	
#查询所有姓C的学生成绩
SELECT * FROM student
	WHERE student_name LIKE 'C%'
	
#查询数学，语文大于80的同学
SELECT * FROM student
	WHERE math > 80 AND chinese > 80
```


- ```order by```子句用于排序查询结果

```SQL
SELECT column1, column2, column3 ...
	FROM table_name;
	order by column asc|desc, ...

order by 指定排序的列，排序的列既可以是表中的列名，也可以是select语句后指定的列名
Asc 升序[默认]
Desc	降序
order by 子句应位于select的结尾
```

- order by 练习

```SQL
#对数学成绩排序后输出(升序)
SELECT * FROM student
	ORDER BY math ASC
#对总分按降序输出,使用别名
SELECT `student_name`, (chinese+english+math) AS total_score
	FROM student
	ORDER BY total_score DESC

#对姓a的同学成绩[总分]升序输出 where + order by
 SELECT student_name, (chinese+english+math) AS total_score FROM student
	WHERE student_name LIKE 'a%'
	ORDER BY total_score
```
- count统计函数

```SQL
SELECT count(*) count(列名) FROM table_name
	[WHERE where_definition]
```
- sum函数返回满足where条件的行的和

```SQL
SELECT sum(列名) {， sum(列名) ... } FROM table_name
	[WHERE where_definition]
```

```SQL
#统计一个班级数学总成绩
SELECT SUM(math) FROM student

#统计一个班级语文，英语，数学各科的总成绩
SELECT SUM(chinese) AS chinese_total_score,SUM(english),SUM(math) FROM student;

#统计一个班级语文，英语，数学的成绩总和
SELECT SUM(chinese+english+math) FROM student

#统计一个班级语文成绩平均分
SELECT SUM(chinese) / COUNT(*) FROM student
```



- avg函数返回满足where条件的一列的平均值

```SQL
SELECT avg(列名) { , avg(列名) ... } FROM table_name
	[WHERE where_definition] 
```

```SQL
#求一个班级数学平均分
SELECT AVG(math) FROM student

#求一个班级总分平均分
SELECT AVG(chinese+english+math) FROM student
```
- Max/min函数返回满足where条件的一列的最大/最小值

```SQL
SELECT max(列名) FROM table_name
	[WHERE where_definition]
```

```SQL
#求班级最高分和最低分
SELECT MAX(chinese+english+math),MIN(chinese+english+math)
	FROM student

#求班级数学最高分和最低分
SELECT MAX(math),MIN(math) FROM student
```

- group by子句对列进行分组查询

```SQL
SELECT column1, column2, column3 .. FROM table_name
	group by column

#group by用于对查询的结果分组统计
```
- 使用having子句对分组后的结果进行过滤

```SQL
SELECT column1, column2, column3 ..
	FROM table_name
	group by column having ..
#having子句用于限制分组显示结果
```

```SQL
/*部门表*/
CREATE TABLE dept(
    deptno MEDIUMINT UNSIGNED NOT NULL DEFAULT 0,
    dname VARCHAR(20) NOT NULL DEFAULT '',
    loc VARCHAR(13) NOT NULL DEFAULT ''
);
INSERT INTO dept VALUES(10,'ACCOUNTING','NEW YORK'),
    (20,'RESEARCH','DALLAS'),
    (30,'SALES','CHICAGO'),
    (40,'OPERATIONS','BOSHTON');  
    
SELECT * FROM dept; 

#员工表
CREATE TABLE emp(
	empno MEDIUMINT  UNSIGNED NOT NULL DEFAULT 0, #编号
	ename VARCHAR(20) NOT NULL DEFAULT '',	#名字
	job VARCHAR(9) NOT NULL DEFAULT '',	#工作
	mgr MEDIUMINT UNSIGNED,	#上级编号
	hiredate DATE NOT NULL, 	#入职时间
	sal DECIMAL(7,2) NOT NULL,	#薪水
	comm DECIMAL(7,2),	#红利,即奖金
	deptno MEDIUMINT UNSIGNED NOT NULL DEFAULT 0	#部门编号
);

INSERT INTO emp VALUES(7369,'SMITH','CLERK',7902,'1990-12-17',800.00,NULL,20),
    (7499,'ALLEN','SALESMAN',7698,'1991-2-20',1600.00,300.00,30),
    (7521,'WARD','SALESMAN',7968,'1991-2-22',1250.00,500.00,30),
    (7566,'JONES','MANAGER',7839,'1991-4-2',2975.00,NULL,20),
    (7654,'MARTIN','SALESMAN',7968,'1991-9-28',1250.00,1400.00,30),
    (7698,'BLAKE','MANAGER',7839,'1991-5-1',2850.00,NULL,30),
    (7782,'CLARK','MANAGER',7839,'1991-6-9',2450.00,NULL,10),
    (7788,'SCOTT','ANALYST',7566,'1991-4-19',3000.00,NULL,20),
    (7839,'KING','PRESIDENT',NULL,'1991-11-17',5000.00,NULL,10),
    (7844,'TURNER','SALESMAN',7698,'1991-9-8',1500.00,NULL,30),
    (7900,'JAMES','CLERK',7698,'1991-12-3',950.00,NULL,30),
    (7902,'FORD','ANALYST',7566,'1991-12-3',3000.00,NULL,20),
    (7934,'MILLER','CLERK',7782,'1991-1-23',1300.00,NULL,10);
    
SELECT * FROM emp;

#工资级别表
CREATE TABLE salgrade(
    grade MEDIUMINT UNSIGNED NOT NULL DEFAULT 0, #工资级别
    losal DECIMAL(17,2) NOT NULL,	#该级别的最低工资
    hisal DECIMAL(17,2) NOT NULL        #该级别的最高工资
);

INSERT INTO salgrade VALUES(1,700,1200),
    (2,1201,1400),
    (3,1401,2000),
    (4,2001,3000),
    (5,3001,9999);
    
SELECT * FROM salgrade

#如何显示每个部门的平均工资和最高工资
#平均工资用avg(sal),最高工资用max(sal)
#由于不在一张表，所以需要两张表
SELECT AVG(sal),MAX(sal),deptno
	FROM emp GROUP BY deptno;

#显示每个部门的每种岗位的平均工资和最低工资 
SELECT AVG(sal),MIN(sal), deptno, job
	FROM emp GROUP BY deptno,job;

#显示平均工资低于2000的部门号和它的平均工资/别名
#拆分这个问题
#首先显示各个部门的平均工资和部门号 /* 1 */
SELECT AVG(sal), deptno
	FROM emp GROUP BY deptno;
	
#在/* 1 */ 的基础上，再过滤(保留 avg(sal) < 2000)
SELECT AVG(sal), deptno
	FROM emp GROUP BY deptno
		HAVING AVG(sal) < 2000;
		
#使用别名
SELECT AVG(sal) AS avg_sal, deptno
	FROM emp GROUP BY deptno
		HAVING avg_sal < 2000;
```

























## windows安装

- mysql压缩包down到本地后，创建一个安装目录
- 之后执行加压至该目录下，创建配置文件```my.ini```，其内容参考菜鸟教程
- 以管理员运行cmd，进入解压后的mysql中的bin目录(环境变量也配置在此)
- cmd执行```mysqld --initialize --console```,初始化数据库
	* 会有很多输出，最后一条
	
```bash
 A temporary password is generated for root@localhost: plgxY5Td#ssy
#plgxY5Td#ssy就是root登录mysql的密码
```

- 安装mysql
	* 执行```mysqld install```
- 此时已安装完成，但还未启动，因此无法访问
- 启动mysql服务
	* 管理员cmd中输入```net start mysql```,可在任务管理器，服务中找到mysql进程
- 登录mysql

```bash
#cmd中输入
mysql -u root -p

Enter password:plgxY5Td#ssy	#输入mysql初次给的随机密码
#密码正确输入后，此时就可以成功进入MySQL

#若在MySQL命令行中执行 use mysql后报错，则需要修改随机密码
mysql> ALERT USER 'root'@'localhost' identified by 'admin123456';
#此时密码已被重新设置，若要立即生效，还需要命令行刷新(执行如下命令)
mysql> flush privileges;	#刷新
```

















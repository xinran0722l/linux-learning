## 字符串函数

| 函数 | 描述 | 
| :---: | :---: |
| CHARSET(str) | 返回字符串字符集 | 
| CONCAT(string2 [, ...]) | 连接字符串 |
| INSTR(string, substring) | 返回substring在string中出现的位置，没有返回0 |
| UCASE(string2) | 转换成大写 |
| LCASE(string2) | 转小写 |
| LEFT(string2, length) | 从string2中的左边起取length个字符 |
| LENGTH(string) | string长度[按照字节] |
| REPLACE(str,search_str,replace_str) | 在str中用replace_str替换search_str |
| STRCMP(string1,string2) | 逐字符比较两字符串大小 |
| SUBSTRING(str,position [, length]) | 从str的position开始[从1开始计算],取length个字符,若无length，则取至最后 |
| LTRIM(string2) RTRIM(string2) trim(string) | 去除前端空格或后端空格  |


```sql
#使用emp表演示字符串函数
#CHARSET(str)返回字符串字符集
select charset(ename) from emp;

#CONCAT(string2 [, ...]) 连接字符串,将多个列拼接成一列
select concat(ename,' job is ', job) from emp;
select concat(ename ,' 工作是 ' ,job) from emp;
 
#INSTR(string, substring) 返回substring在string中出现的位置，没有返回0
SELECT instr('Hello Database','Data') from dual; #DUAL是亚元表，db提供的测试表 
 
#UCASE(string2) 转大写
select Ucase(ename) from emp;
 
#LCASE(string2) 转小写
select lcase(ename) from emp;
 
#LEFT(string2,length) 从string2中的左边起取length个字符
select left(ename,3) from emp;
select right(ename,2) from emp; 
 
#LENGTH(string) string长度[按照字节]
select length(ename) from emp; 
 
#REPLACE(str,search_str,replace_str) 在str中用replace_str替换search_str
select ename, replace(job,'MANAGER','管理') from emp; 
 
#STRCMP(string1,string2)逐字符比较两个字符串
select strcmp('hello','hello') from DUAL; #结果为0
select strcmp('hello','ohell') from dual; #结果为-1
select strcmp('hello','a') from dual;	#结果为1

#SUBSTRING(str,position [, length]) 从str的position开始[从1开始计算]
select substring(ename,2,3) from emp;

#LTRIM(string2) RTRIM(string2) trim(string) 去除前端或后端空格
select ltrim('  hello  ') from dual;
SELECT rTRIM('  hello  ') FROM DUAL;
SELECT TRIM('  hello  ') FROM DUAL;
 

#练习：以首字母小写的方式显示所有员工emp表的姓名
select concat(LCASE(SUBSTRING(ename,1,1)),SUBSTRING(ename,2,LENGTH(ename)-1)) as new_name from emp;
```



## 数学函数

| 函数 | 描述 | 
| :---: | :---: |
| ABS(sum) | 绝对值 | 
| BIN(decimal_number) | 十进制转二进制 |
| CEILING(number2) | 向上取整，得到比number2大的最小整数 |
| CONV(number2,from_base,to_base) | 进制转换 |
| FLOOR(number2) | 向下取整，得到比number2小的最大整数 |
| FORMAT(number,decimal_places) | 保留小数位数 |
| HEX(decimal_number) | 转16进制 |
| LEAST(number，number2 [, ...]) | 求最小值 |
| MOD(numerator,denominator) | 求余 |
| RAND([seed]) | RAND([seed])随机范围为0<= v <= 1.0 | 


```sql
-- ABS(sum)	绝对值
SELECT ABS(-10) FROM DUAL;

-- BIN(decimal_number)	十进制转二进制
SELECT BIN(2) FROM DUAL;

-- CEILING(number2)	向上取整，得到比number2大的最小整数
SELECT CEILING(3.14) FROM DUAL;
SELECT CEILING(-1.2) FROM DUAL;

-- CONV(number2,from_base,to_base)	进制转换
SELECT CONV(15,10,16) FROM DUAL; #将15从10进制转为16进制

-- FLOOR(number2)	向下取整，得到比number2小的最大整数
SELECT FLOOR(-1.2) FROM DUAL;
SELECT FLOOR(3.14) FROM DUAL;

-- FORMAT(number,decimal_places)	保留小数位数
SELECT FORMAT(3.1415926,3) FROM DUAL; #四舍五入

-- HEX(decimal_number)	转16进制
SELECT HEX(10) FROM DUAL;

-- LEAST(number，number2 [, ...])	求最小值
SELECT LEAST(3,-2,9,0) FROM DUAL;

-- MOD(numerator,denominator)	求余
SELECT MOD(10,3) FROM DUAL;

-- RAND([seed])	RAND([seed])随机范围为0<= v <= 1.0
#注意，若添加seed参数，则随机值会被固定
SELECT RAND() FROM DUAL;
```

## 日期函数

| 函数 | 描述 | 
| :---: | :---: |
| CURRENT_DATE() | 当前日期 | 
| CURRENT_TIME() | 当前时间 |
| CURRENT_TIMESTAMP() | 当前时间戳 |
| DATE(datetime) | 返回datetime的日期部分 |
| DATE_ADD(date2,INTERVAL d_value d_type) | 在date2中加上日期或时间 |
| DATE_SUB(date2,INTERVAL d_value d_type) | 在date2上减去一个时间 |
| DATEDIFF(date1,date2) | 两个日期差(结果为天) |
| TIMEDIFF(date1,date2) | 两个时间差(单位时分秒) |
| NOW() | 当前时间 |
| YEAR\|MONTH\|DATE(datetime)  FROM_UNIXTIME()| 年月日 |

```sql
DATE()
DATE_ADD()
DATE_SUB()
DATEDIFF()
这四个函数的日期类型可以是date '1990-11-11',datetime '1990-11-11 08:08:08'或datestamp
```

- CURRENT_DATE()	当前日期

```sql
mysql> select current_date() from dual;
+----------------+
| current_date() |
+----------------+
| 2022-11-22     |
+----------------+
1 row in set (0.00 sec)
```
- CURRENT_TIME()	当前时间

```sql
mysql> select current_time() from dual;
+----------------+
| current_time() |
+----------------+
| 10:30:08       |
+----------------+
1 row in set (0.00 sec)
```
- CURRENT_TIMESTAMP()	当前时间戳

```sql
mysql> select current_timestamp() from dual;
+---------------------+
| current_timestamp() |
+---------------------+
| 2022-11-22 10:30:59 |
+---------------------+
1 row in set (0.00 sec)
```
- NOW()	当前时间

```sql
mysql> select now() from DUAL;
+---------------------+
| now()               |
+---------------------+
| 2022-11-22 10:31:59 |
+---------------------+
1 row in set (0.00 sec)
```

- DATEDIFF(date1,date2)	两个日期差(结果为天)

```sql
datediff()得到的是天数，而且是date1-date2的天数(可以取负 )

#求出2011-11-11和1990-01-01相差几天

mysql> select datediff('2011-11-11','1990-01-01') from dual;
+-------------------------------------+
| datediff('2011-11-11','1990-01-01') |
+-------------------------------------+
|                                7984 |
+-------------------------------------+
1 row in set (0.00 sec)

#假设有一位1990-11-11日出生的人，请问他活了多少天
mysql> select datediff(now(), '1990-11-11') from dual;
+-------------------------------+
| datediff(now(), '1990-11-11') |
+-------------------------------+
|                         11699 |
+-------------------------------+
1 row in set (0.00 sec)

#请问这位1990-11-11日的人至今天的年龄
mysql> select datediff(now(), '1990-11-11') / 365 from dual;
+-------------------------------------+
| datediff(now(), '1990-11-11') / 365 |
+-------------------------------------+
|                             32.0521 |
+-------------------------------------+
1 row in set (0.00 sec)

```

- 创建一个表用于演示时间函数

```sql
create table mes (
	id int,
	content varchar(30),
	send_time datetime
);

insert into mes 
	values(1,'北京新闻',current_timestamp());

insert into mes values(2,'上海新闻',now())
insert into mes values(3,'广州新闻',now())
select * from mes;
```

- DATE(datetime)	返回datetime的日期部分

```sql
#显示表mes中所有新闻信息，发布日期只显示日期，不显示时间

mysql> select id,content,date(send_time) from mes;
+------+--------------+-----------------+
| id   | content      | date(send_time) |
+------+--------------+-----------------+
|    1 | 北京新闻     | 2022-11-21      |
|    2 | 上海新闻     | 2022-11-22      |
|    3 | 广州新闻     | 2022-11-22      |
+------+--------------+-----------------+
3 rows in set (0.00 sec)
```

- DATE_ADD(date2,INTERVAL d_value d_type)	在date2中加上日期或时间

```sql
date_add()中的 interval 后面可以是 year，minute，second，hour,day等

#请查询在10分钟内发布的新闻

select * from mes
	where date_add(send_time,interval 10 minute) >= now()

#命令和输出如下
mysql> select * from mes where date_add(send_time,interval 10 minute) >= now();
+------+--------------+---------------------+
| id   | content      | send_time           |
+------+--------------+---------------------+
|    2 | 上海新闻     | 2022-11-22 10:16:03 |
|    3 | 广州新闻     | 2022-11-22 10:16:31 |
+------+--------------+---------------------+
2 rows in set (0.00 sec)

#若一个人出生于1990-11-11，请算出其活至80岁，还剩多少天
mysql> select datediff(date_add('1990-11-11', interval 80 year), now()) from DUAL;
+-----------------------------------------------------------+
| datediff(date_add('1990-11-11', interval 80 year), now()) |
+-----------------------------------------------------------+
|                                                     17521 |
+-----------------------------------------------------------+
1 row in set (0.00 sec)
```

- DATE_SUB(date2,INTERVAL d_value d_type)	在date2上减去一个时间

```sql
date_sub() 中的interval后面可以是year，minute，second，hour,day等

#请查询在10分钟内发布的新闻

mysql> select * from mes where send_time >= date_sub(now(), interval 10 minute);
+------+--------------+---------------------+
| id   | content      | send_time           |
+------+--------------+---------------------+
|    2 | 上海新闻     | 2022-11-22 10:16:03 |
|    3 | 广州新闻     | 2022-11-22 10:16:31 |
+------+--------------+---------------------+
2 rows in set (0.00 sec)
```

- TIMEDIFF(date1,date2)	两个时间差(单位时分秒)

```sql
mysql> select timediff('11:11:11','08:08:08') from DUAL;
+---------------------------------+
| timediff('11:11:11','08:08:08') |
+---------------------------------+
| 03:03:03                        |
+---------------------------------+
1 row in set (0.00 sec)
```

- unix_timestamp()	返回unix元年至今的秒数

```sql
mysql> select unix_timestamp() / (24*365*3600) from dual;
+----------------------------------+
| unix_timestamp() / (24*365*3600) |
+----------------------------------+
|                          52.9264 |
+----------------------------------+
1 row in set (0.00 sec)
```
- FROM_UNIXTIME() 将一个unix_timestamp() 秒数，转换为指定格式的日期

```sql
mysql> select from_unixtime(1669087945) from DUAL;
+---------------------------+
| from_unixtime(1669087945) |
+---------------------------+
| 2022-11-22 11:32:25       |
+---------------------------+
1 row in set (0.00 sec)

mysql> select from_unixtime(1669087945, '%Y-%m-%d') from DUAL;
+---------------------------------------+
| from_unixtime(1669087945, '%Y-%m-%d') |
+---------------------------------------+
| 2022-11-22                            |
+---------------------------------------+
1 row in set (0.00 sec)

mysql> select from_unixtime(1669087945, '%Y-%m-%d %H:%i:%s') from DUAL;
+------------------------------------------------+
| from_unixtime(1669087945, '%Y-%m-%d %H:%i:%s') |
+------------------------------------------------+
| 2022-11-22 11:32:25                            |
+------------------------------------------------+
1 row in set (0.00 sec)
```

- YEAR|MONTH|DATE(datetime) 年月日 

```sql
mysql> select now() from DUAL;
+---------------------+
| now()               |
+---------------------+
| 2022-11-22 11:29:09 |
+---------------------+
1 row in set (0.00 sec)

mysql> select year(now()) from dual;
+-------------+
| year(now()) |
+-------------+
|        2022 |
+-------------+
1 row in set (0.00 sec)

mysql> select month(now()) from dual;
+--------------+
| month(now()) |
+--------------+
|           11 |
+--------------+
1 row in set (0.00 sec)

mysql> select day(now()) from dual;
+------------+
| day(now()) |
+------------+
|         22 |
+------------+
1 row in set (0.00 sec)

mysql> select year('1990-11-11') from DUAL;
+--------------------+
| year('1990-11-11') |
+--------------------+
|               1990 |
+--------------------+
1 row in set (0.00 sec)
#月和日同理
```


## 加密和系统函数

| 函数 | 描述 | 
| :---: | :---: |
| USER() | 查询用户 | 
| DATABASE() | 数据库名称 |
| MD5(str) | 为字符串算出一个MD5 32的字符串(用户密码加密) |
| PASSWORD(str) | 从原文密码str计算并返回密码字符串，Mysql8.0以取消 |

- USER()	查询用户

```sql
#user()返回格式为 用户@IP地址

mysql> SELECT USER() FROM DUAL;
+----------------+
| USER()         |
+----------------+
| root@localhost |
+----------------+
1 row in set (0.00 sec)
```
- DATABASE()	数据库名称

```sql
mysql> select database() from dual;
+------------+
| database() |
+------------+
| base_db02  |
+------------+
1 row in set (0.00 sec)
```
- MD5(str)	为字符串算出一个MD5 32的字符串(用户密码加密)

```sql
mysql> select md5('hello') from dual;
+----------------------------------+
| md5('hello')                     |
+----------------------------------+
| 5d41402abc4b2a76b9719d911017c592 |
+----------------------------------+
1 row in set (0.00 sec)

#无论字符串多长，经过md5加密后，返回的结果长度始终为32
mysql> select length(md5('hello')) from dual;
+----------------------+
| length(md5('hello')) |
+----------------------+
|                   32 |
+----------------------+
1 row in set (0.00 sec)
```

- 创建一个加密测试表pwd_users

```sql
mysql> create table pwd_users(id int,
    -> `name` varchar(32) not null default '',
    -> pwd char(32) not null default ''
    -> );
Query OK, 0 rows affected (0.01 sec)

mysql> select * from pwd_users;
Empty set (0.00 sec)
```

- 添加信息至表pwd_users

```sql
mysql> insert into pwd_users
    -> values(100,'testuser',md5('hello')
    -> );
Query OK, 1 row affected (0.01 sec)

mysql> select * from pwd_users;
+------+----------+----------------------------------+
| id   | name     | pwd                              |
+------+----------+----------------------------------+
|  100 | testuser | 5d41402abc4b2a76b9719d911017c592 |
+------+----------+----------------------------------+
1 row in set (0.00 sec)
```
- 查询加密后的行

```sql
mysql> select * from pwd_users
    -> where `name` = 'testuser' AND pwd = md5('hello');

+------+----------+----------------------------------+
| id   | name     | pwd                              |
+------+----------+----------------------------------+
|  100 | testuser | 5d41402abc4b2a76b9719d911017c592 |
+------+----------+----------------------------------+
1 row in set (0.00 sec)
```

- mysql.user 表示 数据库.表

```sql
#先查看当前有哪些数据库
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| base_db02          |
| base_db03          |
| db01               |
| db02               |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
8 rows in set (0.00 sec)
#由于database返回的mysql数据库中，其内表过多，不予展示
#想查看的话可以使用如下命令
show database；
use mysql;
show tables;

#查看mysql这个数据库下的user表

mysql> select * from mysql.user;
+-----------+------------------+-------------+-------------+-------------+-------------+-------------+-----------+-------------+---------------+--------------+-----------+------------+-----------------+------------+------------+--------------+------------+-----------------------+------------------+--------------+-----------------+------------------+------------------+----------------+---------------------+--------------------+------------------+------------+--------------+------------------------+----------+------------------------+--------------------------+----------------------------+---------------+-------------+-----------------+----------------------+-----------------------+------------------------------------------------------------------------+------------------+-----------------------+-------------------+----------------+------------------+----------------+------------------------+---------------------+--------------------------+-----------------+
| Host      | User             | Select_priv | Insert_priv | Update_priv | Delete_priv | Create_priv | Drop_priv | Reload_priv | Shutdown_priv | Process_priv | File_priv | Grant_priv | References_priv | Index_priv | Alter_priv | Show_db_priv | Super_priv | Create_tmp_table_priv | Lock_tables_priv | Execute_priv | Repl_slave_priv | Repl_client_priv | Create_view_priv | Show_view_priv | Create_routine_priv | Alter_routine_priv | Create_user_priv | Event_priv | Trigger_priv | Create_tablespace_priv | ssl_type | ssl_cipher             | x509_issuer              | x509_subject               | max_questions | max_updates | max_connections | max_user_connections | plugin                | authentication_string                                                  | password_expired | password_last_changed | password_lifetime | account_locked | Create_role_priv | Drop_role_priv | Password_reuse_history | Password_reuse_time | Password_require_current | User_attributes |
+-----------+------------------+-------------+-------------+-------------+-------------+-------------+-----------+-------------+---------------+--------------+-----------+------------+-----------------+------------+------------+--------------+------------+-----------------------+------------------+--------------+-----------------+------------------+------------------+----------------+---------------------+--------------------+------------------+------------+--------------+------------------------+----------+------------------------+--------------------------+----------------------------+---------------+-------------+-----------------+----------------------+-----------------------+------------------------------------------------------------------------+------------------+-----------------------+-------------------+----------------+------------------+----------------+------------------------+---------------------+--------------------------+-----------------+
| localhost | mysql.infoschema | Y           | N           | N           | N           | N           | N         | N           | N             | N            | N         | N          | N               | N          | N          | N            | N          | N                     | N                | N            | N               | N                | N                | N              | N                   | N                  | N                | N          | N            | N                      |          | 0x                     | 0x                       | 0x                         |             0 |           0 |               0 |                    0 | caching_sha2_password | $A$005$THISISACOMBINATIONOFINVALIDSALTANDPASSWORDTHATMUSTNEVERBRBEUSED | N                | 2022-11-16 12:47:16   |              NULL | Y              | N                | N              |                   NULL |                NULL | NULL                     | NULL            |
| localhost | mysql.session    | N           | N           | N           | N           | N           | N         | N           | Y             | N            | N         | N          | N               | N          | N          | N            | Y          | N                     | N                | N            | N               | N                | N                | N              | N                   | N                  | N                | N          | N            | N                      |          | 0x                     | 0x                       | 0x                         |             0 |           0 |               0 |                    0 | caching_sha2_password | $A$005$THISISACOMBINATIONOFINVALIDSALTANDPASSWORDTHATMUSTNEVERBRBEUSED | N                | 2022-11-16 12:47:16   |              NULL | Y              | N                | N              |                   NULL |                NULL | NULL                     | NULL            |
| localhost | mysql.sys        | N           | N           | N           | N           | N           | N         | N           | N             | N            | N         | N          | N               | N          | N          | N            | N          | N                     | N                | N            | N               | N                | N                | N              | N                   | N                  | N                | N          | N            | N                      |          | 0x                     | 0x                       | 0x                         |             0 |           0 |               0 |                    0 | caching_sha2_password | $A$005$THISISACOMBINATIONOFINVALIDSALTANDPASSWORDTHATMUSTNEVERBRBEUSED | N                | 2022-11-16 12:47:16   |              NULL | Y              | N                | N              |                   NULL |                NULL | NULL                     | NULL            |
| localhost | root             | Y           | Y           | Y           | Y           | Y           | Y         | Y           | Y             | Y            | Y         | Y          | Y               | Y          | Y          | Y            | Y          | Y                     | Y                | Y            | Y               | Y                | Y                | Y              | Y                   | Y                  | Y                | Y          | Y            | Y                      |          | 0x                     | 0x                       | 0x                         |             0 |           0 |               0 |                    0 | caching_sha2_password | $A$005$/Xj{Q5V xo#     kP,\w]4n7OxoEGQnVw0LWEm1.Gzk/DsbU3BObsznodFnvHsi9 | N                | 2022-11-16 12:56:46   |              NULL | N              | Y                | Y              |                   NULL |                NULL | NULL                     | NULL            |
+-----------+------------------+-------------+-------------+-------------+-------------+-------------+-----------+-------------+---------------+--------------+-----------+------------+-----------------+------------+------------+--------------+------------+-----------------------+------------------+--------------+-----------------+------------------+------------------+----------------+---------------------+--------------------+------------------+------------+--------------+------------------------+----------+------------------------+--------------------------+----------------------------+---------------+-------------+-----------------+----------------------+-----------------------+------------------------------------------------------------------------+------------------+-----------------------+-------------------+----------------+------------------+----------------+------------------------+---------------------+--------------------------+-----------------+
4 rows in set (0.00 sec)

#其中 authentication_string 此字段存储着密码
```

## 流程控制函数

| 函数 | 描述 | 
| :---: | :---: |
| IF(expr1,expr2,expr3) | 如果expr1为True，则返回expr2，否则返回expr3| 
| IFNULL(expr1,expr2) | 如果expr1不为空NULL，则返回expr1，否则返回expr2 |
| SELECT CASE WHEN expr1 THEN expr2 <br/> WHEN expr3 THEN expr4 ELSE expr5 END| 如果expr1为True，则返回expr2<br/> 否则如果expr3为True，返回expr4，否则返回expr5 |


- IF(expr1,expr2,expr3)	如果expr1为True，则返回expr2，否则返回expr3

```sql
mysql> select if(true, 'bg','sh') from dual;
+---------------------+
| if(true, 'bg','sh') |
+---------------------+
| bg                  |
+---------------------+
1 row in set (0.00 sec)

mysql> select if(false,'bg','sh') from dual;
+---------------------+
| if(false,'bg','sh') |
+---------------------+
| sh                  |
+---------------------+
1 row in set (0.00 sec)
```

- IFNULL(expr1,expr2)	如果expr1不为空NULL，则返回expr1，否则返回expr2

```sql
mysql> select ifnull('bg','sh') from dual;
+-------------------+
| ifnull('bg','sh') |
+-------------------+
| bg                |
+-------------------+
1 row in set (0.00 sec)

mysql> select ifnull(null,'sh') from dual;
+-------------------+
| ifnull(null,'sh') |
+-------------------+
| sh                |
+-------------------+
1 row in set (0.00 sec)
```

- case when .. then .. else .. end 多分支

```sql
#同编程语言中的if..else

mysql> select case
    -> when TRUE then 'jack'
    -> when FAlse then 'tom'
    -> else 'marry' end;
+-------------------------------------------------------------------+
| case
when TRUE then 'jack'
when FAlse then 'tom'
else 'marry' end |
+-------------------------------------------------------------------+
| jack                                                              |
+-------------------------------------------------------------------+
1 row in set (0.00 sec)

mysql> SELECT CASE
    ->  WHEN FALSE THEN 'jack'
    ->  WHEN FALSE THEN 'tom'
    ->  ELSE 'marry' END;
+------------------------------------------------------------------------+
| CASE
        WHEN FALSE THEN 'jack'
        WHEN FALSE THEN 'tom'
        ELSE 'marry' END |
+------------------------------------------------------------------------+
| marry                                                                  |
+------------------------------------------------------------------------+
1 row in set (0.00 sec)
```

- 判断表中字段是否为空(is null is not null)

```sql
#以base_db02数据库中表emp演示，其中emp如下
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


mysql> select ename, if(comm IS NULL,0.0, comm) from emp;
+--------+----------------------------+
| ename  | if(comm IS NULL,0.0, comm) |
+--------+----------------------------+
| SMITH  |                        0.0 |
| ALLEN  |                     300.00 |
| WARD   |                     500.00 |
| JONES  |                        0.0 |
| MARTIN |                    1400.00 |
| BLAKE  |                        0.0 |
| CLARK  |                        0.0 |
| SCOTT  |                        0.0 |
| KING   |                        0.0 |
| TURNER |                        0.0 |
| JAMES  |                        0.0 |
| FORD   |                        0.0 |
| MILLER |                        0.0 |
+--------+----------------------------+
13 rows in set (0.00 sec)

#使用IFNULL()实现
mysql> select ename, ifnull(comm,0.0) from emp;
+--------+------------------+
| ename  | ifnull(comm,0.0) |
+--------+------------------+
| SMITH  |             0.00 |
| ALLEN  |           300.00 |
| WARD   |           500.00 |
| JONES  |             0.00 |
| MARTIN |          1400.00 |
| BLAKE  |             0.00 |
| CLARK  |             0.00 |
| SCOTT  |             0.00 |
| KING   |             0.00 |
| TURNER |             0.00 |
| JAMES  |             0.00 |
| FORD   |             0.00 |
| MILLER |             0.00 |
+--------+------------------+
13 rows in set (0.00 sec)
```

- 使用emp表演示多分支

```sql
#如果emp表中的job是CLERK则显示职员，如果是MANAGE则显示管理
#	如果是SALESMAN则显示销售，其他正常显示

SELECT ename, (SELECT CASE
	WHEN job='CLERK' THEN '职员'
	WHEN job='MANAGER' THEN '管理'
	WHEN job='SALESMAN' THEN '销售'
	ELSE job END) AS job
     FROM emp;

+--------+-----------+
| ename  | job       |
+--------+-----------+
| SMITH  | 职员      |
| ALLEN  | 销售      |
| WARD   | 销售      |
| JONES  | 管理      |
| MARTIN | 销售      |
| BLAKE  | 管理      |
| CLARK  | 管理      |
| SCOTT  | ANALYST   |
| KING   | PRESIDENT |
| TURNER | 销售      |
| JAMES  | 职员      |
| FORD   | ANALYST   |
| MILLER | 职员      |
+--------+-----------+
13 rows in set (0.00 sec)
```




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


```SQL
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


```SQL
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











































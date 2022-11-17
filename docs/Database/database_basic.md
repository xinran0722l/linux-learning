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
- 创建数据库

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
- 查询，删除数据库

```sql
#查看当前数据库服务器中的所有数据库
SHOW DATABASES
#查看前面创建的base_db01数据库的定义信息
SHOW CREATE DATABASE base_db01
#删除前面创建的base_db01数据库
DROP DATABASE base_db01
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

















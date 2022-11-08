## 定时任务 cron
- cron 定时任务的名字
- crond 定时任务进程名
- crontab 管理定时任务命令
- cron是Linux中以后台进程模式周期性执行命令或指定程序任务的服务软件名
- Linux启动后，cron软件便会启动，对应的进程名字叫做crond，默认定期(每分钟)检查系统中是否有需要执行的任务计划
  * 如果有，则按计划执行

```bash
#查看cron进程
$ ps aux | grep crond
qinghuo    692  0.0  0.0   8164   720 pts/0    S+   04:59   0:00 grep --color=auto crond
```

- crond应用场景
	* 夜间数据库定时备份
	* 夜间网站数据(用户上传，文件，图片，程序)备份
	* 备份等待时间过长
	* 任务重复性高
- cron默认时间是1分钟，当需要秒钟级任务时，shell脚本更适合

## Linux下定时任务软件

- ```at```定时任务工具，依赖于atd服务，适用于执行一次就结束的调度任务
	* 例如突发任务，某天夜里3点需要临时性备份数据，推荐使用at

```bash
#at语法
HH:MM
YYYY-mm-dd
noon	中午12点
midnight	午夜晚12点
teatime	下午茶，下午4点
tomorrow	明天
now+1min	一分钟后
mou+1minutes/hours/days/weeks
```


### cron分类

- cron任务分为两类
	* 系统定时任务
- crond服务除了会在工作时查看```/var/spool/cron```文件夹下的党史人物文件外
	* 还会查看```/etc/cron.d```目录以及```/etc/anacrontab```下的内容
	* 里面存放```每天，每周，每月需要执行的系统任务```
```bash
$ ll /etc/ | grep cron*
drwxr-xr-x   2 root root       4096 Oct 21 17:58 cron.d/	#系统定时任务
drwxr-xr-x   2 root root       4096 Oct 21 17:58 cron.daily/	#每天的任务
drwxr-xr-x   2 root root       4096 Mar  3  2022 cron.hourly/	#每小时执行的任务
drwxr-xr-x   2 root root       4096 Mar  3  2022 cron.monthly/	#每月的定时任务
drwxr-xr-x   2 root root       4096 Oct 21 17:58 cron.weekly/	#每周的定时任务
-rw-r--r--   1 root root       1042 Feb 14  2020 crontab	#配置文件
```

    
### 源码编译

- 以cmatrix源码为例
- 首先通过wget下载```cmatrix.tar.gz```至本地
- 通过tar解压为一个目录
- cd进解压后的目录
- 执行脚本```configure```文件
	* ```./configure --prefix=安装路径```
- 执行```make```命令
	* 借助Makefile内的编译规范进行编译
- 执行```make install```安装
- 可以通过```echo $PATH```检查是否cmatrix是否在环境变量中


## File System
- 常见的文件系统
- fat16,fat32 最早的windows文件系统，缺点为单个文件大小不能超过2GB
- NTFS，支持文件加密，采用日志形式的文件系统，详细记录磁盘读写，支持数据恢复，能提高磁盘读写的安全性，突破了单个文件4G大小的限制
- exFAT，单个文件支持16G大小，能在windows，Linux，MacOS中同时识别
- mbr(master boot record)分区表
	* 主分区引导记录，磁盘容量受限制，最大2T
- gpt分区表
	* 磁盘容量没有限制，分区个数没有限制，自带磁盘保护机制













































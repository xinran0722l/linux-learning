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
- 网络共享文件系统
	* nfs Network File System
	* smb Server Message Block 服务消息块
- 集群文件系统
	* gfs Google File System google为了存储海量数据而开发的文件系统
	* ocfs Oracle Cluster File System oracle为了数据库研发平台定制的文件系统
- 分布式文件系统
	* ceph 为了存储的可靠性和扩展性的分布式文件系统
- mbr(master boot record)分区表
	* 主分区引导记录，磁盘容量受限制，最大2T
- gpt分区表
	* 磁盘容量没有限制，分区个数没有限制，自带磁盘保护机制

- ```mkfs```针对磁盘分区进行格式化文件系统
- ```fsck```修复文件系统的命令

- 查看文件系统的属性
	* centos7之前使用dumpe2fs命令，打印文件系统的块组信息，适用于ext2，ext3，ext4
	* centos7之后的系统默认使用xfs文件系统，使用xfs_indo打印文件系统信息
- tune2fs命令，数值Linux是否开机自动检查文件系统正常与否
- lsblk命令，列出所有的设备以及文件系统信息
	* ```lsblk -f``` #列出分区的文件系统类型

## 挂载

- Linux下设备不挂载无法使用
	* /dev/sdb1 /dev/sdb2等都是Linux的磁盘设备文件，无法直接使用读写数据
- 挂载通常将一个存储设备挂到另一个已经存在的文件夹中，访问该文件夹，就是访问该存储设备的内容
- U盘
	* 将Linux本身的普通文件夹和U盘的设备文件合二为一，这个过程就是挂载的过程
	* 挂载之后，Linux上的这个普通文件夹，叫做挂载点
- mount命令
	* 将指定的文件系统挂载到指定的目录上(挂载点，LInux上的一个文件夹)

1. 一个新的硬盘插到主板上，分区之后，针对分区格式化文件系统(nets,.ext3,ext4,xfs...)
2. 此时还未挂载分区，无法读写
3. 针对分区和Linux的文件夹，合并，关联，挂载即可通过访问被挂载的文件夹，读写硬盘的数据

```bash
mount常用参数
-l 显示系统所有挂载的设备信息
-t 指定设备的文件系统类型，若不指定，mount自动选择挂载的文件系统类型
-o 添加挂载的功能选项(使用频繁)
-r read(挂在后的设备只读)
-w 读写参数，-o rw权限，允许挂在后读写

centos7上新出现的mount选项有
att2 在磁盘上存储内连扩展属性，提升磁盘性能
inode64 允许在文件系统的任意位置创建inode
noquota 强制关闭文件系统的限额功能

mount的-o参数详解

async 异步处理文件系统IO，加速写入，数据不会同步的写入到磁盘，先接入缓冲区，提高系统性能，损失数据安全性
sync 所有的IO操作同步处理，数据同步写入磁盘，性能较弱，提高数据读写的安全性
atime/noaatime 文件被访问的时候，是否修改其时间戳，能够提升磁盘IO速度
exec/noexec 是否允许执行挂载点内的可执行命令，使用了noexec，提升磁盘安全性
defaults 涵盖了rw suid dev exec auto nouser async等参数
ro 只读
rw 读写
```

## 临时释放内存

- 提示内存不足，但cache，buffer中又大量内存，如何将其释放
	1. 释放cache命令
		* ```echo 1 > /proc/sys/vm/drop_caches``` 等同于 ```sysctl -w vm.drop_caches=1```
	2. 清除目录缓存和inodes
		* ```echo 2 > /proc/sys/vm/drop_caches```等同于```sysctl -w vm.drop_caches=2```
	3. 清除内存页的缓存
		* ```echo 3 > /proc/sys/vm/drop_caches``` 等同于 ```sysctl -w vm.drop_caches=3```
- 以上3中都是```临时释放缓存```的命令(若buffer，cache正在使用则无效)
- sync的作用：将内存缓冲区的数据写入硬盘，还可以清理僵尸进程



## 开机自动挂文件

1. 由于mount命令直接输入是临时生效，下次重启，挂载的设备分区就无法使用了
	* ```/etc/fstab```文件，存放系统一些静态文件，主要是系统启动时会读取这个文件，将指定的挂载点，进行挂载
	* 通过```mount -a```命令，可以读取```/etc/fstab```文件所有的挂载情况

```bash
#/etc/fstab文件如下

/dev/sdb5	/mnt	xfs	defaults	0	0

第一列：一个设备的名字，可以是文件系统，也可以是设备名称(NFS远程网络文件系统)

mount /dev/sdb5 /mnt	#一种写法
mount 192.168.11.15:/home/nfs	/mnt/ -o nolock	#把本地的/mnt文件夹挂载到nfs文件系统上，且不加锁

第二列：挂载点
是一个自己创建的目录，是一个已经存在的目录

第三列：Linux能支持的文件系统类型
ext3 ext4 nfs swap

第四列：挂载的功能选项，有很多，默认defaults

第五列：dump
表示将整个文件夹内容备份，一般不对挂载点备份，默认都是0

第六列：fsck 磁盘检查
默认都是0，不对磁盘检查，根文件系统是默认检查的

```

- df命令，检查挂载点的情况

```bash
-h 显示kb，mb单位大小
-i 显示inode数量
```

-  du命令，显示磁盘空间大小，文件大小的命令
	* Linux文件存储最小单位是4k，也就是8个扇区	

```bash
du -h #显示文件大小，以kb，mb为单位
du -h * 显示当前目录所有文件的大小
du -a 显示目录中所有文件的大小

du -ah --max-depth=1  /etc/	#查看/etc下第一层文件的大小

显示出/etc目录下所有文件，除了,conf文件的大小(指定排除文件名)
du -ah --exclude='*.conf' /etc
```


## raid

- raid(Redundant Arrays of Independent Drives)磁盘冗余整列
- raid计数是将多块独立的磁盘，组成一个磁盘组
- raid计数意图在于把多个独立的硬盘设备，组成一个容量更大，安全性更高的磁盘阵列组，将数据切为多个区段之后分别存储在不同的物理硬盘上
	* 利用分散读写计数提升磁盘整体性能，
	* 数据同不在了不同的多个磁盘上，数据也得到了冗余备份的作用
- raid特性
	* 保证数据安全性，增加硬盘成本，提升读写效率

- 饮水机和硬盘的关系

```bash
standalone	独立模式
	一块硬盘单独工作，读写数据
	一台饮水机，一天通水

hot swap	热备份模式
	一桶水抗风险能力不足，旁边再放一桶水
	为了防止单独的一块硬盘损坏，随时准备好另外一块硬盘接替

cluster	集群模式
	一堆饮水机，即使坏了一台，也有其他机器
	一堆硬盘共同提供服务，提高读写效率
```

- raid计数分为多个级别
	* raid0
	* raid1
	* raid5
	* raid10

- raid0

```bash
raid0 特点是数据一次写入硬盘，在理想状态下，写入速度是翻倍
	单反任意坏了一张硬盘，数据都将损坏，数据写入2块硬盘中，没有备份的功能
raid0	适用于追求性能，且不关注数据安全性的场景
```

- raid1
```bash
raid1	将两块以上的硬盘绑定关系，数据写入时，同时写入多块硬盘(备份)
	极大的降低了磁盘的利用率
	例如2块硬盘共4T容量，通过raid1，可使用容量只有2T，利用率只有50%
	若时3块1T的硬盘组成raid1，则利用率只有33%
```

- raid3
- 异或
	* 数字相同则为0，数字不同则为1

```bash
磁盘的异或运算
AxorBxorC	A异或B异或C
多个值的异或计算概念时
	1的个数是奇数，结果为1
	1的个数是偶数，结果为0
异或的作用：奇偶校验，任何一个值都能反推出来

raid3 必须需要3块以上的硬盘
例：
磁盘1：	0101
磁盘2：1011
抑或结果：1110

如果磁盘1突然挂了
目前知道磁盘2的数据为	1011
异或值为	1110
反推，磁盘1数据是	0101

```

- raid5
	* 更强大的raid3
	* 校验码均匀的放在每一块硬盘上，即使坏了一块硬盘，也能反推出原本数据

- raid10

```bash
raid10 是raid1 加上raid0 兼具两者优点(至少需要4块硬盘)

通过raid1计数，实现了磁盘两两备份，数据安全性较高
针对2个raid1的部署，又部署了raid0，提高了磁盘的读写效率
只要不是同一个硬盘组全部损坏，即使坏掉了一个硬盘也没关系
```



















































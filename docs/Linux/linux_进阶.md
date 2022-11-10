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

- 数据冗余性能从好到坏
	* raid1 raid10 raid5 raid0
- 数据读写性能从好到坏
	* raid0 raid10 raid5 raid1

## 部署raid10

- 搭建raid10，准备4块硬盘(虚拟机可添加4个虚拟硬盘)

```bash
$ ls /dev/sd
/dev/sda /dev/sda1 /dev/sda2 /dev/sdb /dev/sdc /dev/sdd /dev/sde
#其中sdb,c,d,e四个就是虚拟硬盘
```

- 使用mdadm，用于建设，管理和监控raid的命令

```bash
$ mdadm -Cv /dev/md0 -a yes -n 4 -l 10 /dev/sdb /dev/sdc /dev/sdd /dev/sde
-C	表示创建raid阵列
-v	显示下创建过程
/dev/md0	表示 raid阵列名
-a yes	自动创建阵列设备文件
-n 4	表示用4块硬盘创建阵列
-l 10	表示指定raid的级别
	最后跟上4块硬盘的名字
```

- 将磁盘阵列，进行文件系统格式化(将/dev/md0格式为xfs文件系统)

```bash
$ mkfs.xfs /dev/md0
...
```

- 针对分区进行文件夹挂载，使用磁盘分区
	* 新建一个文件夹，用于和阵列分区进行挂载

```bash
$ mkdir /testraid
```

- 使用mount命令进行挂载

```bash
mount /dev/md0 /testraid
```

- 查看挂载情况

```bash
$ mount -l | grep md0
...

#还可以使用df，检查挂载空间的使用情况
$ df -hT | grep md0
...

#检查raid10的详细信息
$ mdadm -D /dev/md0
...
```

- 可以 向磁盘阵列中写入数据，检查使用空间
- 也可以umount取消挂载磁盘阵列


### 当raid10故障了一块硬盘怎么办

- 模拟挂掉一块硬盘，从raid10的四块盘中，提出一块硬盘

```bash
$ fdisk -l | grep sd[a-z]
...
```

- 剔除raid10中的一块硬盘

```bash
$ mdadm /dev/md0 -f /dev/sdd
...
```

- 即使挂掉了一块硬盘也不影响整个raid10的使用
	* 需要重启，重新读取raid信息
- 只需要购买新的硬盘，重新加入raid10阵列即可
	* 注意/etc/fstab中是否添加了开机自启

```bash
#模拟新硬盘加入raid10阵列
#首先取消raid10的挂载
$ umount /dev/md0

#重新添加新的硬盘，加入至/dev/md0磁盘阵列中
$ mdadm /dev/md0 -a /dev/sdd
...
```

- 此时可以检查磁盘阵列的信息，等待一个修复的过程

```bash
$ mdadm -D /dev/md0
...
```

- 等待修复完毕，且激活的设备数量为4，raid10修复完毕


### raid10的重启

- 创建raid的配置文件

```bash
$ echo DEVICE /dev/sd[b-e] > /etc/mdadm.conf

$ cat /etc/mdadm.conf
...
```

- 扫描磁盘阵列信息，追加到这个文件中

```bash
$ mdadm -Ds >> /etc/mdadm.conf

$ cat /etc/mdadm.conf
```

- 取消raid10的挂载

```bash
umount /testraid/
```

- 此时可以停止raid10

```bash 
$ mdadm -S /dev/md0
mdadm: stopped /dev/md0
```

- 检查磁盘阵列组的信息

```bash
mdadm -D /dev/md0 
#此时应该看不到设备文件，即是正常状态
```

- 在存在配置文件的情况下，可以正常启动raid10了

```bash
$ mdadm -A /dev/md0
...

#查看raid10的信息
$ mdadm -D /dev/md0
...
```


### raid10的删除

 - 卸载挂载中的设备
	* ```umount /dev/md0```

- 停止raid服务
	* ```mdadm -S /dev/md0```

- 卸载raid10中所有的磁盘信息

```bash
$ mdadm --misc --zero-superblock /dev/sdb
$ mdadm --misc --zero-superblock /dev/sdc
$ mdadm --misc --zero-superblock /dev/sdd
$ mdadm --misc --zero-superblock /dev/sde
```

- 删除raid的配置文件

```bash
$ rm /etc/mdadm.conf
```

- 最后清除开机自动挂载的配置文件
	* 清除/etc/fstab中自动挂载的配置


### raid与备份盘

- 继续用上述4块硬盘，三块做raid阵列，一个做备份盘
- 3块硬盘可以做raid5阵列

```bash
$ mdadm -Cv /dev/md0 -n 3 -l 5 -x 1 /dev/sdb /dev/sdc /dev/sdd /dev/sde
...

参数解释
-n	执行3块硬盘
-l	指定raid的级别
-x 1	指定一个备份盘
/dev/sd[b-3] 指定使用的4块硬盘
```

- 检查raid阵列组的信息与状态

```bash
$ mdadm -D /dev/md0
```


- 对阵列组进行格式化文件系统

```bash
$ mkfs.xfs -f /dev/md0 
...
```

- 开始挂载，使用raid5

```bash
$ mount /dev/md0 /test/raid
```

- 检查挂载情况以及数据写入情况

```bash
$ mount -l | grep md0
...

$ df -hT | grep md0
...
```


- 此时可以写入数据，检查raid能否正常使用

```bash
$ df -hT | grep md0
,,,
```

- 从raid中删除一块硬盘，检查阵列，备份盘是否加入了阵列

```bash
$ mdadm /dev/md0 -f  /dev/sdb
...
```

- 检查备份盘是否自动加入

```bash
$ mdadm -D /dev/md0
...
```


## Lvm逻辑卷管理

- raid磁盘阵列技术可以提高硬盘读写效率，以及数据安全
	* 缺点有3
	* 当配置好了raid，容量大小是限定了，若将来需要扩容，不好处理
	* 如果某一个分区满了，默认磁盘管理无法直接扩容，只能重新分区，重新分配大小
	* 若要合并分区，需要重新格式化磁盘分区，还要进行数据备份
- Lvm(Logical Volume Manager)逻辑卷管理技术
- lvm是将一个或多个硬盘在逻辑上进行合并，相当于一个大硬盘去使用
- 当硬盘空间不够，可以直接去其他硬盘中拿来容量直接使用，一个动态的磁盘容量管理技术

- lvm的使用方式
-  基于分区形式创建lvm
	* 硬盘的多个分区，由lvm统一管理为卷组，可以弹性调整卷组大小
	* 文件系统时创建在逻辑卷上，逻辑卷可以根据需求改变大小(总容量控制在卷组中)	
- 基于硬盘创建lvm
	* 多块硬盘做成逻辑卷，将整个逻辑卷统一管理，对分区进行动态扩容

### lvm常见名词

- PP(Physical Parttion) 物理分区，lvm直接创建在物理分区之上
- PV(Physical Volume) 物理卷，处于lvm最底层，一般一个pv对应一个PP
- PE(Physical Extends) 物理区域，PV中可以用于分区的最小存储单位，同一个VG所有的PV中的PE大小相同，例如1M，2M
- VG(Volume Group) 卷组，卷组创建在PV之上，可以划分为多个PV
- LE(Logical Extends) 逻辑扩展单元，LE是组成LV的基本单元，一个LE对应了一个PE
- LV(Logical Volume) 逻辑卷，创建在VG之上，是一个可以动态扩容的分区概念

```bash
lvm名词图解
	#文件系统 文件系统 文件系统

		LV	LV	LV


	   LELELE  LELELE  LELELE

#逻辑卷组上创建LV逻辑卷 ↑
#通过VG逻辑卷组管理 ↓
PE物理卷	PEPEPE	PEPEPE

PV物理卷	pv pv

物理分区	PP	PP	PP
```


- LVM原理
- LVM动态扩容，是通过互相交换PE的过程，达到能够弹性扩容分区大小
- 想要减少空间容量，就是提出PE的大小
- 想要扩大容量，就是把其他PE添加到自己的LV中
- PE默认大小一般都是4M，LVM最多可以创建出65534个PE，因此LVM最大的VG卷组单位是256G
- PE是LVM最小的存储单位，类似于操作系统的block(4k)
- LV逻辑卷的概念(理解为普通的分区概念，/dev/sda /dev/sdb...)



- Lvm优点
	* LVM的文件系统可以跨越多个磁盘，分区大小不受磁盘容量限制
	* 可以在系统运行中，直接动态扩容文件系统大小
	* 可以直接增加新的硬盘，到LVM的VG卷组中

- lvm的创建流程
	* 物理分区阶段，针对物理磁盘或分区，进行fdisk格式化，修改系统 的id，默认是83，改为8e类型，是lvm类型
	* PV阶段，通过Pvcreate，Pvdisplay将Linux分区改为物理卷PV
	* 创建VG阶段，通过Vgcreate，Vgdisplay将创建好的物理卷PV改为物理卷组VG
	* 创建LV，通过Lvcreate，将卷组，分为若干个逻辑卷

- 上述流程转为命令，如下

```bash
fdisk 修改磁盘的系统id
pvcreate 创建PV，显示PV信息，pvdisplay 也可以直接输入pvs查看简单信息
创建VG卷组，vgcreate vgs显示卷组信息
创建lv逻辑卷 lvcreate lvs显示逻辑卷信息
开始格式化文件系统，使用lv分区
```

- lvm的管理常见命令

```bash
#PV物理卷
pvcreate 创建物理卷
pvscan 扫描物理卷信息
pvdisplay 显示各个物理卷详细参数
pvremove 删除物理卷

#VG卷组
vgcreate
vgscan
vgdisplay
vgreduce 缩小卷组，把物理卷从卷组中移除
vgextend 扩大卷组，把某个新的物理卷，加入到卷组中
vgremove 删除整个卷组


#LV逻辑卷
lvcreate
lvscan
lvs
lvdisplay
lvextend 扩容
lvreduce 缩小
lvremove 移除逻辑卷
```

- 实际创建lvm
- 挑选/dev/sdb /dev/sdc两块硬盘，创建物理卷，然后添加至卷组

- 创建PV

```bash
$ pvcreate /dev/sdb /dev/sdc
...
```

- 创建卷组

```bash
$ vgcreate testvg1
...
```

- 分别查看PV和VG的信息

```bash
$ pvs	# pvdisplay	pvscan
	
$ vgs	# vgdisplay	vgscan
```

- 尝试扩容，缩小VG卷组

```bash
#扩容第一步，准备一个新硬盘，然后创建物理卷

$ pvcreate /dev/sdd

#第二步，把新创建的sdd物理卷，加入，扩容到卷组testvg1中
$ vgextend testvg1 /dev/sdd
...
```

- 显示一下卷组的信息(容量等)
	* ```vgdisplay```

- 还可以缩小卷组的大小，剔除/dev/sdd

```bash
$ vgreduce testvg1 /dev/sdd
...
```

- 删除/dev/sdd的物理卷

```bash
$ pvremove /dev/sdd
...
```

- 使用此时的卷组，创建逻辑卷，进行使用/dev/sdb /dev/sdc

```bash
$ lvcreate -n lv1 -L +500M testvg1
...
```

- 检查LV的信息
	* ```lvdisplay```

- 对刚创建的lv1逻辑卷进行格式化文件系统

```bash
$ mkfs.xfs /dev/testvg1/lv1
```

- 向lv1逻辑卷中，进行挂载，以及数据写入(就可以当作一个普通分区来使用)

```bash
$ mkdir /test_lv1

$ mount /dev/testvg1/lv1 /test_lv1


#将挂载的信息，写入开机自动挂载文件中，以后不需要每次都mount
$ tail -1 /etc/fstab
/dev/testvg1/lv1 /test_lv1	xfs	defaults 0 0


#通过命令，直接读取/etc/fstab 自动挂载所有设备
$ mount -a 	#读取/etc/fstab中素有挂载的命令

$ mount -l | grep lv1
...
```

- 向磁盘写入数据，查看空间容量

```bash
$ ls /test_lv1
...

$ df -hT	#查看文件系统空间占用
```

- 针对lv逻辑卷的扩容操作，只要卷组中的容量够用，就可以对lv逻辑卷扩容

```bash
# 先卸载lv的设备
$ umount /test_lv1/

#扩容逻辑卷
$ lvextend -L +10G /dev/testvg1/lv1
...

#挂载逻辑卷并开始使用
$ mount /dev/testvg1/lv1	/test_lv1/
```

- 还要调整xfs文件系统的大小，否则读取不到容量

```bash
$ xfs_growfs /dev/testvg1/lv1	#调整xfs文件系统

$ df -hT	#查看lv1是否正确调整了空间
```

- 当不想使用lvm时，需要删除逻辑卷

```bash
#卸载lv设备
$ umount /test_lv1/

#删除逻辑卷
$ lvremove /dev/testvg1/lv1
...

#删除卷组
$ vgremove testvg1
...

#删除物理卷设备
$ pvremove /dev/sdb /dev/sdc
...

#检查所有的lvm相关信息
pvs
vgs
lvs
#上述3条命令返回中均没有相关信息，表示lvm彻底被删除了
```


## 进程

- Linux下存在process和thread两个操作系统的基本概念
	* process 进程
	* thread 线程
- CPU一次只能处理一个任务
- 进程就是Linux上的一个任务资源单位
- 一个进程中可以有多个线程进行工作
- 进程具有存储空间，在进程的存储空间内，线程之间共享这个资源
	* 某一块内存数据可以被多个线程同时使用
	* 某一块内存也可以只给一个线程使用，其他线程要用必须等待当前线程处理完数据才可以

- 线程在使用内存数据时，其他线程可能对此数据进行抢夺，由此出现了锁
	* 线程针对内存数据，加一把锁，此时，其他线程无法访问
	* 以上就是操作系统中，进程中的互斥锁(mutex)，防止线程抢夺内存数据


### Linux中进程管理命令

- ps命令，报告当前系统的进程状态
- ps命令主要用于查询进程信息，一般和kill命令搭配，管理进程

```bash
$ ps
  PID TTY          TIME CMD
    9 pts/0    00:00:00 bash
   23 pts/0    00:00:00 ps
#PID 进程对应的id号码
#CMD 正在执行的系统命令时什么
#TTY 进程所属的控制台号码
#TIME 进程所使用的CPU的总时间
```

- 可以通过grep过滤出某一个进程的信息

```bash
$ ps | grep bash
    9 pts/0    00:00:00 bash

$ kill -9 pid号码	#强制干掉进程
```

- ps的组合命令

```bash
$ ps -ef
UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 20:58 ?        00:00:00 /init
root         4     1  0 20:58 ?        00:00:00 plan9 --control-socket 5 --log-level 4 --server-fd 6 --log-truncate
root         7     1  0 20:58 ?        00:00:00 /init
root         8     7  0 20:58 ?        00:00:00 /init
qinghuo      9     8  0 20:58 pts/0    00:00:00 -bash
qinghuo     27     9  0 21:03 pts/0    00:00:00 ps -ef

#-e 列出系统所有运行的进程
#-f 显示ID PID PPID C STIME TTY TIME CMD等信息

UID	这个进程属于哪个用户执行的命令
PID	进程的标识号码，用于启停进程
PPID	进程的父进程标识号
C	cpu使用的资源百分比
STIME	进程开始执行的时间
TTY	该进程在哪个终端上执行的
TIME	该进程使用的cpu总时长
CMD	用户执行某条命令，产生的进程信息
```

- 过滤出系统指定过的进程信息

```bash
$ ps -ef | grep vim
qinghuo     49    31  0 21:10 pts/1    00:00:00 vim testps
qinghuo     67    52  0 21:10 pts/0    00:00:00 grep --color=auto vim
```

- ps命令的参数，分为两种系统形式

```bash
#第一种，不带减号的参数
$ ps ef
  PID TTY      STAT   TIME COMMAND
   52 pts/0    Ss     0:00 -bash HOSTTYPE=x86_64 LANG=C.UTF-8 PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/wsl/li
   76 pts/0    R+     0:00  \_ ps ef SHELL=/bin/bash WSL2_GUI_APPS_ENABLED=1 WSL_DISTRO_NAME=Ubuntu WT_SESSION=4ccea68d-2583-42ad-a87f-115e7fee599e NAME=yoga14s PWD=/home/
,,,

e	列出进程信息时，添加每个进程所在的环境变量
f	以ASCII码显示进程间的关系

#第二种 带减号的参数
ps -e -f	#-e的作用时显示出所有进程的信息，-f显示出UID，PPID，C，STIME等信息
$ ps -e -f
UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 20:58 ?        00:00:00 /init
root         4     1  0 20:58 ?        00:00:00 plan9 --control-socket 5 --log-level 4 --server-fd 6 --log-truncate
root        29     1  0 21:04 ?        00:00:00 /init
...
```

- ps查看进程的组合命令

```bash
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.0   2268  1600 ?        Sl   20:58   0:00 /init
root         4  0.0  0.0   2268     4 ?        Sl   20:58   0:00 plan9 --control-socket 5 --log-level 4 --server-fd 6 --
root        29  0.0  0.0   2276   104 ?        Ss   21:04   0:00 /init
...

#参数解释
a 显示当前终端下所有进程，包括其他用户的进程信息
u 以用户为主的格式显示进程情况
x 显示所有进程


#输出解释
USER	该进程属于哪个用户
PID	进程ID号
%CPU	显示CPU的百分比使用情况
%MEM	显示内存的百分比使用情况
VSZ	该进程使用的swap内存单位
RSS	进程所占用的内存量
TTY	进程所在的终端信息
STAT	进程此时的状态
	S 终端睡眠中，可以被唤醒
	s 这个进程含有紫禁城，会显示有s
	R 这个进程运行中
	D 这个进程不可中断睡眠
	T 该进程已停止
	Z 该进程是僵尸进程，父进程异常崩溃
	+ 前台进程
	N 低优先级进程
	< 高优先级进程
	L 该进程已被锁定
TIME	该进程运行的时间
CMD	进程执行的命令是什么


#ps查看进程的两大命令
ps aux | grep nginx
ps -ef | grep mysql
```

- 显示指定用户的进程信息

```bash
ps -u	#指定查看某个用户的进程
ps -u root
ps -u testuser	#显示testuser用户的进程信息
```

- 显示进程树的信息，用UNIX风格的命令(携带减号的参数)
	* ```ps -eH```显示父进程，子进程的目录结构信息

- 自定义进程查看的格式

```bash
$ ps -eo pid,args,psr,stime
  PID COMMAND                     PSR STIME
    1 /init                        14 20:58
    4 plan9 --control-socket 5 --   6 20:58
   29 /init                         2 21:04
   30 /init                         2 21:04
   31 -bash                         4 21:04
...
```

- 查看进程树

```bash
#pstree能清晰的表达程序之间的层及相互关系
$ pstree
init─┬─init───{init}
     ├─init───init───bash───vim
     ├─init───init───bash───pstree
     └─{init}
```

- pgrep，通过程序名去查询相关进程，一般判断进程是否存活

```bash
$ pgrep vim
132

$ pgrep bash
86


#-l输出进程id号，进程名
$ pgrep -l vim
161 vim
```

- kill,发送相关信号，给进程，达到不同的停止效果

```bash
$ kill -l	#列出所有信号
 1) SIGHUP       2) SIGINT       3) SIGQUIT      4) SIGILL       5) SIGTRAP
 6) SIGABRT      7) SIGBUS       8) SIGFPE       9) SIGKILL     10) SIGUSR1
11) SIGSEGV     12) SIGUSR2     13) SIGPIPE     14) SIGALRM     15) SIGTERM
16) SIGSTKFLT   17) SIGCHLD     18) SIGCONT     19) SIGSTOP     20) SIGTSTP
21) SIGTTIN     22) SIGTTOU     23) SIGURG      24) SIGXCPU     25) SIGXFSZ
26) SIGVTALRM   27) SIGPROF     28) SIGWINCH    29) SIGIO       30) SIGPWR
31) SIGSYS      34) SIGRTMIN    35) SIGRTMIN+1  36) SIGRTMIN+2  37) SIGRTMIN+3
38) SIGRTMIN+4  39) SIGRTMIN+5  40) SIGRTMIN+6  41) SIGRTMIN+7  42) SIGRTMIN+8
43) SIGRTMIN+9  44) SIGRTMIN+10 45) SIGRTMIN+11 46) SIGRTMIN+12 47) SIGRTMIN+13
48) SIGRTMIN+14 49) SIGRTMIN+15 50) SIGRTMAX-14 51) SIGRTMAX-13 52) SIGRTMAX-12
53) SIGRTMAX-11 54) SIGRTMAX-10 55) SIGRTMAX-9  56) SIGRTMAX-8  57) SIGRTMAX-7
58) SIGRTMAX-6  59) SIGRTMAX-5  60) SIGRTMAX-4  61) SIGRTMAX-3  62) SIGRTMAX-2
63) SIGRTMAX-1  64) SIGRTMAX

#常用信号如下
1) SIGHUP	挂起进程，(如终端突然掉线，用户突然退出)
2) SIGINT	中断信号，一般常用ctrl + c 发送
3) SIGQUIT	退出信号，一般用ctrl + \发送
9) SIGKILL	强制中断信号，一般用于立即杀死某些进程
15) SIGTREM	kill默认使用的就是15信号，终止进程
20) SIGTSTP	暂停进程，通常是ctel + z发出暂停信号


#终止进程
kill pid	#发送15信号，终止进程
kill -9 pid	#立即停止进程，危险命令，可以干掉所有进程
```

- 特殊kill信号0
	* kill的信号0常用在shell脚本中
	* ```kill -0 $pid``` #标识不发送任何信号给pid，但会检查pid，若结果为0，表示进程存在，若结果为1，进程不存在
	* ```kill -0 pid``` #进程id存在的话，不做任何事，可以检查pid是否存活
	* ```echo $?``` shell的特殊变量，取出上一次命令的执行结果，为0表示正确

- killall
	* kill只能干掉一个进程，killall可以通过名字干掉所有进程
	* killall vim	#干掉所有vim的进程

- pkill
	* pkill可以通过进程名杀死多个进程，killall杀进程可能一次杀不死(进程可能含有子进程，killall要杀死多次)
	* pkill可以直接杀死父进程和子进程
	* ```pkill nginx``` 杀死所有nginx进程

- 通过终端名干掉终端上的所有进程

```bash
$ pkill -t pts/2

#-t是指定某个终端
#pts/2 指2号终端
```
	

### Linux资源管理器

- top命令实时监控系统的处理器状态，及其他硬件负载信息，动态的进程信息等
- 还可以按照排名，先后的显示，某个进程cpu，内存的使用情况

```bash
#top用法
#进入top的界面后，按下z键可以开关top界面的颜色
$ top
top - 22:18:02 up  1:12,  0 users,  load average: 0.00, 0.00, 0.00
Tasks:  11 total,   1 running,   9 sleeping,   1 stopped,   0 zombie
%Cpu(s):  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
MiB Mem :   7622.3 total,   7144.8 free,    322.0 used,    155.5 buff/cache
MiB Swap:   2048.0 total,   2048.0 free,      0.0 used.   7093.9 avail Mem

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
    1 root      20   0    2268   1600   1500 S   0.0   0.0   0:00.01 init
    4 root      20   0    2268      4      0 S   0.0   0.0   0:00.00 init
   84 root      20   0    2276    104      0 S   0.0   0.0   0:00.00 init
   85 root      20   0    2292    108      0 S   0.0   0.0   0:00.02 init
   86 qinghuo   20   0   10172   5184   3380 S   0.0   0.1   0:00.08 bash
  137 root      20   0    2276    104      0 S   0.0   0.0   0:00.00 init
  138 root      20   0    2292    108      0 S   0.0   0.0   0:00.00 init
  139 qinghuo   20   0   10172   5408   3544 S   0.0   0.1   0:00.02 bash
  161 qinghuo   20   0   23816   9788   6252 S   0.0   0.1   0:00.00 vim
  163 qinghuo   20   0    8960   2740   2544 T   0.0   0.0   0:00.00 ping
...


#top界面第一板块内容描述(上半部分)
top - 22:18:20 up	#当前时间
1:12	系统运行了多久
0 users	当前机器几个用户在使用
load average: 0.00, 0.00, 0.00	显示系统的平均负载情况，分别是1分钟，5分钟，15分钟显示的平均值(值越小，系统负载越低)

Tasks:  11 total,   1 running,   9 sleeping,   1 stopped,   0 zombie	总共的进程任务情况

%Cpu(s):  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st	cpu的使用百分比
us	用户占用的cpu百分比情况
sy	系统内核空间占用的cpu百分比
ni	用户进程空间占用的cpu百分比
id	空间的cpu百分比情况
wa	等待输入输出的cpu百分比情况

MiB Mem :   7622.3 total,   7144.8 free,    322.0 used,    155.5 buff/cache
		物理内存总大小		空闲的内存总量	  已使用的内存		缓存使用量

MiB Swap:   2048.0 total,   2048.0 free,      0.0 used.   7093.9 avail Mem
		交换空间缓存使用情况


#top界面第二板块(下半部分)，动态的进程信息
  PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND

PID	进程id号，可用来启停进程
USER	执行进程的用户
PR	进程的优先级高低
NI	nice值，越高表示优先级越高
VIRT	进程使用的虚拟内存总量，VIRT=swap + RES
RES	进程使用的物理内存大小
SHR	共享内存大小，单位是kb
S	表示进程的状态

%CPU
%MEM	cpu和内存的使用百分比
```

- top使用场景

```bash
进入top后，输入数字1，表示查看Linux的逻辑CPU个数

输入大写的M，内存使用量从大到小排序

top -c #显示进程命令的绝对路径

top -d 秒数	#设置top进程刷新的秒数

top -n 3	#刷新3次后结束(设置top的刷新次数)

top -p pid	#指定查看某一个进程的信息(单独观察该进程)


#指定某一列高亮显示
输入z，打开颜色
输入x，某一列高亮
输入b，某一列颜色加粗
输入<或>,移动高亮区域
```






























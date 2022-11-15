## 用户和用户组
- Linux中的用户名是一个字符串，但是Linux并不是用字符串来识别用户
  * Linux通过UID(User's ID 一串数字)来识别用户
- Linux中用户分为3类：
  * 整个系统的管理员：root UID为0
  * 虚拟用户：bin ftp mail nobody等, CentOS中uid为1-499
  * 普通用户  uid为500或更多
- 在Linux种UID为0，就是root，如果要设置管理员用户，可以改UID为0，建议用sudo
- 系统用户UID为1~999,Linux安装的服务程序都会```创建独有的用户```负责运行
- 普通用户UID从1000开始，由管理员创建
- 用户组GID(Group's ID)
- 用户和用户组之间是多对多的关系
  * 一个用户可以从属多个用户组，
  * 一个用户组可以包含多个用户
- Linux中还有一个```主用户组```或```有效用户组```的概念
  * 在创建文件时，会影响文件的```从属用户组```属性

### 查看用户
- id 
  * ```id 用户名```查看用户 UID 归属的用户组 GID
- su
  * 使用```su```时，建议在后追加```-l```选项
  * ```-l```可以简写为```su - username```

### 操作用户
- 创建用户
  * 只有root才可以创建用户
  * ```# useradd testuser```
  * ```# passwd testuser```
  * ```/etc/skel```下存放新用户需要的基础环境变量文件(隐藏文件)
    - 添加新用户时，此目录下所有文件自动复制到新用户的家目录下
- 修改用户
  * ```usermod(user modify)```,，
  * 能够修改用户名,UID,主用户组，从属用户组，备注，家目录，默认shell等
  * 在用户登录时，无法修改用户
- 删除用户
  * ```userdel username```
  * 用户删除后，其家目录依旧存在
  * 正在登录系统的用户无法删除

- 创建用户组
  * ```groupadd groupname```
  * Linux中没有查看用户组的命令,可以尝试添加一个用户至新建用户组

- 修改用户组
  * ```groupmod groupname```
  * 可以修改用户组名，GID等
  * 不建议修改用户组的GID

- 删除用户组
  * ```groupdel groupname```
  * 删除用户组的前提时此用户组下无用户


### 用户配置文件
- 用户配置文件位置
  * /etc/passwd
    * 所有用户的信息都在```/etc/passwd```,所有人可查看
  * /etc/shadow
    * 用户密码存储在```/etc/shadow```,只有root可查看

- 用户组配置文件位置
  * /etc/group
  * /etc/gshadow



#### sudo
- sudo可以获取root权限
  * 在```/etc/sudoers```中，

### 硬盘
- 在```/dev/```下,```/dev/xxy```
  * 其中xx若为```sd```，标明硬盘类型,可能是```SCSI SATA USB```
    - 或xx为```hd```,表示采用IDE接口的硬盘(很少)
  * y表示硬盘使用此类接口的第几个硬盘,y的取值一般在a-z之间
    - ```/dev/hdd```表示第4个使用IDE接口的硬盘
    - ```/dev/sdb```表示第2个使用SCSI SATA 或USB接口的硬盘

### 分区
- ```/dev/xxyn```，其中xxy参照硬盘，n表示分区
  * 主分区或扩展分区一般用1-4表示，逻辑分区用5及以后表示
    - ```/dev/hda3```第一个IDE硬盘上的第3个主分区或扩展分区
    - ```/dev/sdb6```第2个SCSI硬盘上的第2个逻辑分区
- ```fdisk -l 硬盘名/分区名```

- 格式化硬盘
  * 分区工具有fdisk,cfdisk等
  * 将硬盘分区后，需要格式化硬盘(指定文件系统类型)
    - 格式化硬盘的工具有mkfs

## 查看网络
- ```ifconfig```查看网络接口

## 进程(Process)
- 一个运行中的程序属于进程
  * 一个运行的程序中可能有多个进程
- ```ps```用来查看进程(Process Status)
- ```top```动态查看进程

- 结束进程kill
  * ···kill -l```查看所有信号
  * kill 后跟进程的PID即可结束进程
  * ```kill -9 pid```用来强行终止进程,可能带来副作用

- ```守护进程(Daemon)```
  * 独立于用户终端并周期执行某种任务或等待处理发生的事件
  * 不需要输入即可运行，并为系统或用户提供某种服务
  * 守护进程又名后台程序/服务

## service (服务)管理

- service(服务)本质就是进程，但是运行在后台，通常都会监听某个端口，等待其他程序的请求
	* 比如(mysql，sshd，防火墙等)，因此又名守护进程

```bash
service  服务名  [start | stop | restart | reload | status]

#在CentOS7之后，很多服务不再使用service，二十systemctl

service管理的服务在/etc/init.d中查看

#使用setup -> 系统服务，可以看到全部(wsl2和ESC都无此命令)
```

- 由于chkcofnig命令被Ubuntu移除，所以不计入

#### systemctl

```bash
#systemctl基本语法
systemctl [start | stop | restart | status] 服务名
systemctl指令管理的服务在/usr/lib/systemd/system中查看
```

- systemctl设置服务的自启动状态

```bash
systemctl list-unit-files [| grep 服务名]	#查看服务开机启动状态，grep用于过滤
systemctl enable 服务名	#设置服务开机启动
systemctl disable	服务名	#关闭服务开机启动
systemctl is-enabled 服务名	#检查某个服务是否开机自启

#对于system和systemd，其区别在于最后的d，加d(daemon)是守护进程的意思
```


- 应用防火墙

```bash
#查看当前防火墙的状况，关闭和重启防火墙(wsl2和ESC中未找到此服务)
systemctl status firewalld	#查看防火墙状态
systemctl stop firewalld	#关闭防火墙
systemctl start firewalld	#开启防火墙

#关闭或启动防火墙后，立即生效(用telnet测试某个端口即可)
这种方式只能临时生效，当重启系统后，要是回归以前对服务的设置
若希望设置某个服务自启动或关闭永久生效，使用 systemctl [enable | disable] 服务名

```

- 打开或关闭端口

```bash
#若打开防火墙，则外部请求数据包无法和服务器监听端口通讯，此时需要打开指定端口，如80，22，8080等

firewall-cmd --permanent --add-port=端口号/协议	#打开端口(注意，端口号和协议中的/是必须写的)，协议可以通过netstat -anp命令查看
firewall-cmd --permanent --remove-port=端口号/协议	#关闭端口
firewall-cmd --reload	#重新载入，才能生效
firewall-cmd --query-port=端口/协议	#查询端口是否开放
```

- 打开关闭端口案例(Ubuntu上未找到firewall,下面命令均为课件内容)

```bash
#启动防火墙，测试111端口能否telnet
#若不行，则执行如下命令

#开放111端口
firewall-cmd --permanent --add-port=111/tcp	#需要firewall-cmd --reload

#再次关闭111端口
firewall-cmd --permanent --remove-port=111/tcp	#需要firewall-cmd --reload
```






































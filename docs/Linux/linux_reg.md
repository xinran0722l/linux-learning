## Linux三剑客
- Linux仅三剑客(sed,awk,grep)支持正则
  * grep:文本过滤工具，(pattern)工具
  * sed:stream editor,流编辑器，文本编辑器
  * awk:Linux的文本报告生成器(格式化文本),Linux上是gawk

## 正则分类
- 基本正则表达式(BRE,Basic Regular Expression)
  * ```BRE对应元字符有 ^$.[]*```
- 扩展正则表达式(ERE,Extended Regular Expression)
  * ```ERE再BRE基础上，增加 (){}?+| 等字符```

### 基本正则BRE
| 符号 | 描述 | 
| :---: | :---: |
| ^ | 用于模式的最左侧，如"^Linux",匹配以Linux单词开头的行 | 
| $ | 用于模式的最右侧，如"Linux$",匹配以Linux单词结尾的行 |
| ^$ | 组合符，表示空行 |
| . | 匹配任意一个且只有一个字符，不能匹配空行 |
| \ | 转义字符，例如```\.```表示小数点 |
| * | 匹配前一个字符(连续出现)0次或1次以上，重复0次代表空，即匹配所有内容 |
| .* | 组合符，匹配所有内容 |
| ^.* | 组合符，匹配任意多个字符开头的内容 |
| .*$ | 组合符，匹配任意多个字符结尾的内容 |
| [abc] | 匹配[]集合内的任意一个字符，a或b或c，可以写[a-c] |
| [^abc] | 取反 |

### 扩展正则ERE

扩展正则必须用```grep -E```才能生效

| 符号 | 描述 | 
| :---: | :---: |
| + | 匹配前一个字符1次或多次 | 
| [:/]+ | 匹配括号内的:或者/字符1次或多次 | 
| ? | 匹配前一个字符0次或1次 | 
| \ | 表示或者，同时过滤多个字符串 | 
| () | 分组过滤，被括起来的内容表示一个整体 | 
| a{n,m} | 匹配前一个字符最少n次，最多m次 | 
| a{n,} | 匹配前一个字符最少n次 | 
| a{n} | 匹配前一个字符正好n次 | 
| a{,m} | 匹配前一个字符最多n次 | 

- grep需要使用参数 -E 支持正则
- egrep不推荐使用，使用grep -E替代
- grep不加参数，得再特殊字符前加\识别为正则

## grep
- 全拼：Global search REgular expression and Print out the line
- 作用：文本搜索工具，根据用户指定的```模式(过滤条件)```对目标文本逐行匹配，打印匹配的行
- 模式：由正则的```元字符```及```文本字符```所编写的过滤条件
- grep里的匹配模式就是要找的东西，可以是普通文字服啊后，也可以是正则

```bash
grep [options] [pattern] file
  -i: ignorecase 忽略字符的大小写
  -o: 仅显示匹配道德字符串本身
  -v: --invert-match: 显示不能被匹配到的行
  -E: 支持使用扩展的正则元字符
  -q: --quiet, --silent:静默模式，不输出任何信息
```

| 参数选项 | 描述 | 
| :---: | :---: |
| -v | 排除匹配结果 | 
| -n | 显示匹配行与行号 |
| -i | 不区分大小写 |
| -c | 只统计匹配的行数 |
| -E | 使用egrep命令 |
| --color=auto | 给grep过滤结果添加颜色 |
| -W | 只匹配过滤的单词 |

## sed
- 注意sed和awk使用单引号，双引号有特殊解释
- sed是Stream Editor(字符流编辑器)的简写，简称六编辑器
- sed是操作，过滤和转换文本内容的工具
- 常用功能包括结合正则对文件curd，其中查询的功能中最常用的是过滤(过滤指定字符串)和取行(取出指定行)
- ```sed [选项] [sed内置命令字符] [输入文件]```


| 参数选项 | 描述 | 
| :---: | :---: |
| -n | 取消sed的默认输出，常与sed内置命令p一起用 | 
| -i | 直接将修改结果写入文件，不用-i，sed修改的是内存数据 |
| -e | 多次编辑，不需要管道符 |
| -r | 支持正则扩展 |

- sed的```内置命令字符```用于对文件进行不同操作(curd)

| sed的内置命令字符| 描述 | 
| :---: | :---: |
| a | Append 对文本追加，再指定行后面添加一行/多行文本 | 
| d | Delete 删除匹配行 |
| i | insert 插入文本，在指定行前添加一行/多行文本 |
| p | Print 打印匹配行的内容，通常p与-n一起用 |
| s/正则/替换内容/g | 匹配正则，然后替换内容(支持正则)，结尾g表示全局匹配 |

- sed匹配范围

| sed匹配范围 | 描述 | 
| :---: | :---: |
| 空地址 | 全文处理 | 
| 单地址 | 指定文件某一行 |
| /pattern/ | 被模式匹配到的每一行 |
| 范围区间 | 10，20 十到二十行，10，+5第10行向下5行 /pattern1/,/pattern2/ |
| 步长 | 1~2,表示1，3，5，7，9行，2~2两个步长，表示2，4，6，8偶数行 |

#### sed案例
- sed_text.txt内容如下
```bash
My name is linus.
I teach Python.
I like play computer game.
My qq is 10001.
My website is http://google.com.
```
```bash
#输出第二行和第三行的内容
$ sed "2,3p" sed_test.txt -n
I teach Python.
I like play computer game.
```
```bash
#输出第二行并向下连续输出3行
$ sed "2,+3p" sed_test.txt -n
I teach Python.
I like play computer game.
My qq is 10001.
My website is http://google.com.
```
```bash
#过滤含有Pytho的行
$ sed "/Python/p" sed_test.txt -n
I teach Python.
```
```bash
#删除含有game的行 (此处若加-n， 则无输出,```game行虽del，但是是在内存中处理，不加-i不会写入硬盘```)
$ sed "/game/d" sed_test.txt
My name is linus.
I teach Python.
My qq is 10001.
My website is http://google.com.
```

- 对sed_test.txt做些更改

```bash
$ cat -n sed_test.txt
     1  My name is linus.
     2  I teach Python.
     3  My qq is 10001.
     4  My website is http://google.com.
     5  My website is http://google.com.
     6  My website is http://google.com.
     7  My website is http://google.com.
     8  My website is http://google.com.
     9  My website is http://google.com.
```

```bash
#从第5行开始删除删除至结尾(若不加-i参数，则依旧是在内存中更改，硬盘中的数据不变 )
$ sed '5,$d' sed_test.txt
My name is linus.
I teach Python.
My qq is 10001.
My website is http://google.com.

#为了演示，从第五行删除至结尾的操作已经-i(写入硬盘)
#将文本中所有的My替换为I(未加-i参数，不写入硬盘)
$ sed "s/My/I/g" sed_test.txt
I name is linus.
I teach Python.
I qq is 10001.
I website is http://google.com.

#为了演示，上面的替换也以-i
#将所有的I替换为My，并且将qq10001替换为12345
h$ sed -e "s/I/My/g" -e "s/10001/12345/g" sed_test.txt
My name is linus.
My teach Python.
My qq is 12345.
My website is http://google.com.

#上述3处操作均已-i，
#在文件第二行追加内容 
$ sed "2a I'm Linux is good" sed_test.txt
     1  My name is linus.
     2  My teach Python.
     3  I'm Linux is good
     4  My qq is 12345.
     5  My website is http://google.com.


#在第4行前面插入一条内容
$ sed "4i I'm fine, Thank you" sed_test.txt
     1  My name is linus.
     2  My teach Python.
     3  I'm Linux is good
     4  I'm fine, Thank you
     5  My qq is 12345.
     6  My website is http://google.com.


#在第3行前插入连续的2行(用\n分割)
$ sed "3i I like girl.\nExcuse me" sed_test.txt
     1  My name is linus.
     2  My teach Python.
     3  I'm Linux is good
     4  I'm fine, Thank you
     5  My qq is 12345.
     6  My website is http://google.com.


#在每一行后面添加一行分隔符(命令中未加数字，表示对每行都进行处理)
$ sed "a ------------" sed_test.txt
     1  My name is linus.
     2  ------------
     3  My teach Python.
     4  ------------
     5  I'm Linux is good
     6  ------------
     7  I'm fine, Thank you
     8  ------------
     9  My qq is 12345.
    10  ------------
    11  My website is http://google.com.
    12  ------------
```
- 通过```ifconfig eth0来获得ip```地址
```bash
$ ifconfig eth0 #输出如下
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.26.68.96  netmask 255.255.240.0  broadcast 172.26.79.255
        inet6 fe80::215:5dff:fec2:4ebc  prefixlen 64  scopeid 0x20<link>
        ether 00:15:5d:c2:4e:bc  txqueuelen 1000  (Ethernet)
        RX packets 35  bytes 6732 (6.7 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 12  bytes 936 (936.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

```bash
#先打印处ip所在的第2行
$ ifconfig eth0 | sed "2p" -n
        inet 172.26.68.96  netmask 255.255.240.0  broadcast 172.26.79.255

#去除ip之前的内容(替换为空)
$ ifconfig eth0 | sed "2p" -n | sed "s/^.*inet//g"
 172.26.68.96  netmask 255.255.240.0  broadcast 172.26.79.255

#去掉ip之后的内容
$ ifconfig eth0 | sed "2p" -n | sed "s/^.*inet//g" | sed "s/net.*$//g"
 172.26.68.96
```

- 上述操作用到3次管道，下面使用```sed -e```参数演示

```bash
#先测试能否正常输出去掉ip前的内容
$ ifconfig eth0 | sed "2s/^.*inet//p" -n
 172.26.68.96  netmask 255.255.240.0  broadcast 172.26.79.255


#上条命令已经去除ip之前的内容
$ ifconfig eth0 | sed -e "2s/^.*inet//"  -e "2s/net.*$//p" -n
 172.26.68.96
```

## awk基础

awk语法
```bash
awk [options] 'pattern[action]' file

awk 参数	'动作条件' 文件


awk options pattern {action} file
	可选	模式		动作
```

- Action是动作，awk擅长文本格式化，且输出格式化后的结果，最常用的动作是print和printf

#### awk内置变量

| 内置变量| 描述 | 
| :---: | :---: |
| $N | 指定分隔符后，当前记录的第n个字段 | 
| $0 | 完整的输入记录 |
| FS | 字段分隔符，默认是空格 |
| OFS | 输出字段分隔符，默认是空白字符 |
| RS | 输入记录分隔符(输入换行符)，指定输入时的换行符 |
| ORS | 输出记录分隔符(输出换行符)，输出时用指定符号代替换行符 |
| NF(Number of Fields) | 分割后，当前行一共有多少字段(即当前行被分割成了几列)，字段数量 |
| NR(Number of Records) | 当前记录数，步数(行号) |
| FNR | FNR:个文件分别计数的行号(处理多个文件时，此参数可以分别显示各文件的行号) |
| FILENAME | 当前文件名 |
| ARGC | 命令行参数的个数 |
| ARGV | 数组，保存的时命令行所给定的参数 |

- ```awk外层必须用单引号，内层双引号```
- 内置变量($1,$2)不加双引号，否则会识别为文本
- awk的内置变量```NR，NF不加$```


```bash
#现有文本awk_test.txt
$ cat awk_test.txt
pyyu1 pyyu2 pyyu3 pyyu4 pyyu5
pyyu6 pyyu7 pyyu8 pyyu9 pyyu10
pyyu11 pyyu12 pyyu13 pyyu14 pyyu15
pyyu16 pyyu17 pyyu18 pyyu19 pyyu20
pyyu21 pyyu22 pyyu23 pyyu24 pyyu25
pyyu26 pyyu27 pyyu28 pyyu29 pyyu30
pyyu31 pyyu32 pyyu33 pyyu34 pyyu35
pyyu36 pyyu37 pyyu38 pyyu39 pyyu40
pyyu41 pyyu42 pyyu43 pyyu44 pyyu45
pyyu46 pyyu47 pyyu48 pyyu49 pyyu50
```

```bash
#输出第一列内容
$ awk '{print $1}' awk_test.txt
pyyu1
pyyu6
pyyu11
pyyu16
pyyu21
pyyu26
pyyu31
pyyu36
pyyu41
pyyu46


#输出所有内容
$ awk '{print $0}' awk_test.txt
pyyu1 pyyu2 pyyu3 pyyu4 pyyu5
pyyu6 pyyu7 pyyu8 pyyu9 pyyu10
pyyu11 pyyu12 pyyu13 pyyu14 pyyu15
pyyu16 pyyu17 pyyu18 pyyu19 pyyu20
pyyu21 pyyu22 pyyu23 pyyu24 pyyu25
pyyu26 pyyu27 pyyu28 pyyu29 pyyu30
pyyu31 pyyu32 pyyu33 pyyu34 pyyu35
pyyu36 pyyu37 pyyu38 pyyu39 pyyu40
pyyu41 pyyu42 pyyu43 pyyu44 pyyu45
pyyu46 pyyu47 pyyu48 pyyu49 pyyu50

#$2同理输出第二列的内容
$ awk '{print $2}' awk_test.txt
pyyu2
pyyu7
pyyu12
pyyu17
pyyu22
pyyu27
pyyu32
pyyu37
pyyu42
pyyu47

```
- awk ‘{print $2}’,没有使用参数和模式，$2表示文本第二列的喜喜
- ```awk默认以空格为分隔符```，且多个空格也识别为一个空格作为分隔符
- awk是按行处理文件，一行处理完毕，处理下一行，根据用户指定的分隔符区工作，没有指定则默认空格
- 指定了分隔符后，awk把每一行切割后的数据对应到内置变量
	* $0代表整行
	* $NF表示当前分割后的最后一列
	* 倒数第二列可以写为$(NF-1)


```bash
#取出多列
$ awk '{print $1,$5,$3}' awk_test.txt
pyyu1 pyyu5 pyyu3
pyyu6 pyyu10 pyyu8
pyyu11 pyyu15 pyyu13
pyyu16 pyyu20 pyyu18
pyyu21 pyyu25 pyyu23
pyyu26 pyyu30 pyyu28
pyyu31 pyyu35 pyyu33
pyyu36 pyyu40 pyyu38
pyyu41 pyyu45 pyyu43
pyyu46 pyyu50 pyyu48


#自定义输出
$ awk '{print "第一列："$1,"第四列："$4}' awk_test.txt
第一列：pyyu1 第四列：pyyu4
第一列：pyyu6 第四列：pyyu9
第一列：pyyu11 第四列：pyyu14
第一列：pyyu16 第四列：pyyu19
第一列：pyyu21 第四列：pyyu24
第一列：pyyu26 第四列：pyyu29
第一列：pyyu31 第四列：pyyu34
第一列：pyyu36 第四列：pyyu39
第一列：pyyu41 第四列：pyyu44
第一列：pyyu46 第四列：pyyu49


$ awk '{print "每一行的内容是："$0}' awk_test.txt
每一行的内容是：pyyu1 pyyu2 pyyu3 pyyu4 pyyu5
每一行的内容是：pyyu6 pyyu7 pyyu8 pyyu9 pyyu10
每一行的内容是：pyyu11 pyyu12 pyyu13 pyyu14 pyyu15
每一行的内容是：pyyu16 pyyu17 pyyu18 pyyu19 pyyu20
每一行的内容是：pyyu21 pyyu22 pyyu23 pyyu24 pyyu25
每一行的内容是：pyyu26 pyyu27 pyyu28 pyyu29 pyyu30
每一行的内容是：pyyu31 pyyu32 pyyu33 pyyu34 pyyu35
每一行的内容是：pyyu36 pyyu37 pyyu38 pyyu39 pyyu40
每一行的内容是：pyyu41 pyyu42 pyyu43 pyyu44 pyyu45
每一行的内容是：pyyu46 pyyu47 pyyu48 pyyu49 pyyu50
```
#### awk参数

| 参数| 描述 | 
| :---: | :---: |
| -F | 指定分隔符 | 
| -v | 定义或修改一个awk内部变量 |
| -f | 从脚本文件中读取awk命令 |

#### awk案例
```bash
awk '模式{动作}' 文件

#要操作的文本如下
$ cat -n awk_test.txt
     1  pyyu1 pyyu2 pyyu3 pyyu4 pyyu5
     2  pyyu6 pyyu7 pyyu8 pyyu9 pyyu10
     3  pyyu11 pyyu12 pyyu13 pyyu14 pyyu15
     4  pyyu16 pyyu17 pyyu18 pyyu19 pyyu20
     5  pyyu21 pyyu22 pyyu23 pyyu24 pyyu25
     6  pyyu26 pyyu27 pyyu28 pyyu29 pyyu30
     7  pyyu31 pyyu32 pyyu33 pyyu34 pyyu35
     8  pyyu36 pyyu37 pyyu38 pyyu39 pyyu40
     9  pyyu41 pyyu42 pyyu43 pyyu44 pyyu45
    10  pyyu46 pyyu47 pyyu48 pyyu49 pyyu50

$ awk 'NR==5{print $0}' awk_test.txt
pyyu21 pyyu22 pyyu23 pyyu24 pyyu25


#输出2行
$ awk 'NR==5,NR==6{print $0}' awk_test.txt
pyyu21 pyyu22 pyyu23 pyyu24 pyyu25
pyyu26 pyyu27 pyyu28 pyyu29 pyyu30

#输出连续的多行
$ awk 'NR==2,NR==6{print $0}' awk_test.txt
pyyu6 pyyu7 pyyu8 pyyu9 pyyu10
pyyu11 pyyu12 pyyu13 pyyu14 pyyu15
pyyu16 pyyu17 pyyu18 pyyu19 pyyu20
pyyu21 pyyu22 pyyu23 pyyu24 pyyu25
pyyu26 pyyu27 pyyu28 pyyu29 pyyu30

```

```bash

#给awk的输出添加行号
$ awk '{print NR,$0}' awk_test.txt
1 pyyu1 pyyu2 pyyu3 pyyu4 pyyu5
2 pyyu6 pyyu7 pyyu8 pyyu9 pyyu10
3 pyyu11 pyyu12 pyyu13 pyyu14 pyyu15
4 pyyu16 pyyu17 pyyu18 pyyu19 pyyu20
5 pyyu21 pyyu22 pyyu23 pyyu24 pyyu25
6 pyyu26 pyyu27 pyyu28 pyyu29 pyyu30
7 pyyu31 pyyu32 pyyu33 pyyu34 pyyu35
8 pyyu36 pyyu37 pyyu38 pyyu39 pyyu40
9 pyyu41 pyyu42 pyyu43 pyyu44 pyyu45
10 pyyu46 pyyu47 pyyu48 pyyu49 pyyu50


#输出第3行到第6行的内容，并添加行号
h$ awk 'NR==3,NR==6{print NR,$0}' awk_test.txt
3 pyyu11 pyyu12 pyyu13 pyyu14 pyyu15
4 pyyu16 pyyu17 pyyu18 pyyu19 pyyu20
5 pyyu21 pyyu22 pyyu23 pyyu24 pyyu25
6 pyyu26 pyyu27 pyyu28 pyyu29 pyyu30

#取出第一列，倒数第3列和最后一列的值并显示行号
$ awk '{print NR, $1,$(NF-2),$NF}' awk_test.txt
1 pyyu1 pyyu3 pyyu5
2 pyyu6 pyyu8 pyyu10
3 pyyu11 pyyu13 pyyu15
4 pyyu16 pyyu18 pyyu20
5 pyyu21 pyyu23 pyyu25
6 pyyu26 pyyu28 pyyu30
7 pyyu31 pyyu33 pyyu35
8 pyyu36 pyyu38 pyyu40
9 pyyu41 pyyu43 pyyu45
10 pyyu46 pyyu48 pyyu50


#通过awk取出ifconfig eth0中的ip地址
#首先取出ip所在的第二行
$ ifconfig eth0 | awk 'NR==2{print $0}'
        inet 172.26.68.96  netmask 255.255.240.0  broadcast 172.26.79.255

#再根据字段直接取出ip地址
$ ifconfig eth0 | awk 'NR==2{print $2}'
172.26.68.96


```

#### awk分隔符
- awk的分隔符有两种
	* 输入分隔符：awk默认是空格，空白字符(Field Separator)，变量名是FS
	* 输出分隔符：Output Field Separator,简称OFS

- awk逐行处理文本时，以FS为准，把文本切分为多个片段，默认是空格
- 当处理特殊文件，没有空格时，可以自由指定分隔符


```bash
#现有文本awk_pwd.txt
$ cat -n awk_pwd.txt
     1  root:x:0:0:root:/root:/bin/bash
     2  daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
     3  bin:x:2:2:bin:/bin:/usr/sbin/nologin
     4  sys:x:3:3:sys:/dev:/usr/sbin/nologin
     5  sync:x:4:65534:sync:/bin:/bin/sync
     6  games:x:5:60:games:/usr/games:/usr/sbin/nologin
     7  man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
     8  lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
     9  mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
    10  news:x:9:9:news:/var/spool/news:/usr/sbin/nologin


#以冒号分割，并输出第一列
$ awk -F ":" '{print $1}' awk_pwd.txt
root
daemon
bin
sys
sync
games
man
lp
mail
news


#取出第一列和最后一列
$ awk -F ":" '{print $1,$NF}' awk_pwd.txt
root /bin/bash
daemon /usr/sbin/nologin
bin /usr/sbin/nologin
sys /usr/sbin/nologin
sync /bin/sync
games /usr/sbin/nologin
man /usr/sbin/nologin
lp /usr/sbin/nologin
mail /usr/sbin/nologin
news /usr/sbin/nologin


#以变量形式取出第一列和最后一列
$ awk -v FS=":" '{print $1,$NF}' awk_pwd.txt
root /bin/bash
daemon /usr/sbin/nologin
bin /usr/sbin/nologin
sys /usr/sbin/nologin
sync /bin/sync
games /usr/sbin/nologin
man /usr/sbin/nologin
lp /usr/sbin/nologin
mail /usr/sbin/nologin
news /usr/sbin/nologin


#输出awk_pwd.txt中第一列和最后一列的信息，中间使用4个-来分隔
$ awk -F ":" -v OFS="----" '{print $1,$NF}' awk_pwd.txt
root----/bin/bash
daemon----/usr/sbin/nologin
bin----/usr/sbin/nologin
sys----/usr/sbin/nologin
sync----/bin/sync
games----/usr/sbin/nologin
man----/usr/sbin/nologin
lp----/usr/sbin/nologin
mail----/usr/sbin/nologin
news----/usr/sbin/nologin

#以制表符输出第一列和最后一列
$ awk -F ":" -v OFS="\t" '{print $1,$NF}' awk_pwd.txt
root    /bin/bash
daemon  /usr/sbin/nologin
bin     /usr/sbin/nologin
sys     /usr/sbin/nologin
sync    /bin/sync
games   /usr/sbin/nologin
man     /usr/sbin/nologin
lp      /usr/sbin/nologin
mail    /usr/sbin/nologin
news    /usr/sbin/nologin


#下面命令中的NR是显示行号，NF是显示当前行的字段数，
#第一行root后续内容以冒号分隔，共6处冒号，所以有7处内容(字段)
$ awk -F ":" '{print NR,NF, $1}' awk_pwd.txt
1 7 root
2 7 daemon
3 7 bin
4 7 sys
5 7 sync
6 7 games
7 7 man
8 7 lp
9 7 mail
10 7 news

```

##### RS and ORS
```bash
#现有文本如下
$ cat awk_demo.txt
pyyu1 pyyu2 pyyu3 pyyu4 pyyu5


#正常输出一行
$ awk '{print NR,$0 }' awk_demo.txt
1 pyyu1 pyyu2 pyyu3 pyyu4 pyyu5

#修改RS的值
$ awk -v RS=' ' '{print NR,$0 }' awk_demo.txt
1 pyyu1
2 pyyu2
3 pyyu3
4 pyyu4
5 pyyu5



#修改ORS的值,行尾的\n会被替换为ORS的新值
$ awk -v ORS='%%%' '{print NR,$0 }' awk_demo.txt
1 pyyu1 pyyu2 pyyu3 pyyu4 pyyu5%%%



#对awk_test.txt执行FILENAME
$ awk '{print FILENAME,$0}' awk_test.txt
awk_test.txt pyyu1 pyyu2 pyyu3 pyyu4 pyyu5
awk_test.txt pyyu6 pyyu7 pyyu8 pyyu9 pyyu10
awk_test.txt pyyu11 pyyu12 pyyu13 pyyu14 pyyu15
awk_test.txt pyyu16 pyyu17 pyyu18 pyyu19 pyyu20
awk_test.txt pyyu21 pyyu22 pyyu23 pyyu24 pyyu25
awk_test.txt pyyu26 pyyu27 pyyu28 pyyu29 pyyu30
awk_test.txt pyyu31 pyyu32 pyyu33 pyyu34 pyyu35
awk_test.txt pyyu36 pyyu37 pyyu38 pyyu39 pyyu40
awk_test.txt pyyu41 pyyu42 pyyu43 pyyu44 pyyu45
awk_test.txt pyyu46 pyyu47 pyyu48 pyyu49 pyyu50


#再print之前执行动作
$ awk 'BEGIN{print "我要来了"} {print $0} ' awk_test.txt
我要来了
pyyu1 pyyu2 pyyu3 pyyu4 pyyu5
pyyu6 pyyu7 pyyu8 pyyu9 pyyu10
pyyu11 pyyu12 pyyu13 pyyu14 pyyu15
pyyu16 pyyu17 pyyu18 pyyu19 pyyu20
pyyu21 pyyu22 pyyu23 pyyu24 pyyu25
pyyu26 pyyu27 pyyu28 pyyu29 pyyu30
pyyu31 pyyu32 pyyu33 pyyu34 pyyu35
pyyu36 pyyu37 pyyu38 pyyu39 pyyu40
pyyu41 pyyu42 pyyu43 pyyu44 pyyu45
pyyu46 pyyu47 pyyu48 pyyu49 pyyu50

#接上，打印ARGV数组内的值，ARGV[0]是awk本身
$ awk 'BEGIN{print "我要来了"} {print ARGV[0],$0} ' awk_test.txt
我要来了
awk pyyu1 pyyu2 pyyu3 pyyu4 pyyu5
awk pyyu6 pyyu7 pyyu8 pyyu9 pyyu10
awk pyyu11 pyyu12 pyyu13 pyyu14 pyyu15
awk pyyu16 pyyu17 pyyu18 pyyu19 pyyu20
awk pyyu21 pyyu22 pyyu23 pyyu24 pyyu25
awk pyyu26 pyyu27 pyyu28 pyyu29 pyyu30
awk pyyu31 pyyu32 pyyu33 pyyu34 pyyu35
awk pyyu36 pyyu37 pyyu38 pyyu39 pyyu40
awk pyyu41 pyyu42 pyyu43 pyyu44 pyyu45
awk pyyu46 pyyu47 pyyu48 pyyu49 pyyu50


#ARGV[1]是文件名
$ awk 'BEGIN{print "我要来了"} {print ARGV[1],$0} ' awk_test.txt
我要来了
awk_test.txt pyyu1 pyyu2 pyyu3 pyyu4 pyyu5
awk_test.txt pyyu6 pyyu7 pyyu8 pyyu9 pyyu10
awk_test.txt pyyu11 pyyu12 pyyu13 pyyu14 pyyu15
awk_test.txt pyyu16 pyyu17 pyyu18 pyyu19 pyyu20
awk_test.txt pyyu21 pyyu22 pyyu23 pyyu24 pyyu25
awk_test.txt pyyu26 pyyu27 pyyu28 pyyu29 pyyu30
awk_test.txt pyyu31 pyyu32 pyyu33 pyyu34 pyyu35
awk_test.txt pyyu36 pyyu37 pyyu38 pyyu39 pyyu40
awk_test.txt pyyu41 pyyu42 pyyu43 pyyu44 pyyu45
awk_test.txt pyyu46 pyyu47 pyyu48 pyyu49 pyyu50

#若无print，则只输出BEGIN
$ awk 'BEGIN{print "我要来了"} ' awk_test.txt
我要来了


#输出ARGV内的所有信息(awk_test.txt 10行，awk_demo.txt 1行，两个文件攻击11行)
$ awk 'BEGIN{print "我要来了"} {print ARGV[0],ARGV[1],ARGV[2]} ' awk_test.txt awk_demo.txt
我要来了
awk awk_test.txt awk_demo.txt
awk awk_test.txt awk_demo.txt
awk awk_test.txt awk_demo.txt
awk awk_test.txt awk_demo.txt
awk awk_test.txt awk_demo.txt
awk awk_test.txt awk_demo.txt
awk awk_test.txt awk_demo.txt
awk awk_test.txt awk_demo.txt
awk awk_test.txt awk_demo.txt
awk awk_test.txt awk_demo.txt
awk awk_test.txt awk_demo.txt

```

##### awk引用自定义变量

```bash
$ awk -v myName="alex" 'BEGIN{print "我的名字是？",myName}'
我的名字是？ alex


```

#### awk -> printf格式化输出
```bash
format的使用

要点：
其与print命令最大不同是：printf需要指定format
format用于指定后面的每个item的输出格式
printf语句不会自动打印换行符

format格式的指示符都以%开头，后跟一个字符,如下：
	%c：显示字符的ASCII码
	%d，%i：十进制整数
	%e，%E：科学计数法显示数值
	%f：显示浮点数
	%g，%G：以科学计数法的格式或浮点数的格式显示数值
	%s：显示字符串
	%u：无符号整数
	%%：显示%自身

printf修饰符：
-：左对齐，默认右对
	* ```%-25s```-表示左对齐，25个字符长度
+：显示数值符号：printf "%+d"

```

- printf默认不会添加换行符
- print默认添加空格换行符

```bash
#对文本awk_test.txt测试
$ awk '{printf $1}' awk_test.txt
pyyu1pyyu6pyyu11pyyu16pyyu21pyyu26pyyu31pyyu36pyyu41pyyu46

$ awk '{print $1}' awk_test.txt
pyyu1
pyyu6
pyyu11
pyyu16
pyyu21
pyyu26
pyyu31
pyyu36
pyyu41
pyyu46

```

#### awk -> printf添加格式化
```bash
$ awk '{printf "%s\n", $1}' awk_test.txt
pyyu1
pyyu6
pyyu11
pyyu16
pyyu21
pyyu26
pyyu31
pyyu36
pyyu41
pyyu46


#注意，此处对文本awk_test.txt做了改动，删除了最后一列($NF)的最后两行
$ awk '{printf "第一列：%s\t第二列：%s\t最后一列：%s\n", $1,$2,$5}' awk_test.txt
第一列：pyyu1   第二列：pyyu2   最后一列：pyyu5
第一列：pyyu6   第二列：pyyu7   最后一列：pyyu10
第一列：pyyu11  第二列：pyyu12  最后一列：pyyu15
第一列：pyyu16  第二列：pyyu17  最后一列：pyyu20
第一列：pyyu21  第二列：pyyu22  最后一列：pyyu25
第一列：pyyu26  第二列：pyyu27  最后一列：pyyu30
第一列：pyyu31  第二列：pyyu32  最后一列：pyyu35
第一列：pyyu36  第二列：pyyu37  最后一列：pyyu40
第一列：pyyu41  第二列：pyyu42  最后一列：
第一列：pyyu46  第二列：pyyu47  最后一列：

#接上述被修改后的文件，如果将上述的$5改为$NF,输出如下(出现了借位的情况)
#注意，awk_test.txt此时最后一列的最后两行依旧为空
$ awk '{printf "第一列：%s\t第二列：%s\t最后一列：%s\n", $1,$2,$NF}' awk_test.txt
第一列：pyyu1   第二列：pyyu2   最后一列：pyyu5
第一列：pyyu6   第二列：pyyu7   最后一列：pyyu10
第一列：pyyu11  第二列：pyyu12  最后一列：pyyu15
第一列：pyyu16  第二列：pyyu17  最后一列：pyyu20
第一列：pyyu21  第二列：pyyu22  最后一列：pyyu25
第一列：pyyu26  第二列：pyyu27  最后一列：pyyu30
第一列：pyyu31  第二列：pyyu32  最后一列：pyyu35
第一列：pyyu36  第二列：pyyu37  最后一列：pyyu40
第一列：pyyu41  第二列：pyyu42  最后一列：pyyu44
第一列：pyyu46  第二列：pyyu47  最后一列：pyyu49

#awk_test.txt实体如下
$ cat -n awk_test.txt
     1  pyyu1 pyyu2 pyyu3 pyyu4 pyyu5
     2  pyyu6 pyyu7 pyyu8 pyyu9 pyyu10
     3  pyyu11 pyyu12 pyyu13 pyyu14 pyyu15
     4  pyyu16 pyyu17 pyyu18 pyyu19 pyyu20
     5  pyyu21 pyyu22 pyyu23 pyyu24 pyyu25
     6  pyyu26 pyyu27 pyyu28 pyyu29 pyyu30
     7  pyyu31 pyyu32 pyyu33 pyyu34 pyyu35
     8  pyyu36 pyyu37 pyyu38 pyyu39 pyyu40
     9  pyyu41 pyyu42 pyyu43 pyyu44
    10  pyyu46 pyyu47 pyyu48 pyyu49

```


```bash
#对awk_pwd.txt格式化
h$ awk -F ":" 'BEGIN{printf "%-25s\t %-25s\t %-25s\t %-25s\t %-25s\t %-25s\t %-25s\n","用户名","密码","UID","GID","用户注释","用户家目录","用户使用的解释器"} {printf "%-25s\t %-25s\t %-25s\t %-25s\t %-25s\t %-25s\t %-25s\n",$1,$2,$3,$4,$5,$6,$7}' awk_pwd.txt
用户名                           密码                            UID                             GID                             用户注释                        用户家目录                      用户使用的解释器
root                             x                               0                               0                               root                            /root                           /bin/bash
daemon                           x                               1                               1                               daemon                          /usr/sbin                       /usr/sbin/nologin
bin                              x                               2                               2                               bin                             /bin                            /usr/sbin/nologin
sys                              x                               3                               3                               sys                             /dev                            /usr/sbin/nologin
sync                             x                               4                               65534                           sync                            /bin                            /bin/sync
games                            x                               5                               60                              games                           /usr/games                      /usr/sbin/nologin
man                              x                               6                               12                              man                             /var/cache/man                  /usr/sbin/nologin
lp                               x                               7                               7                               lp                              /var/spool/lpd                  /usr/sbin/nologin
mail                             x                               8                               8                               mail                            /var/mail                       /usr/sbin/nologin
news                             x                               9                               9                               news                            /var/spool/news                 /usr/sbin/nologin

```


## awk模式pattern
- awk语法
```awk [option] 'pattern[action]' file'```
- awk是按行处理文本，上述为print动作，现在演示特殊的pattern：```BEGIN```和```END```
	* BEGIN模式是处理文本之前需要执行的操作
	* END模式是处理完所有行之后执行的操作

```bash
#BEGIN的用法
$ awk 'BEGIN{print "我要来了"}' awk_test.txt
我要来了

$ awk 'BEGIN{print "我要来了"} {print $1}' awk_test.txt
我要来了
pyyu1
pyyu6
pyyu11
pyyu16
pyyu21
pyyu26
pyyu31
pyyu36
pyyu41
pyyu46

#END的用法
$ awk '{print $1} END{print "已处理完end"}' awk_test.txt
pyyu1
pyyu6
pyyu11
pyyu16
pyyu21
pyyu26
pyyu31
pyyu36
pyyu41
pyyu46
已处理完end


#BEGIN和END结合使用
$ awk 'BEGIN{print "开始处理文本之前BEGIN"} {print $1} END{print "已处理完end"}' awk_test.txt                                                                                                    开始处理文本之前BEGIN
pyyu1
pyyu6
pyyu11
pyyu16
pyyu21
pyyu26
pyyu31
pyyu36
pyyu41
pyyu46
已处理完end

```
#### awk的模式
| 关系运算符| 描述 | 示例 |
| :---: | :---: | :---: |
| < | 小于 | x<y |
| <= | 小于等于 | x<=y |
| == | 等于 | x==y |
| >= | 大于等于 | x>=y |
| > | 大于 | x>y |
| ~ | 匹配正则 | x~/正则/ |
| !~  | 不匹配正则 | x!~/正则/ |

```bash
#现有awk_demo.txt文本如下
$ cat -n awk_demo.txt
     1  pyyu1
     2  pyyu2
     3  pyyu3
     4  pyyu4
     5  pyyu5

#通过awk模式只打印第三行
$ awk 'NR==3{print $0}' awk_demo.txt
pyyu3

#只打印第3行之后的内容
$ awk 'NR>3{print $0}' awk_demo.txt
pyyu4
pyyu5

#打印第四行前的内容
$ awk 'NR<4{print $0}' awk_demo.txt
pyyu1
pyyu2
pyyu3


#打印第2行到第4行的内容
$ awk 'NR==2,NR==4{print $0}' awk_demo.txt
pyyu2
pyyu3
pyyu4

```

#### awk与正则
- 正则主要与awk的```pattern模式(条件)```结合使用
	* 不指定模式，awk每行都会执行对应的动作
	* 指定模式，只有被模式匹配到的，符合条件的行才会执行动作

```bash
#对awk_pwd.txt进行操作
#找到含有mail的行
$ awk '/^mail/{print $0}' awk_pwd.txt
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin

#找到mail所在行，并只输出第一列和最后一列
$ awk -F ":" '/^mail/{print $1,$NF}' awk_pwd.txt
mail /usr/sbin/nologin


#筛选awk_pwd.txt
$ awk -F ":" 'BEGIN{printf "%-16s%-16s%-16s%-16s\n","用户名","用户ID","用户家目录","用户解释器"} {printf "%-16s%-16s%-16s%-16s\n",$1,$3,$6,$7}' awk_pwd.txt
用户名             用户ID            用户家目录           用户解释器
root            0               /root           /bin/bash
daemon          1               /usr/sbin       /usr/sbin/nologin
bin             2               /bin            /usr/sbin/nologin
sys             3               /dev            /usr/sbin/nologin
sync            4               /bin            /bin/sync
games           5               /usr/games      /usr/sbin/nologin
man             6               /var/cache/man  /usr/sbin/nologin
lp              7               /var/spool/lpd  /usr/sbin/nologin
mail            8               /var/mail       /usr/sbin/nologin
news            9               /var/spool/news /usr/sbin/nologin

#找出awk_pwd.txt中禁止登录的用户(/sbin/nologin),并打印行号
$ awk '/\/sbin\/nologin$/{print NR, $0}' awk_pwd.txt
2 daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
3 bin:x:2:2:bin:/bin:/usr/sbin/nologin
4 sys:x:3:3:sys:/dev:/usr/sbin/nologin
6 games:x:5:60:games:/usr/games:/usr/sbin/nologin
7 man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
8 lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
9 mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
10 news:x:9:9:news:/var/spool/news:/usr/sbin/nologin


#通过正则打印sys至mail行的内容并显示行号
$ awk '/^sys/,/^mail/ {print NR, $0}' awk_pwd.txt
4 sys:x:3:3:sys:/dev:/usr/sbin/nologin
5 sync:x:4:65534:sync:/bin:/bin/sync
6 games:x:5:60:games:/usr/games:/usr/sbin/nologin
7 man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
8 lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
9 mail:x:8:8:mail:/var/mail:/usr/sbin/nologin

#通过awk过滤出ip访问最频繁的10个IP地址
#由于没有nginx日志，所以不贴返回结果，只上演示命令

$ awk 'print $1' access.log | sort -n | uniq -c | sort -nr | head -10
			#打开日志     sort排序ip
						#uniq去重ip，-c会对出现的次数
								#去重后的ip前会有重复n次的序号，此时sort就在排序序号，注意，此时是从小到大，所以会加-r继续宁翻转
                                                                                                                     #最后取出前10行重复次数最多的ip  
```



### grep练习题
a.找出/etc/passwd中以root或qinghuo开头的行并显示行号
```bash
$ grep -E -n  "^(root|qinghuo)" /etc/passwd
1:root:x:0:0:root:/root:/bin/bash
31:qinghuo:x:1000:1000:,,,:/home/qinghuo:/bin/bash


#只找出/etc/passwd中以root或qinghuo开头的行，qinghuo1，qinghuo222这种不符合\>条件
#\>表示前方是一个完整的字符串
$ grep -E -n  "^(root|qinghuo)\>" /etc/passwd
1:root:x:0:0:root:/root:/bin/bash
31:qinghuo:x:1000:1000:,,,:/home/qinghuo:/bin/bash
```

b.找出/etc/passwd中除了以root开头的行
```bash
$ grep -v "^root" /etc/passwd
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
......

#若要显示行号
$ grep -v "^root" /etc/passwd -n
2:daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
3:bin:x:2:2:bin:/bin:/usr/sbin/nologin
......
```

c.统计root用户出现的次数
```bash
$ grep -c "^root" /etc/passwd
1

#若有user1,user2..usern，只想匹配两次，如下
$ grep -m 2  "^user" /etc/passwd
```

d.匹配多文件，列出存在信息的文件名
```bash
$ grep "print" hello.c hello.py
hello.c:        printf("Hello World!\n");
hello.py:print("Hello Py")

#若只需要文件名，添加-l参数即可
$ grep -l "print" hello.c hello.py hello.js
hello.c
hello.py
```

e.找出/etc/passwd中的两位数或三位数
```bash
#其中正则两侧的\<\>表示中间的内容是一个闭合的整体
$ grep -E "\<[0-9]{2,3}\>" /etc/passwd
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
......
```

f.找出以空白字符开头但非空的行
```bash
#演示文本如下
$ cat -n grep_test.txt
     1  This is Ubuntu.
     2   I like Linux.
     3  The C language.
     4  Python is Good.
     5   Wow,my god!
     6          This is tab line

$ grep "^[[:space:]].*" grep_test.txt
 I like Linux.
 Wow,my god!
        This is tab line
```

g.找出/etc/init.d/x11-common中所有的函数
```bash
$ grep -E "[a-zA-Z][[:space:]]\(\)" /etc/init.d/x11-common
do_restorecon () {
set_up_dir () {
do_status () {

#由于/etc/init.d/x11-common中的函数和()中间有一个空格，所以采用上述写法
#若无空格，则可采用下面的写法

$ grep -E "[a-zA-Z]+\(\)" /etc/init.d/x11-common
```
h.找出/etc/passwd中用户名和解释器相同的行(头尾相同)
```bash
$ grep -E "^([^:]+\>).*\1$" /etc/passwd
sync:x:4:65534:sync:/bin:/bin/sync

#注释 $ grep -E "^([^:]+\>).*\1$" /etc/passwd
	   	#[中的^表示对：取反]
			#\>表示前面的内容是闭合的
				#\1表示对前面()的内容引用	
```


### sed练习

现有文本sed_demo.txt,内容如下

```bash
$ cat -n sed_demo.txt
     1  root:x:0:0:root:/root:/bin/bash
     2  daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
     3  bin:x:2:2:bin:/bin:/usr/sbin/nologin
     4  sys:x:3:3:sys:/dev:/usr/sbin/nologin
     5  sync:x:4:65534:sync:/bin:/bin/sync
     6  games:x:5:60:games:/usr/games:/usr/sbin/nologin
     7  man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
     8  lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
     9  mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
    10  news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
    11  inghuo:x:1000:1000:,,,:/home/qinghuo:/bin/bash
```


### sed练习

现有文本sed_demo.txt

```bash
$ cat -n sed_demo.txt
     1  root:x:0:0:root:/root:/bin/bash
     2  daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
     3  bin:x:2:2:bin:/bin:/usr/sbin/nologin
     4  sys:x:3:3:sys:/dev:/usr/sbin/nologin
     5  sync:x:4:65534:sync:/bin:/bin/sync
     6  games:x:5:60:games:/usr/games:/usr/sbin/nologin
     7  man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
     8  lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
     9  mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
    10  news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
    11  inghuo:x:1000:1000:,,,:/home/qinghuo:/bin/bash
```

a.替换文件内的root为huohuo，只替换一次，与替换所有
```bash
#只替换一次
$ sed "s/root/huohuo/p" sed_demo.txt -n
huohuo:x:0:0:root:/root:/bin/bash
#正则最后面的p是print，-n是取消默认输出(默认打印整个文件)

#全局替换
$ sed "s/root/huohuo/gp" sed_demo.txt -n
huohuo:x:0:0:huohuo:/huohuo:/bin/bash
```

b.替换前10行b开头的用户，改为C，且只显示替换的结果
```bash
$ sed -n "1,10s/^bin/C/p" sed_demo.txt
C:x:2:2:bin:/bin:/usr/sbin/nologin
```


c.替换前10行b开头的用户，改为C，且将m开头的行改为M，且只显示替换的结果
```bash
$ sed -n "1,10s/^bin/C/p" -e "s/^m/M/p" sed_demo.txt
sed: can't read 1,10s/^bin/C/p: No such file or directory
Man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
Mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
```


d.删除第4行后面所有内容
```bash
$ sed '5,$d' sed_demo.txt
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
```


e.删除从root开始至game之间的行
```bash
#通过查看行号删除
$ sed '1,6d' sed_demo.txt
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
inghuo:x:1000:1000:,,,:/home/qinghuo:/bin/bash


#通过首单词删除
$ sed '/^root/,/^game/d' sed_demo.txt
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
inghuo:x:1000:1000:,,,:/home/qinghuo:/bin/bash
```

现有文本like.txt，内容如下
```bash
$ cat -n like.txt
     1  This is Ubuntu.
     2   I like Linux.
     3  The C language.
     4  Python is Good.
     5   Wow,my god!
     6          This is tab line
     7
     8
     9
    10
```

f.对文件中空白字符开头的行，添加注释
```bash
#下述命令只对非空的添加了注释
$ sed 's/^[[:space:]]/#/p' like.txt -n
#I like Linux.
#Wow,my god!
#This is tab line


#通过-e进行多次编辑
$ sed -e 's/^[[:space:]]/#/p' -e 's/^$/#/gp'  like.txt -n
#I like Linux.
#Wow,my god!
#This is tab line
#
#
#
#
```

g.给文件前3行首字母添加@
```bash
#通过-r扩展正则
$ sed -r '1,3s/(^.)/@\1/p' like.txt -n
@This is Ubuntu.
@ I like Linux.
@The C language.
```



### awk练习

a.打印普通用户及其家目录
```bash
$ awk -F ":" '$3>=1000{print $1,$(NF-1)}' /etc/passwd
nobody /nonexistent
qinghuo /home/qinghuo
```







































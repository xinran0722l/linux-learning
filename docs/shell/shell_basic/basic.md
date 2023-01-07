# 初识Shell

## 使用变量

> 在涉及环境变量名时，如果要用到变量，使用$;如果要操作变量，不用$;这条规则的一个例外就是 printenv 显示某个变量的值

与系统变量雷系，用户变量可通过美元符引用。变量每次被引用时，都会输出
当前赋的值。*引用一个变量值时，需要美元符*，```引用变量对其赋值时，
不用美元符```

```bash
#!/bin/bash
# assigning a variable value to another variable
value1=10
value2=$value1
echo "The resulting value is $value2"
```
```bash
$ chmod u+x test4.sh 
$ ./test4.sh 
The resulting value is 10
```

如果忘了用美$,使value2的赋值变成了这样：

```bash
value2=value1
```

那么得到的输出如下
```bash
$ ./test4.sh
The resulting value is value1
```

没有美元符，shell会将变量名解释成普通的文本字符串，通常这并不是需要的结果

### 命令替换

shell脚本中最有用的特性之一就是可以从命令输出中提取信息，并将其赋给变量，
把输出赋给变量后，就可以随意在脚本中使用了。这个特性在处理脚本数据时尤为方便

有两种方法可以将命令输出赋给变量：

- 反引号 testing=`date`
- $()格式 testing=$(date)

下面这个粒子很常见，它在脚本中通过命令替换获得当前日期并用它来生成唯一文件名

```bash
$ cat test5.sh 
#!/bin/bash
# copy the /usr/bin/ directory listing to a log file
today=$(date +%y%m%d)
ls /usr/bin -al > log.$today
```

today变量被赋予格式化后的date命令的输出。这是提取日期信息来生成日志文件名常用的
一种技术。+%y%m%d 格式告诉date命令将日期显示为两位数的年月日的组合

```bash
$ date +%y%m%d
230104
```

test5.sh将日期赋给一个变量，之后再将其作为文件名的一部分。文件自身
含有/usr/bin/ 目录列表的重定向输出。运行该脚本之后，应该能在目录中看到一个新文件

```bash
-rw-r--r-- 1 qinghuo qinghuo 122971 Jan  4 12:28 log.230104
```

目录中出现的日志文件采用 $today 变量的值作为文件名的一部分。
日志文件的内容是 /usr/bin 目录内容的列表输出。如果脚本在明天运行，
日志文件名会是 log.230105,就这样为新的一天创建一个新文件

> 命令替换会创建一个子shell来运行对应的命令。子 shell (subshell) 是由
运行该脚本的shell所创建出来的一个独立的子 shell (child shell) 。正因此，
由该子 shell 所执行命令是无法使用脚本中所创建的变量的

## 输出重定向

有些时候想要保存某几个命令的输出而不仅仅只是让它显示在屏幕上。bash Shell提供
了几个操作符，可以将命令的输出重定向到另一个位置(比如文件)。重定向
可以用于输入，也可以用于输出，可以将文件重定向到命令输入

### 输出重定向

最基本的重定向将命令的输出发送到一个文件中。bash shell 用 大于号 ( > )来完成
这项功能，之前显示器上出现的命令输出会被保存到指令的输出文件中

```bash
$ date > test6
$ ll test6
-rw-r--r-- 1 qinghuo qinghuo 32 Jan  4 12:38 test6
$ cat test6
Wed Jan  4 12:38:52 PM CST 2023
```

重定向操作符创建了一个文件 test6 ( 通过默认的 umask 设置 ),并将 date 命令的输出
重定向到该文件中。如果输出文件已经存在了，重定向操作符会用心得文件数据覆盖已有文件。

若不想覆盖文件原有内容，可以用双大于号( >> ) 来追加数据

```bash
$ who > test6
$ date > test6

$ cat test6
qinghuo  tty1         2023-01-04 07:12
qinghuo  pts/2        2023-01-04 10:05 (tmux(4336).%0)
qinghuo  pts/3        2023-01-04 10:08 (tmux(4336).%1)
Wed Jan  4 12:41:46 PM CST 2023
```

### 输入重定向

输入重定向和输出重定向正好相反。输入重定向将文件的内容重定向到命令，而非
将命令的输出重定向到文件。输入重定向符号是小于号 ( < )

一个简单的记忆方法：在命令行上，命令总是在左侧，而重定向符号*指向*数据流动
的方向。小于号说明数据正在从输入文件流向命令。下面是和 wc 命令一起使用输入
重定向的例子

```bash
$ wc < test6
  4  21 181
```

wc命令可以对数据中的文本进行计数。默认情况下，它会输出3个值：

- 文本的行数
- 文本的词数
- 文本的字节数

通过将文本文件重定向到wc命令，立刻就可以得到文件中的行、词和字节的计数。
这个例子说明test6文件有4行、21个单词以及181字节

还有另一种输入重定向的方法，称为```内联输入重定向``` (inline input redirecion)。这
种方法无需使用文件进行重定向，只需要在命令行中指定用于输入重定向的数据就可以了

内敛输入重定向符号是双小于号 ( << )。除了这个符号，必须指定一个文本标记来
划分输入数据的开始和结尾。任何字符串都可作为文本标记，但在数据的开始和结尾文本
标记必须一致

在命令行上使用内联输入重定向时，Shell 会用 PS2 环境变量中定义的次提示符(即 > 符号)
来提示输入数据。下面是它的使用情况

```bash
$ wc << EOF
> test string 1
> test string 2
> test string 3
> EOF
      3       9      42
$ 
```
次提示符会持续提示，以获取更多的输入数据，知道你输入了作为文本标记的那个字符串。
wc 命令会对内联输入重定向提供的数据进行 行、词和字节计数

## 管道

```管道连接```(piping)。管道被放在命令之间，将一个命令的输出重定向到另一个命令中

```bash
command1 | command2
```

不要以为由管道串起来的两个命令会依次执行。Linux系统实际上会同时运行这两个
命令，在系统内部将他们连接起来。在第一个命令产生输出的同时，输出会被立即
送给第二个命令。数据传输不会用到任何中就爱你文件或缓冲区

## 执行数学运算

另一个对任何编程语言都很重要的特性是操作数字的能力。遗憾的是，对shell来说，
这个处理过程会比较麻烦。在shell中有两种途径来进行数学运算

### expr 命令

最开始，Bourne shell 提供了一个特别的命令来处理数学表达式。expr 命令允许在
命令行上进行数学表达式，但是特别笨拙

```bash
$ expr 1 + 5
6
```

expr 能够识别少数的数学和字符串操作符。尽管标准操作符在expr 命令中工作的很好，
但在脚本或命令行上使用它们时仍有问题出现。许多expr命令操作符在Shell中另有
含义 (比如星号)。当它们出现在expr命令中时，会得到一些诡异的结果

```bash
$ expr 5 * 2
expr: syntax error: unexpected argument ‘log.’
```

要解决这个问题，对于那些容易被 shell 错误解释的字符，在它们传入 expr 命令之前，
需要使用 shell 的转移字符(反斜线) 将其标出来

```bash
$ expr 5 \* 2
10
```

现在，麻烦才刚刚开始！在 shell 中使用 expr 命令也同样复杂

```bash
$ cat test7.sh 
#!/bin/bash
# An example of using the expr command
var1=10
var2=20
var3=$(expr $var2 / $var1)  #命令替换的方式
echo "The result is $var3"
```

要将一个数学算是的结果赋给一个变量，需要使用命令替换来获取expr的输出

```bash
$ chmod u+x test7.sh 
$ ./test7.sh 
The result is 2
```

幸好 bash shell 有一个针对处理数学运算符的改进，那就是方括号

### 使用方括号

bash shell 为了保持跟 Bourne shell 的兼容而包含了 expr 命令，但他同样也提供
了一种更简单的方法来执行数学表达式。在 bash 中，在将一个数学运算结果赋给某个变量
时，可以用美元符和方括号 ( $[ operation ] ) 将数学表达式围起来

```bash
$ var1=$[1 + 5]
$ echo $var1
6
$ var2=$[$var1 * 2]
$ echo $var2
12
```

用方括号执行shell 数学运算比用expr 命令方便许多，这种技术也适用于 shell 脚本

```bash
$ cat test8.sh 
#!/bin/bash
var1=100
var2=50
var3=45
var4=$[ $var1 * ($var2 - $var3) ]
echo "The final result is $var4"    # The final result is 500

$ ./test8.sh 
The final result is 500
```

同样,注意在使用方括号来计算公式时，不用担心 shell 会误解称号或其他符号

在bash shell 脚本中进行算术运算会有一个主要的限制。请看下例

```bash
$ cat test9.sh 
#!/bin/bash
var1=100
var2=45
var3=$[ $var1 / $var2 ]
echo "The final result is $var3"    #The final result is 2

$ chmod u+x test9.sh 
$ ./test9.sh 
The final result is 2
```

bash shell 数学运算只支持整数运算。若要进行任何实际的数学计算，这是一个巨大的限制

> z shell 提供了完整的浮点数算术操作。如果需要在shell脚本中进行浮点数
运算，可以用 z Shell

### 浮点解决方案

有几种解决方案能客服 bash 中数学运算的整数限制。最常见的方案是用
内建的 bash 计算机，叫做  bc

bash 计算器实际上是一种编程语言，它允许在命令行中输入浮点表达式，然后解释并
计算该表达式，最后返回结果。 bash 计算器能够识别：

- 数字 (整数和浮点数)
- 变量 (简单变量和数组)
- 注释 (以#或C 语言中/**/开头的行)
- 表达式
- 编程语句 (如 if-then 语句)
- 函数

可以在shell 提示符下通过 bc 命令访问bash 计算器

```bash
$ bc
bc 1.07.1
Copyright 1991-1994, 1997, 1998, 2000, 2004, 2006, 2008, 2012-2017 Free Software Foundation, Inc.
This is free software with ABSOLUTELY NO WARRANTY.
For details type `warranty'. 

12 * 5.4
64.8

3.1415 * (3 + 5)
25.1320

quit
```

浮点运算是由内建变量 scale 控制的。必须将这个值设置为你希望在计算结果中
保留的小鼠位数，否则无法得到期望的结果。

```bash
$ bc -q
3.44 / 5
0
scale=4
3.44 / 5
.6880
quit
```

scale变量的默认值是0.在 scale 值被设置前，bash 计算器的计算结果不包含
小数位。在将其值设置成4后，bash 计算器显示的结果包含四位小数。
-q命令行选项可以不显示 bash 计算器冗长的欢迎信息

除了普通数字，bash 计算器还支持变量

```bash
$ bc -q
var1=10
var1 * 5
50
var2 = var1 / 5
print var2
2
quit
```

变量一旦定义，就可以在整个bash 计算器会话中使用该变量了。print语句
允许打印变量和数字

***

bash 计算器如何在 shell 脚本中帮助处理浮点运算--命令替换。
可以用命令替换运行bc命令，并将输出赋给一个变量

```bash
$ cat test_1.sh 
#!/bin/bash
var1=$(echo "scale=4; 3.44 / 5" | bc)
echo "The answer is $var1"  # The answer is .6800

$ ./test_1.sh 
The answer is .6880
```

也可以用 shell 脚本中定义好的变量进行运算

```bash
$ cat test_2.sh 
#!/bin/bash
var1=100
var2=45
var3=$(echo "scale=4; $var1 / $var2" | bc)
echo "The answer for this is $var3" #The answer for this is 2.222

$ ./test_2.sh 
The answer for this is 2.2222
```

当然，一旦变量被复制，那个变量也可以用于其他运算

```bash
$ cat test_3.sh 
#!/bin/bash
var1=20
var2=3.14159
var3=$(echo "scale=4; $var1 * $var1" | bc)
var4=$(echo "scale=4; $var3 * $var2" | bc)
echo "The final result is $var4"

$ ./test_3.sh 
The final result is 1256.63600
```

这种方法适用于较短的元算，有时会涉及更多的数字。如果需要大量晕眩，
在一个命令行中列出多个表达式就会很麻烦

有一个方法可以解决这个问题。bc 命令能识别输入重定向，允许将一个文件重定向
到 bc 命令来处理。但这同样会让人头疼，因为还需要将表达式放在文件中

最好的办法是使用内联输入重定向，它允许直接在命令行中重定向数据，可以将
所有 bash 计算器涉及的部分都放到同一个脚本文件的不同行。下面是在脚本中
使用这种技术的例子

```bash
$ cat test_4.sh 
#!/bin/bash
var1=10.46
var2=43.67
var3=33.2
var4=71
var5=$(bc << EOF
scale = 4 
a1 = ($var1 * $var2)
b1 = ($var3 * $var4)
a1 + b1
EOF
)
echo "The final answer for this mess is $var5"

$ ./test_4.sh 
The final answer for this mess is 2813.9882
```

将选项和表达式放在脚本的不同行中可以让处理过程变得更清洗。EOF字符串标识
了重定向给 bc 命令的数据的起止。当然，必须用命令替换符号标识出用来给
变量赋值的命令

在这里例子中，可以在 bash 计算器中赋值给变量。有一点很重要：
在bash 计算器中创建的变量只在 bash 计算器中有效，不能再shell 脚本中使用

## 退出脚本

迄今为止所有的示例脚本中，我们都是直接停止的。运行完最后一条命令时，脚本就结束了。
其实还有另外一种更优雅的方法可以为脚本划上一个句号。

shell 中运行的每个命令都使用```退出状态码```(exit status)告诉 shell 它已经
运行完毕。退出状态吗是一个 0 ～ 255 的整数值，在命令结束运行时由命令传给
shell 。可以捕获这个值并在脚本中使用

### 查看退出状态码

Linux提供了一个专门的变量 ```$?``` 来保存上个已执行命令的退出状态吗。对于需要
进行检查的命令，必须在其运行完毕后立刻查看或使用*$?*变量。它的值会变成
由shell 所执行的最后一条命令的退出状态码

```bash
$ date
Wed Jan  4 02:21:16 PM CST 2023
$ echo $?
0
```

按照惯例，一个成功结束的命令的退出状态吗是 0。如果一个命令结束时有错误，退出
状态码就是一个正常数值

```bash
$ abcd
bash: abcd: command not found
$ echo $?
127
```

无效命令会返回一个退出状态码127。Linux 错误退出状态吗没什么标准可循，但
有一些可用的参考

- 0 命令成功结束
- 1 一般性未知错误
- 2 不适合的 shell 命令
- 126 命令不可执行
- 127 没有找到命令
- 128 无效的退出参数
- 128+x 与 Linux 信号 x 相关的严重错误
- 130 通过 Ctrl + C 终止的命令
- 225 正常范围之外的退出状态码

退出状态码 126 表明用户没有执行命令的正确权限

```bash
$ ./.Xresources
bash: ./.Xresources: Permission denied
$ echo $?
126
```

另一个会碰到的常见错误是给某个命令提供了无效参数

```bash
$ date %t
date: invalid date ‘%t’
$ echo $?
1
```

这会产生一般性的退出状态码 1,表明在命令中发生了未知错误

### exit 命令

默认情况下，shell 脚本会以脚本中的最后一个命令的退出状态码退出。可以
改变这种默认行为，返回自己的退出状态码。exit 命令允许在脚本结束时指定
一个退出状态码

```bash
$ cat test_5.sh 
#!/bin/bash
# testing the exit status
var1=10
var2=30
var3=$[$var1 + $var2]
echo "The answer is $var3"
exit 5
```

当查看脚本的退出码时，会得到作为参数传给exit 命令的值

```bash
$ chmod u+x test_5.sh 
$ ./test_5.sh 
The answer is 40
$ echo $?
5
```

也可以在 exit 命令的参数中使用变量

```bash
$ cat test_6.sh 
#!/bin/bash
# testing the exit status
var1=10
var2=30
var3=$[$var1 + $var2]
exit $var3
```

当运行这个脚本时，会产生如下退出状态

```bash
$ chmod u+x test_6.sh 
$ ./test_6.sh 
$ echo $?
40
```

在以往，exit 退出状态码最大只能是 255，如果超过了 255，最终的结果是指定的数值除以 256 后得到的余数。比如，指定的值是 300（返回值），余数是 44，因此这个余数就成了最后的状态退出码。但是在现在，此限制已经不存在，你可以使用 exit 指令指定更大的数值。

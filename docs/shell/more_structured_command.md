# 更多的结构化命令

上一章，学习了如何通过检查命令的输出和变量的值来改变 shell 脚本程序的流程。
本章继续介绍能够控制 shell 脚本流程的结构化命令。本章会演示 bash shell
的循环命令 for、while 和 until 等

## for 命令

重复执行一系列命令在编程中很常见。通常你需要重复一组命令直至达到某个特定条件，比如处理某个目录下的所有文件、系统上的所有用户或是某个文本文件中的所有行。for 命令有几种不同的方式来读取列表中的值，下面几节将会介绍各种方式。

### 读取列表中的值

for 命令最基本的用法就是遍历 for 命令自身所定义的一系列值

```bash
$ cat t1.sh 
#!/bin/bash
# basic for command
for test in Alabma Alaska Arizona Arkansas California Colorado
do
    echo "The next state is $test"
done
echo "The last state we visited was $test"
test=Connecticut
echo "Wait, now we're visiting $test"
$ 
$ ./t1.sh 
The next state is Alabma
The next state is Alaska
The next state is Arizona
The next state is Arkansas
The next state is California
The next state is Colorado
The last state we visited was Colorado
Wait, now we're visiting Connecticut
$ 
```

每次 for 命令便利值列表，他都会将列表中的下个值赋给 $test 变量。$test 变量
可以像 for 语句中的其他脚本变量一样使用。在最后一次迭代后，$test 变量的值会在
shell 脚本的剩余部分一直保持有效。它会一直保持最后一次迭代的值(除非你修改了它)。
$test 变量保持了其值，也允许我们修改它的值，并在 for 命令循环之外跟其他变量一样使用

事情并不会总像在 for 循环中看到的那么简单。有时会遇到难处理的数据。有时
for 循环的值列表中可能存在中间有空格的值，此时使用单引号或双引号将中间
存在空格的值括起来即可。有时候，有的值自身中存在单引号或双引号，这时
需要用另外一种相反的引号将其括起来，或者使用反斜杠转义

### 从变量读取列表

通常 shell 脚本遇到的情况是，将一系列值都集中存储在了一个变量中，
然后需要遍历变量中的整个列表。也可以通过 for 命令完成这个任务

```bash
$ cat t2.sh 
#!/bin/bash
# using a variable to hold the list
list="Alabama Alaska Arizona Arkanasa Colorado"
list=$list" Connecticut"
for state in $list
do
    echo "Hava you ever visited $state?"
done
$ 
$ ./t2.sh 
Hava you ever visited Alabama?
Hava you ever visited Alaska?
Hava you ever visited Arizona?
Hava you ever visited Arkanasa?
Hava you ever visited Colorado?
Hava you ever visited Connecticut?
$ 
```

$list 变量包含了用于迭代的标准文本值列表。注意，代码还是用了另一个赋值
语句向 $list 变量包含的已有列表中添加(或者说拼接) 了一个值。这是向
变量中存储的已有文本字符串尾部添加文本的一个常用方法

### 从命令读取值

生成列表所需值的另外一个途径就是使用命令的输出。可以用命令替换来执行任何
能产生输出的命令，然后在 for 命令中使用该命令的输出。

```bash
$ cat t3.sh 
#!/bin/bash
# reading values from a file
file="states"
for state in $(cat $file)
do
    echo "Visit beautiful $state"
done

$ cat states 
Alabama
Alaska
Arizona
Arkansas
Colorado
Connecticut
Delaware
Florida
Georgia
$ 
$ ./t3.sh 
Visit beautiful Alabama
Visit beautiful Alaska
Visit beautiful Arizona
Visit beautiful Arkansas
Visit beautiful Colorado
Visit beautiful Connecticut
Visit beautiful Delaware
Visit beautiful Florida
Visit beautiful Georgia
$ 
```

这个例子在命令替换中使用了 cat 命令来输出文件 states 的内容。states 文件中
每一行有一个州，而不是通过空格分割的。for 命令仍然以每次一行的方式遍历
了 cat 命令的输出，假定每个州都是在单独的一行上。但这并没有解决数据中有空格
的问题。如果一个名字中有空格的州，for 命令仍然会将每个单词当作单独的值。
这是有原因的，见下面

> t3.sh 的脚本中，将文件名赋给变量，文件名中没有加入路径。这要求文件
和脚本位于同一目录中。如果不是的花，需要使用全路径名(不管是绝对路径
还是相对路径)来引用文件位置

### 更改字段分隔符

造成这个问题的原因是特殊的环境变量 IFS,叫做内部字段分隔符(internal field separator)。
IFS 环境变量定义了 bash shell 用作字段分隔符的一系列字符。默认情况下，
bash shell 会将下列字符当作字段分隔符：

- 空格
- 制表符
- 换行符

如果 bash shell 在数据中看到了这些字符中的任意一个，它会假定这表明了列表中
一个新数据字段的开始。在处理可能含有空格的数据(比如文件名)时，这会
非常麻烦

要解决这个问题，可以在 shell 脚本中临时更改 IFS 环境变量的值来限制
被 bash shell 当作字段分隔符的字符。例如，如果向修改 IFS 的值，使
其只能识别换行符，那就必须这么做：

```bash
IFS=$'\n'
```

将这个语句加入到脚本中，告诉 bash shell 在数据值中忽略空格和制表符。
对前一个脚本使用这种方法， shell 脚本就能够使用列表中含有空格的值了

> 在处理代码量较大的脚本时，可能在一个地方需要修改 IFS 的值，然后忽略
这次修改，在脚本的其他地方继续沿用 IFS 的默认值。一个可参考的安全实践
实在改变 IFS 之前保存原来的 IFS 值，之后再恢复它。这种技术可以这样实现：
IFS.OLD=$IFS IFS=$'\n' <在代码中使用新的 IFS 的值> IFS=IFS.OLD 这就
保证了在脚本的后续操作中使用的是 IFS 的默认值

还有其他一些 IFS 环境变量的绝妙用法。要遍历一个文件中用冒号分隔的值(
比如在 /etc/passwd 文件中)。要做的就是将 IFS 的值设为冒号

```bash
IFS=:
```

如果要指定多个 IFS 字符，只要将它们在复制前串起来就行

```bash
IFS=$'\n':;"
```

这个赋值会将换行符、冒号、分号和双引号作为字段分隔符。如何使用
IFS 字符解析数据没有任何限制

### 用通配符读取目录

最后，可以用 for 命令来自动便利目录中的文件。进行此操作时，必须在文件名或路径名
中使用通配符。它会强制 shell 使用文件扩展匹配。文件扩展匹配是生成匹配
指定通配符的文件名或路径名的过程

如果不知道所有的文件名，这个特性在处理目录中的文件时就非常好用

```bash
$ cat t4.sh 
#!/bin/bash
# iterate through all the files in a directory
for file in /home/qinghuo/Desktop/shell/more_structed/*
do
    if [ -d "$file" ]; then
        echo "$file is a directory"
    elif [ -f "$file" ]; then
        echo "$file is a file"
    fi
done


$ ./t4.sh 
/home/qinghuo/Desktop/shell/more_structed/dir is a directory
/home/qinghuo/Desktop/shell/more_structed/dir_2 is a directory
/home/qinghuo/Desktop/shell/more_structed/dir_3 is a directory
/home/qinghuo/Desktop/shell/more_structed/states is a file
/home/qinghuo/Desktop/shell/more_structed/t1.sh is a file
/home/qinghuo/Desktop/shell/more_structed/t2.sh is a file
/home/qinghuo/Desktop/shell/more_structed/t3.sh is a file
/home/qinghuo/Desktop/shell/more_structed/t4.sh is a file
$ 
```

for 命令会遍历/home/qinghuo/Desktop/shell/* 输出的结果。该代码用
test 命令测试了每个条目(使用方括号方法),以查看它是目录(通过
-d 参数)还是文件( -f 参数)

NOTE:我们在这个粒子的 if 语句做了一些不同的处理

```bash
if [ -d "$file"]
```

在 Linux 中，目录名和文件名包含空格当然是合法的。要适应这种情况，
应该将 $file 变量用双引号圈起来。如果不这么做，遇到含有空格
的目录名或文件名时就会有错误产生

```bash
./test6: line 6: [: too many arguments
./test6: line 9: [: too many arguments
```

在 test 命令中， bash shell 会将额外的单词当作参数，进而造成错误

也可以在 for 命令列出多个目录通配符，将目录查找和列表合并进同一个 for 语句

```bash
$ cat t5.sh 
#!/bin/bash
# iterating through multiple directories
for file in /home/qinghuo/.b* /home/qinghuo/Desktop/
do
    if [ -d "$file" ]; then
        echo "$file is a directoy"
    elif [ -f "$file" ]; then
        echo "$file is a file"
    else
        echo "$file doesn't exist"
    fi
done

$ ./t5.sh 
/home/qinghuo/.bash_history is a file
/home/qinghuo/.bash_logout is a file
/home/qinghuo/.bash_profile is a file
/home/qinghuo/.bashrc is a file
/home/qinghuo/Desktop/ is a directoy
$ 
```

for 语句首先爱你使用了文件扩展匹配来遍历通配符生成的文件列表，然后它
会遍历列表中的下一个文件。可以将任意多的通配符放进列表中

> NOTE: 可以在数据列表中放入任何东西。即使文件或目录不存在， for 语句
也会尝试处理列表中的内容。在处理文件或目录时，这可能会是个问题。你无法知道
你正在尝试遍历的目录是否存在：在处理之前测试一下文件或目录总是好的

## C 语言风格的 for 命令

如果你从事过 C 语言编程，可能会对 bash shell 中 for 命令的工作方式有点惊奇。在 C 语言中，for 循环通常定义一个变量，然后这个变量会在每次迭代时自动改变。通常程序员会将这个变量用作计数器，并在每次迭代中让计数器增一或减一。bash 的 for 命令也提供了这个功能。本节将会告诉你如何在 bash shell 脚本中使用 C 语言风格的 for 命令。

C 语言的 for 命令有一个用来指明变量的特定方法，一个必须保持成立才能继续迭代的条件，以及另一个在每个迭代中改变变量的方法。当指定的条件不成立时，for 循环就会停止。条件等式通过标准的数学符号定义。比如，考虑下面的 C 语言代码：

```c
for(i = 0; i < 10; i++) {
        printf("The next number is %d\n",i)
    }
```


























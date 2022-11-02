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

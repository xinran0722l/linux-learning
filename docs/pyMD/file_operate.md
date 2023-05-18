# 文件的理解
- 文件是数据的抽象和集合
- 文件是存储在辅助存储器上的数据序列
- 文件是数据存储的一种形式
- 文件展现形态：文本文件和二进制文件

```py
                           文本or二进制，读or写
  <变量名> = open( <文件名>,<打开模式> )
 文件句柄        文件路径和名称
```

## 文件的打开
| 文件打开模式 | 描述 | 
| :---: | :---: |
| 'r' | 只读模式，默认值，如果文件不存在，返回FileNotFountError | 
| 'w' | 覆盖写模式，文件不存在则创建，存在则完全覆盖 | 
| 'x' | 创建写模式，文件不存在则创建，存在则返回FileExistsError | 
| 'a' | 追加写模式，文件不存在则创建，存在则在文件最后追加内容 | 
| 'b' | 二进制文件模式 | 
| 't' | 文本文件模式，默认值 | 
| '+' | 与r/w/x/a一同使用，在原功能基础上增加同时读写功能 | 

- 文件关闭：```f.close()```

## 文件内容的读取
| 文件内容的读取 | 描述 | 
| :---: | :---: |
| f.read(size = -1) | 读入全部内容，如果给出参数，读入前size长度 | 
| f.readline(size = -1) | 读入一行内容，如果给出参数，读入改行前size长度 | 
| f.readlines(hint = -1) | 读入文件所有行，以每行为元素形成列表，如果给出参数，读入前hint行 | 

现有文本路径: ~/Documents/txt.txt 
内容如下:

```py
Make English as your working language. （让英语成为你的工作语言）
Practice makes perfect. （熟能生巧）
All experience comes from mistakes. （所有的经验都源于你犯过的错误）
Don't be one of the leeches. （不要当伸手党）
Either outstanding or out. （要么出众，要么出局）
```
### 打开文件--并查看文件类型

```py
f = open("/home/qinghuo/Documents/txt.txt","r+",encoding="utf-8")
print(type(f))
# <class '_io.TextIOWrapper'>
```

### 读取文件--read()

```py
print(f"读取10个字节： {f.read(10)}")
print("#".center(30,"-"))
print(f"读取全部字节： {f.read()}")
# 读取10个字节： Make Engli
# --------------#---------------
# 读取全部字节： sh as your working language. （让英语成为你的工作语言）
# Practice makes perfect. （熟能生巧）
# All experience comes from mistakes. （所有的经验都源于你犯过的错误）
# Don't be one of the leeches. （不要当伸手党）
# Either outstanding or out. （要么出众，要么出局）
```

### 读取文件- readlines()

```py
lines = f.readlines()
print(f"lines Object Type: {type(lines)}")
print(f"lines Object Content: {lines}")
# lines Object Type: <class 'list'>
# lines Object Content: ['Make English as your working language. （让英语
# 成为你的工作语言）\n', 'Practice makes perfect. （熟能生巧）\n', 'All experience comes from mistakes. （所有的经验都源于你犯过的错误）\n', "Don't be one of the leeches. （不要当伸手党）\n", 'Either outstanding or out. （要么出众，要么出局）\n']
```

### 读取文件- readline()

```py
line1 = f.readline()
line2 = f.readline()
line3 = f.readline()
line4 = f.readline()
print(f"one line is : {line1}")
print(f"two line is : {line2}")
print(f"three line is : {line3}")
print(f"four line is : {line4}")
# one line is : Make English as your working language. （让英语成为你的工
# 作语言）
#
# two line is : Practice makes perfect. （熟能生巧）
#
# three line is : All experience comes from mistakes. （所有的经验都源于
# 你犯过的错误）
#
# four line is : Don't be one of the leeches. （不要当伸手党）
```
### 遍历--此方法读出文件的每行，最后会有\n

```py
for line in f:
    print(f"line content is: {line}")
# line content is: Make English as your working language. （让英语成为你
# 的工作语言）
#
# line content is: Practice makes perfect. （熟能生巧）
#
# line content is: All experience comes from mistakes. （所有的经验都源于
# 你犯过的错误）
#
# line content is: Don't be one of the leeches. （不要当伸手党）
#
# line content is: Either outstanding or out. （要么出众，要么出局）
```

### with语法打开文件

- with 语法
    * 通过```with open```打开的文件，可以自动关闭，无需close()
    * 使用 with 时，open() 返回的文件对象只在 with 代码块内可用

```python
with open("/home/qinghuo/Documents/txt.txt","r+",encoding="utf-8") as f:
    print(f.readline())
# Make English as your working language. （让英语成为你的工作语言）
```

## 数据的文件写入
| 文件内容的读取 | 描述 | 
| :---: | :---: |
| f.write(s) | 向文件写入一个字符串或字节流 | 
| f.writelines(lines) | 将一个元素全为字符串的列表写入文件(直接拼接字符串) | 
| f.tell(self, *args, **kwargs) | 返回当前文件操作的光标位置 | 
| f.flush(self, *args, **kwargs) | 把文件从内存buffer里强制刷新到硬盘 | 
| f.seek(offset) | 改变当前文件操作指针的位置，offset含义如下 | 

- offset的定义：0 -> 文件开头；1 -> 当前位置；2 -> 文件结尾

## 数据存储格式
- CSV：Comma-Separated Values
- 国际通用的一二维数据存储格式，一般.csv扩展名
- 每行一个一维数据，采用逗号分隔，无空行
- Excel和一般编辑软件都可以读入或另存为csv文件
- 如果某个元素缺失，逗号仍要保留
- 二位数据的表头可以作为数据存储，也可以另行存储
- 逗号为英文半角，逗号与数据之间无需空格

#### 以命令行实现对文件的全局替换
- 执行 ```python  replace.py  oldStr newStr filename```

```py
import sys

# sys.argv 返回命令行参数
oldStr = sys.argv[1]
newStr = sys.argv[2]
file_name = sys.argv[3]

f = open(file_name, "r+")   # open file
data = f.read() # read all content
str_count = data.count(oldStr)  # count all oldStr

new_data = data.replace(oldStr,newStr)

f.seek(0)   # 将文件指针指向行首
f.truncate()    # 清空全部旧内容
f.write(new_data)   # 写入新内容
f.close()   # 关闭文件,会将保存在内存中的文件写入外存

print(f"找到{oldStr}共{str_count}处，以全部替换为{newStr}...")
```

## 错误处理

每当发生让 Python 不知所措的错误是，他都会创建一个异常对象。异常是使用 `try-except` 代码块处理的

```py
try :
  <语句块1>

except :
  <语句块2>
```

```python
try:
    print(name)
except:
    print("出现了异常")
# 出现了异常

try:
    print(name)
except Exception as e: #Exception表示全部异常
    print("出错啦\n",e)
# 出错啦
#  name 'name' is not defined
```

### 除零异常

一个数字不能除以 0,但如果在 Python 中执行了这样的代码

```py
> cat err.py
print(5/0)

> python err.py
Traceback (most recent call last):
  File "/home/qinghuo/Desktop/py/zeroToOne/err.py", line 1, in <module>
    print(5/0)
          ~^~
ZeroDivisionError: division by zero
```

在上面的 traceback 中指出的错误 ZeroDivisionError 是一个异常对象。 

使用 try-except 

```py
> cat err.py
try:
    print(5/0)
except ZeroDivisionError:
    print("You can't divide by zero!")
> python err.py
You can't divide by zero!
```

### 错误处理的高级使用

```py
try :
  <语句块1>
except :
  <语句块2>
[else ]:
  <语句块3>
[finally] :
  <语句块4>

- finally 对应语句块4一定执行
- else 对应语句块3在不发生异常时执行
```
```python
try:
    print("name")
except Exception as e:
    print("Error")
#    raise e
else:
    print("Not Error")
# name
# Not Error

finally略
```


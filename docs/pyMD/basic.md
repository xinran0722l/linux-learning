# python basic
- ```python``` 的编辑器叫做 ```pycharm```
- ```python```中貌似没有基础类型，全是对象类型，其中 数字， 字符串， 元组都是不可变对象

## id()
- 可以通过```id()```这个函数来打印传入的实参地址

## type()
- 可以通过```type```函数来查看对象的类型

## 类型转换
```py
int() # 将参数转为 int
float() # 将参数转为 小数
complex() # 将参数转为 复数
str() # 将参数转为 字符串
```

## 字符串补充

```python
#字符串占位
mail = "xx@gmail.com"
print("my mail is %s" % mail)
# my mail is xx@gmail.com

#数字占位
year = 2022
month = 12
day = 30
print("今天是 %s 年，%s 月，%s 日" % (year, month, day))
#今天是 2022 年，12 月，30 日
```
| 占位符 | 描述 | 
| :---: | :---: |
| %s | 将内容转为字符串，放入占位位置 | 
| %d | 将内容转为整数，放入占位位置 | 
| %f | 将内容转为浮点数，放入占位位置 | 

### 字符串--数字精度

- m.n用来控制数据的宽度和精度
    * m 控制宽度，要求是数字，设置的宽度小于数字自身不生效
    * .n 控制小数点精度，要求是数字，会进行小数的四舍五入

```python
num1 = 3
num2 = 3.1415
print("数字3,宽度限制5,结果是：%5d" % num1)
print("数字3,宽度限制1,结果是：%1d" % num1)
print("数字3.1415,宽度限制7,小数限制2,结果是：%7.2f" % num2)
print("数字3.1415,宽度不限制,小数限制2,结果是：%.1f" % num2)
#数字3,宽度限制5,结果是：    3
#数字3,宽度限制1,结果是：3
#数字3.1415,宽度限制7,小数限制2,结果是：   3.14
#数字3.1415,宽度不限制,小数限制2,结果是：3.1
```

### string formating <-> 字符串格式化
- ```python```中格式化字符串输出和```c```语言很相似,多个参数也是如此
- 模板字符串.format(分割参数)
```py
print("转换后的温度是: {:.2f}CF".format(argc))
                 此处的{}表示 槽，format中的实参会填充到 槽 中

print( "{1}:计算机{0}的cpu占用率为{2}%".format("2012-1-1","@@",10))
@@:计算机2012-1-1的cpu占用率为10%
"{}"中的槽若有参数，则按照format中实参填充，否则按照 0 1 2 ... 的默认顺序填充

槽内部的格式化配置
{ <参数序号> ：<格式控制标记> }
```

| : | <填充> | <对齐> | <宽度> | <,> | <.精度> | <类型>
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| 引导符号 | 用于填充的单个字符 | <左对齐 >右对齐 ^居中 | 槽输出宽度 | 数字的千位分隔符 | 小数精度或string长度 | 整数类型b c d o x X 浮点数类型 e,E,f,$ 

### 字符串的索引和切片

- ```python```中，字符串有```正向递增序号```和 ```反向递减序号```
- ```string[M:N:K]```, M缺失表示```至开头```, N缺失表示```至结尾```,K表示```步长```
```py
#      -10 -9  -8  -7 -6  -5  -4  -3  -2   -1
str = ["H","e","l","l","o","W","o","r","l","d"]
#       0   1   2   3   4   5   6   7   8   9

# 索引 -> 返回单个字符
print(str[9])     # "d"
print(str[-9])    # "e"

# 切片 -> 返回一段子串
print(str[1:3])     # ["e","l"]
print(str[-8:-5])   # ["l","l","o"]

# 步长
print(str[2,9,3])   #["l","W","l"]

# 逆序字符串
print(str[::-1])
# ["d","l","r","o","W","o","l","l","e","H"]
```

### string function
```py
s = "123一二三"
len(s)    # 返回 s 的长度，其值为6
str(argc) # 将 argc 转换为 string
hex(s)    # hex(425) -> "0x1a9" 转换整数s,以字符串返回16进制
oct(s)    # oct(425) -> "0o651" 转换整数s,以字符串返回8进制

chr(u)    # u 为 Unicode 编码，返回其对应的字符
ord(x)    # x 为字符，返回对应的 Unicode 编码

# 输出12星座
for i in range(12):
  print(chr(9800 + i),"\t", end="") #其中9800表示白羊座的图标
```

### string method
```py
str.lower() # 返回字符串的副本，全部字符小写 "AbcDe".lower() -> "abcde"
str.upper() # 返回字符串的副本，全部字符大写 "AbcDe".upper() -> "ABCDE"
str.split(sep=None) # 返回一个列表，"A,B,C".split(",") -> ["A","B","C"]
str.count(sub) # 返回子串sub在str中出现的次数 “Hello”.count("l") -> 2
str.replace(old,new)  # 返回str的副本，所有old字串被替换为new，"Hello".replace("e","@") -> "H@llo"
str.center(width [, fillchar])  # str 根据 width 居中，“Hello”.center(10,"=") -> "==Hello==="
str.strip(chars)    # 从str两端去掉chars，"o Helloo".strip(" o") -> "Hell"，不传参，默认去除空白符
str.join(iter)    # ",".join("Hello") -> "H,e,l,l,o"
```


## array(数组)?.list(列表)
- ```python```中列表用```[]```表示
- 运算符```in```可以用来判断其左值是否在右侧的```list```内

## eval  ->  评估函数
```eval```函数可以将字符串解析为```python```语句并执行

## loop -> 循环
```py
for i in range(3):
  print(i)

# 0 1 2
# range 这个函数表示范围，实参n表示循环到 n - 1 
# range 内的取值只能是整数
# 若参数为 range(5,8), 则输出为 5 6 7

# for ... in 可以遍历 计数，字符串，列表，文件等

while <循环条件>:
  <语句块>


# 99乘法表的输出
for i in range(9):
  for j in range(i+1):
    print(j+1, "x", "i+1", "=", (i+1) * (j+1), "\t", end="")
  print("\t")
```

### 循环的高级用法
```py
for c in s:
  <语句块>
else:
  <语句块>

- # 如果循环中没有执行```break```，则执行else的内容
- # ```else```同样使用于```while```循环
```

## float 浮点数
```py
0.1 + 0.2 == 0.3
# False
round(0.1+0.2, 1) === 0.3
# True
```

## 生成器

通过列表生成式，我们可以直接创建一个列表。但是，受到内存限制，列表容量肯定是有限的。而且，创建一个包含100万个元素的列表，不仅占用很大的存储空间，如果我们仅仅需要访问前面几个元素，那后面绝大多数元素占用的空间都白白浪费了。

所以，如果列表元素可以按照某种算法推算出来，那我们是否可以在循环的过程中不断推算出后续的元素呢？这样就不必创建完整的list，从而节省大量的空间。在Python中，这种一边循环一边计算的机制，称为生成器：generator。

要创建一个```generator```，有很多种方法。第一种方法很简单，只要把一个列表生成式的```[]```改成```()```，就创建了一个```generator```：

```python
>>> L = [x * x for x in range(10)]
>>> L
[0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
>>> g = (x * x for x in range(10))
>>> g
<generator object <genexpr> at 0x1022ef630>
```

创建L和g的区别仅在于最外层的[]和()，L是一个list，而g是一个generator。

我们可以直接打印出list的每一个元素，但我们怎么打印出generator的每一个元素呢？

如果要一个一个打印出来，可以通过next()函数获得generator的下一个返回值：

```python
>>> next(g)
0
>>> next(g)
1
>>> next(g)
4
>>> next(g)
9
>>> next(g)
16
...
64
>>> next(g)
81
>>> next(g)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
StopIteration
```

generator保存的是算法，每次调用```next(g)```，就计算出```g```的下一个元素的值，直到计算到最后一个元素，没有更多的元素时，抛出```StopIteration```的错误。

上面这种不断调用next(g)实在是太变态了，正确的方法是使用for循环，因为generator也是可迭代对象：

```python
>>> g = (x * x for x in range(10))
>>> for n in g:
...     print(n)
... 
0
1
4
9
16
25
36
49
64
81
```

创建了一个generator后，基本上永远不会调用next()，而是通过for循环来迭代它，并且不需要关心StopIteration的错误

generator非常强大。如果推算的算法比较复杂，用类似列表生成式的for循环无法实现的时候，还可以用函数来实现。

比如，著名的斐波拉契数列（Fibonacci），除第一个和第二个数外，任意一个数都可由前两个数相加得到：1, 1, 2, 3, 5, 8, 13, 21, 34, ...

斐波拉契数列用列表生成式写不出来，但是，用函数把它打印出来却很容易：

```python
def fib(max):
    n, a, b = 0, 0, 1
    while n < max:
        print(b)
        a, b = b, a + b
        n = n + 1
    return 'done'
```

上面的函数可以输出斐波那契数列的前N个数：

```python
>>> fib(6)
1
1
2
3
5
8
'done'
```

fib函数实际上是定义了斐波拉契数列的推算规则，可以从第一个元素开始，推算出后续任意的元素，这种逻辑其实非常类似generator。

上面的函数和```generator```仅一步之遥。要把fib函数变成```generator```函数，只需要把```print(b)```改为```yield b```就可以了：

```python
def fib(max):
    n, a, b = 0, 0, 1
    while n < max:
        yield b
        a, b = b, a + b
        n = n + 1
    return 'done'
```

这就是定义```generator```的另一种方法。如果一个函数定义中包含```yield```关键字，那么这个函数就不再是一个普通函数，而是一个```generator```函数，调用一个```generator```函数将返回一个```generator```：

```python
>>> f = fib(6)
>>> f
<generator object fib at 0x104feaaa0>
```

这里，最难理解的就是generator函数和普通函数的执行流程不一样。普通函数是顺序执行，遇到return语句或者最后一行函数语句就返回。而变成generator的函数，在每次调用next()的时候执行，遇到yield语句返回，再次执行时从上次返回的yield语句处继续执行。

举个简单的例子，定义一个generator函数，依次返回数字1，3，5：

```python
def odd():
    print('step 1')
    yield 1
    print('step 2')
    yield(3)
    print('step 3')
    yield(5)
```

调用该generator函数时，首先要生成一个generator对象，然后用next()函数不断获得下一个返回值：

```python
>>> o = odd()
>>> next(o)
step 1
1
>>> next(o)
step 2
3
>>> next(o)
step 3
5
>>> next(o)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
StopIteration
```

可以看到，odd不是普通函数，而是generator函数，在执行过程中，遇到yield就中断，下次又继续执行。执行3次yield后，已经没有yield可以执行了，所以，第4次调用next(o)就报错。

> 调用generator函数会创建一个generator对象，多次调用generator函数会创建多个相互独立的generator。

在循环过程中不断调用yield，就会不断中断。当然要给循环设置一个条件来退出循环，不然就会产生一个无限数列出来

同样的，把函数改成generator函数后，我们基本上从来不会用next()来获取下一个返回值，而是直接使用for循环来迭代：

```python
>>> for n in fib(6):
...     print(n)
...
1
1
2
3
5
8
```

但是用for循环调用generator时，发现拿不到generator的return语句的返回值。如果想要拿到返回值，必须捕获StopIteration错误，返回值包含在StopIteration的value中：

```python
>>> g = fib(6)
>>> while True:
...     try:
...         x = next(g)
...         print('g:', x)
...     except StopIteration as e:
...         print('Generator return value:', e.value)
...         break
...
g: 1
g: 1
g: 2
g: 3
g: 5
g: 8
Generator return value: done
```

generator是非常强大的工具，在Python中，可以简单地把列表生成式改成generator，也可以通过函数实现复杂逻辑的generator。

要理解generator的工作原理，它是在for循环的过程中不断计算出下一个元素，并在适当的条件结束for循环。对于函数改成的generator来说，遇到return语句或者执行到函数体最后一行语句，就是结束generator的指令，for循环随之结束。




## 三元运算

```py
<表达式1> if <条件> else <表达式2>
guess = eval(input())
print("猜{}了".format("对" if guess == 99 else "错"))
```

## 错误处理
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

## define function

### 函数的返回值
```py
def fact( n , m = 1):
  s = 1
  for i in range( 1, n + 1 ):
    s *= i
  return s // m , n , m

 fact( 10, 5 ) 的返回值为：
  ( 725760, 10, 5 ) 是一个元组类型
也可以写为
a , b , c = fact( 10, 5 )
print( a, b, c ) 
725760 10 5
```

### 指定参数(关键参数)
- 一般给函数传参要按照顺序，不按顺序就需要指定参数
  * 但是定义时，关键参数必须放在位置参数之后

```py
def sayHi(name,age,like="Python"):
```
调用时可以
```py
sayHi("Jack",like="C++",age=16)
```

### lambda function
- lambda 函数是一种匿名函数，使用关键字lambda定义
- 函数名是返回结果， lambda函数用于定义简单的，能够在一行内表示的函数
```py
<函数名> = lambda <参数> : <表达式>
```

### 可变参数
```py
def fn( a , *argc ):
  <函数体>
# 其中 *argc 表示可变参数,表现为元组

def fn(**kwargs):
  <函数体>
# **kwargs 表示为一个dict(字典)
```


##  set  集合
- 集合用```{}```表示，元素之间用都好分隔
- 集合中每个元素唯一，不存在相同的元素
- 集合元素之间无序
```py
A = { "python", 123, ("python", 123, ) }  # 使用{}创建集合
B = set("pypy123")  # {'1'.'p''2'.'3''y'}
```

### 集合操作符
| 集合操作符 | 描述 | 
| :---: | :---: |
| S | T | 返回一个新集合，包括在集合S和T中的所有元素| 
| S - T | 返回一个新集合，包括在集合S但不在T中的元素| 
| S & T | 返回一个新集合，包括同时在集合S和T中的元素| 
| S ^ T | 返回一个新集合，包括集合S和T中的非形同元素| 
| S <= T 或 S < T | 返回True/False，判断S和T的子集关系| 
| S >= T 或 S > T | 返回True/False，判断S和T的包含关系| 

### 集合操作符 | 描述 | 
| 集合方法 | 描述 | 
| :---: | :---: |
| S.add( x ) | 如果x不在集合S中，将x增加到S | 
| S.discard( x ) | 移除S中元素x，如果x不在集合S中，不报错 | 
| S.remove( x ) | ，移除S中元素x,如果x不在集合S中，产生KeyError异常 | 
| S.clear( x ) | 清除S中所有元素 | 
| S.pop( x ) | 随机返回S中的一个元素，更新S，若S为空产生KeyError异常 | 
| S.copy( x ) | 返回S的一个副本 | 
| len( S ) | 返回S的元素个数 | 
| x in S | 判断S中元素x，x在集合S中，返回True，否则返回False | 
| x not in S | 与 x in S 相反 | 
| set( S ) | 将其他类型变量x转变为集合类型 | 


## 序列

| 序列操作符 | 描述 | 
| :---: | :---: |
| x in s | 如果x是序列s的元素，返回True，否则返回False | 
| x not in s | 如果x是序列s的元素，返回False，否则返回True | 
| s + t | 连接两个序列s和t | 
| s * t 或 n * s | 将序列s复制n次 | 
| s[i] | 索引，返回s中的第i个元素，i是序列的序号 | 
| s[ i : j] 或 s[ i : j : k ] | 切片，返回序列s中第i到j以k为步长的元素子序列 | 

### 序列通用函数和方法
| 函数和方法 | 描述 | 
| :---: | :---: |
| len(s) | 返回序列s的长度 | 
| min(s) | 返回序列s的最小元素，s中元素需要可以比较 | 
| max(s) | 返回序列s的最大元素，s中元素需要可以比较 | 
| s.index(x) 或 s.index(x,i,j) | 返回序列s从i开始到j位置中第一次出现元素x的位置 | 
| s.count(x) | 返回序列s中出现x的总次数 | 

如何判断一个对象是可迭代对象呢？方法是通过collections.abc模块的Iterable类型判断：

```python
>>> from collections.abc import Iterable
>>> isinstance('abc', Iterable) # str是否可迭代
True
>>> isinstance([1,2,3], Iterable) # list是否可迭代
True
>>> isinstance(123, Iterable) # 整数是否可迭代
False
```

如果要对list实现类似Java那样的下标循环怎么办？Python内置的```enumerate```函数可以把一个list变成索引-元素对，这样就可以在for循环中同时迭代索引和元素本身：

```python
>>> for i, value in enumerate(['A', 'B', 'C']):
...     print(i, value)
...
0 A
1 B
2 C
```

## 元组
- 元组是一种序列类型，一旦创建就不能被修改
- 使用小括号()或tuple()创建，元素间用逗号分割
- 可以使用或不使用小括号

## 列表
- 列表是一种序列类型，创建后可以随意被修改
- 使用方括号[]或list()创建，元素间用逗号分隔
- 列表中各元素类型可以不同，无长度限制

### 列表生成式

列表生成式即*List Comprehensions*，是Python内置的非常简单却强大的可以用来创建list的生成式。

举个例子，要生成```list [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]```可以用```list(range(1, 11))```：

```python
>>> list(range(1, 11))
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```

但如果要生成```[1x1, 2x2, 3x3, ..., 10x10]```怎么做？方法一是循环：

```python
>>> L = []
>>> for x in range(1, 11):
...    L.append(x * x)
...
>>> L
[1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
```

但是循环太繁琐，而列表生成式则可以用一行语句代替循环生成上面的list：

```python
>>> [x * x for x in range(1, 11)]
[1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
```

写列表生成式时，把要生成的元素```x * x```放到前面，后面跟for循环，就可以把list创建出来，十分有用，多写几次，很快就可以熟悉这种语法。

for循环后面还可以加上if判断，这样我们就可以筛选出仅偶数的平方：

```python
>>> [x * x for x in range(1, 11) if x % 2 == 0]
[4, 16, 36, 64, 100]
```

还可以使用两层循环，可以生成全排列：

```python
>>> [m + n for m in 'ABC' for n in 'XYZ']
['AX', 'AY', 'AZ', 'BX', 'BY', 'BZ', 'CX', 'CY', 'CZ']
```

运用列表生成式，可以写出非常简洁的代码。例如，列出当前目录下的所有文件和目录名，可以通过一行代码实现：

```python
>>> import os # 导入os模块，模块的概念后面讲到
>>> [d for d in os.listdir('.')] # os.listdir可以列出文件和目录
['.emacs.d', '.ssh', '.Trash', 'Adlm', 'Applications', 'Desktop', 'Documents', 'Downloads', 'Library', 'Movies', 'Music', 'Pictures', 'Public', 'VirtualBox VMs', 'Workspace', 'XCode']
```

for循环其实可以同时使用两个甚至多个变量，比如dict的items()可以同时迭代key和value：

```python
>>> d = {'x': 'A', 'y': 'B', 'z': 'C' }
>>> for k, v in d.items():
...     print(k, '=', v)
...
y = B
x = A
z = C
```

因此，列表生成式也可以使用两个变量来生成list：

```python
>>> d = {'x': 'A', 'y': 'B', 'z': 'C' }
>>> [k + '=' + v for k, v in d.items()]
['y=B', 'x=A', 'z=C']
```

最后把一个list中所有的字符串变成小写：

```python
>>> L = ['Hello', 'World', 'IBM', 'Apple']
>>> [s.lower() for s in L]
['hello', 'world', 'ibm', 'apple']
```

###  列表类型操作函数和方法
| 函数 | 描述 | 
| :---: | :---: |
| ls[i] = x | 替换列表ls第i元素为x | 
| ls[i:j:k] = lt | 用列表lt替换ls切片后所对应元素子列表 | 
| del ls[i] | 删除列表ls中第i元素 | 
| del ls[i:j:k] | 删除列表ls中第i到第j以k为步长的元素 | 
| ls += lt | 更新列表ls，将列表lt元素增加到列表ls中 | 
| ls *= lt | 更新列表ls，将其元素重复n次 | 


| 方法 | 描述 | 
| :---: | :---: |
| ls.append( x ) | 在列表ls最后增加一个元素x | 
| ls.extend(list_2) | 将列表list_2追加到ls后面 | 
| ls.clear( x ) | 删除列表ls中所有元素 | 
| ls.copy( x ) | 生成一个新列表，赋值ls中所有元素 | 
| ls.insert( i, x ) | 在列表ls的第i位置增加元素x | 
| ls.pop( i ) | 将列表ls中第i位置元素取出并删除 | 
| ls.remove( x ) | 将列表ls中出现的第一个元素s删除 | 
| ls.reverse() | 将列表ls中的元素反转 | 
| ls.sort(key=func,reverse=bool) | key表示将ls中每个元素都传入函数，返回排序的依据<br/>reverse表示翻转 | 

```python
#根据数字大小进行排序
ls = [["a",33],["b",66],["c",11]]
r = ls.sort(key=lambda element: element[1])
print(ls)
[['c', 11], ['a', 33], ['b', 66]]
```

### 序列类型应用场景
- 元组用于元素不改变的应用场景，更多用于固定搭配的场景
- 如果不希望数据被程序改变，转换成```元组类型```
- 列表更加灵活，他是最常用的序列类型
- 最主要作用：表示一组有序数据，进而操作他们


## 字典
- 键值对： 键是数据索引的扩展
- 字典是键值对的集合，键值对之间无序
- 采用大括号{}或dict()创建，键值对用冒号：表示

### dict function or method
| 函数或方法 | 描述 | 
| :---: | :---: |
| del d[ k ] | 删除字典d中键k对应的数据值 | 
|  k in d | 判断键k是否在字典d中，存在返回True，否则返回False | 
| d.keys() | 返回字典d中所有键的信息 | 
| d.values() | 返回字典d中所有值的信息 | 
| d.items() | 返回字典d中所有键值对的信息 | 

### 列表类型操作函数和方法
| 函数或方法 | 描述 | 
| :---: | :---: |
| d.get( k, <default>) | 键k存在，则返回相应值，不在则返回<default>值 | 
| d.pop( k, <default>) | 键k存在，则取出相应值，不在则返回<default>值 | 
| d.popitem() | 随机从字典d中取出一个键值对，以元组形式返回 | 
| d.clear() | 删除所有的键值对 | 
| len( d ) | 返回字典d中元素的个数 | 


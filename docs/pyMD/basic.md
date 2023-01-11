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

## 迭代器

我们已经知道，可以直接作用于for循环的数据类型有以下几种：

- 一类是集合数据类型，如list、tuple、dict、set、str等；
- 一类是```generator```，包括生成器和带```yield```的```generator function```。

这些可以直接作用于for循环的对象统称为可迭代对象：```Iterable```。

可以使用```isinstance()```判断一个对象是否是```Iterable```对象：

```python
>>> from collections.abc import Iterable
>>> isinstance([], Iterable)
True
>>> isinstance({}, Iterable)
True
>>> isinstance('abc', Iterable)
True
>>> isinstance((x for x in range(10)), Iterable)
True
>>> isinstance(100, Iterable)
False
```

而生成器不但可以作用于for循环，还可以被```next()```函数不断调用并返回下一个值，直到最后抛出```StopIteration```错误表示无法继续返回下一个值了。

可以被```next()```函数调用并不断返回下一个值的对象称为迭代器：```Iterator```。

可以使用```isinstance()```判断一个对象是否是```Iterator```对象：

```python
>>> from collections.abc import Iterator
>>> isinstance((x for x in range(10)), Iterator)
True
>>> isinstance([], Iterator)
False
>>> isinstance({}, Iterator)
False
>>> isinstance('abc', Iterator)
False
```

生成器都是```Iterator```对象，但*list、dict、str虽然是Iterable*，却```不是Iterator```。

把*list、dict、str等Iterable* ```变成Iterator```可以使用```iter()```函数：

```python
>>> isinstance(iter([]), Iterator)
True
>>> isinstance(iter('abc'), Iterator)
True
```

为什么list、dict、str等数据类型不是Iterator？

这是因为Python的```Iterator```对象表示的是一个```数据流```，```Iterator```对象可以被```next()```函数调用并不断返回下一个数据，直到没有数据时抛出```StopIteration```错误。可以把这个数据流看做是一个有序序列，但我们却不能提前知道序列的长度，只能不断通过```next()```函数实现按需计算下一个数据，所以```Iterator```的计算是惰性的，只有在需要返回下一个数据时它才会计算。

```Iterator```甚至可以表示一个无限大的数据流，例如全体自然数。而使用*list是永远不可能存储全体自然数的*。

***

凡是可作用于for循环的对象都是```Iterable```类型；

凡是可作用于```next()```函数的对象都是```Iterator```类型，它们表示一个惰性计算的序列；

集合数据类型如*list、dict、str等是Iterable*但不是```Iterator```，不过可以通过```iter()```函数获得一个```Iterator```对象。

Python的for循环本质上就是通过不断调用next()函数实现的，例如：

```python
for x in [1, 2, 3, 4, 5]:
    pass
```

实际上完全等价于：

```python
# 首先获得Iterator对象:
it = iter([1, 2, 3, 4, 5])
# 循环:
while True:
    try:
        # 获得下一个值:
        x = next(it)
    except StopIteration:
        # 遇到StopIteration就退出循环
        break
```

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

## 高阶函数 Higher-order function

### map()

```map()```函数接收两个参数，一个是函数，一个是```Iterable```，map将传入的函数依次作用到序列的每个元素，并把结果作为新的```Iterator```返回。

我们有一个函数f(x)=x2，要把这个函数作用在一个list [1, 2, 3, 4, 5, 6, 7, 8, 9]上，就可以用map()实现如下：

```python
            f(x) = x * x

                  │
                  │
  ┌───┬───┬───┬───┼───┬───┬───┬───┐
  │   │   │   │   │   │   │   │   │
  ▼   ▼   ▼   ▼   ▼   ▼   ▼   ▼   ▼

[ 1   2   3   4   5   6   7   8   9 ]

  │   │   │   │   │   │   │   │   │
  │   │   │   │   │   │   │   │   │
  ▼   ▼   ▼   ▼   ▼   ▼   ▼   ▼   ▼

[ 1   4   9  16  25  36  49  64  81 ]
```

现在，我们用Python代码实现：

```python
>>> def f(x):
...     return x * x
...
>>> r = map(f, [1, 2, 3, 4, 5, 6, 7, 8, 9])
>>> list(r)
[1, 4, 9, 16, 25, 36, 49, 64, 81]
```

```map()```传入的第一个参数是```f```，即函数对象本身。由于结果```r是一个Iterator```，```Iterator是惰性序列```，因此通过```list()```函数让它把整个序列都计算出来并返回一个```list```。

map()作为高阶函数，事实上它把运算规则抽象了，因此，我们不但可以计算简单的f(x)=x2，还可以计算任意复杂的函数，比如，把这个list所有数字转为字符串：

```python
>>> list(map(str, [1, 2, 3, 4, 5, 6, 7, 8, 9]))
['1', '2', '3', '4', '5', '6', '7', '8', '9']
```

### reduce()

再看```reduce```的用法。```reduce```把一个函数作用在一个```序列[x1, x2, x3, ...]```上，这个函数必须接收两个参数，```reduce```把结果继续和序列的下一个元素做累积计算，其效果就是：

```python
reduce(f, [x1, x2, x3, x4]) = f(f(f(x1, x2), x3), x4)
```

比方说对一个序列求和，就可以用reduce实现：

```python
>>> from functools import reduce
>>> def add(x, y):
...     return x + y
...
>>> reduce(add, [1, 3, 5, 7, 9])
25
```

当然求和运算可以直接用Python```内建函数sum()```，没必要动用reduce。

但是如果要把序列[1, 3, 5, 7, 9]变换成整数13579，reduce就可以派上用场：

```python
>>> from functools import reduce
>>> def fn(x, y):
...     return x * 10 + y
...
>>> reduce(fn, [1, 3, 5, 7, 9])
13579
```

这个例子本身没多大用处，但是，如果考虑到字符串str也是一个序列，对上面的例子稍加改动，配合map()，我们就可以写出把str转换为int的函数：

```python
>>> from functools import reduce
>>> def fn(x, y):
...     return x * 10 + y
...
>>> def char2num(s):
...     digits = {'0': 0, '1': 1, '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7, '8': 8, '9': 9}
...     return digits[s]
...
>>> reduce(fn, map(char2num, '13579'))
13579
```

整理成一个str2int的函数就是：

```python
from functools import reduce

DIGITS = {'0': 0, '1': 1, '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7, '8': 8, '9': 9}

def str2int(s):
    def fn(x, y):
        return x * 10 + y
    def char2num(s):
        return DIGITS[s]
    return reduce(fn, map(char2num, s))
```

还可以用lambda函数进一步简化成：

```python
from functools import reduce

DIGITS = {'0': 0, '1': 1, '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7, '8': 8, '9': 9}

def char2num(s):
    return DIGITS[s]

def str2int(s):
    return reduce(lambda x, y: x * 10 + y, map(char2num, s))
```

也就是说，假设Python没有提供int()函数，你完全可以自己写一个把字符串转化为整数的函数，而且只需要几行代码！

### filter()

Python内建的```filter()```函数用于过滤序列。

和```map()```类似，```filter()```也接收一个函数和一个序列。和map()不同的是，```filter()```把传入的函数依次作用于每个元素，然后根据返回值是```True```还是```False```决定保留还是丢弃该元素。

例如，在一个list中，删掉偶数，只保留奇数，可以这么写：

```python
def is_odd(n):
    return n % 2 == 1

list(filter(is_odd, [1, 2, 4, 5, 6, 9, 10, 15]))
# 结果: [1, 5, 9, 15]
```

把一个序列中的空字符串删掉，可以这么写：

```python
def not_empty(s):
    return s and s.strip()

list(filter(not_empty, ['A', '', 'B', None, 'C', '  ']))
# 结果: ['A', 'B', 'C']
```

注意到```filter()函数返回的是一个Iterator```，也就是一个```惰性序列```，所以要强迫```filter()```完成计算结果，需要用```list()```函数获得所有结果并返回list。

***

用filter求素数

计算素数的一个方法是埃氏筛法，它的算法理解起来非常简单：

首先，列出从2开始的所有自然数，构造一个序列：

2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, ...

取序列的第一个数2，它一定是素数，然后用2把序列的2的倍数筛掉：

3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, ...

取新序列的第一个数3，它一定是素数，然后用3把序列的3的倍数筛掉：

5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, ...

取新序列的第一个数5，然后用5把序列的5的倍数筛掉：

7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, ...

不断筛下去，就可以得到所有的素数。

用Python来实现这个算法，可以先构造一个从3开始的奇数序列：

```python
def _odd_iter():
    n = 1
    while True:
        n = n + 2
        yield n
```

注意这是一个生成器，并且是一个无限序列。

然后定义一个筛选函数：

```python
def _not_divisible(n):
    return lambda x: x % n > 0
```

最后，定义一个生成器，不断返回下一个素数：

```python
def primes():
    yield 2
    it = _odd_iter() # 初始序列
    while True:
        n = next(it) # 返回序列的第一个数
        yield n
        it = filter(_not_divisible(n), it) # 构造新序列
```

这个生成器先返回第一个素数2，然后，利用filter()不断产生筛选后的新的序列。

由于```primes()```也是一个无限序列，所以调用时需要设置一个退出循环的条件

```python
# 打印1000以内的素数:
for n in primes():
    if n < 1000:
        print(n)
    else:
        break
```

注意到```Iterator是惰性计算的序列```，所以我们可以用Python表示“全体自然数”，“全体素数”这样的序列，而代码非常简洁。

### sorted()

排序也是在程序中经常用到的算法。无论使用冒泡排序还是快速排序，排序的核心是比较两个元素的大小。如果是数字，我们可以直接比较，但如果是字符串或者两个```dict```呢？直接比较数学上的大小是没有意义的，因此，比较的过程必须通过函数抽象出来。

Python内置的```sorted()```函数就可以对```list```进行排序：

```python
>>> sorted([36, 5, -12, 9, -21])
[-21, -12, 5, 9, 36]
```

```sorted()```函数也是一个高阶函数，它还可以接收一个```key```函数来实现自定义的排序，例如按绝对值大小排序：

```python
>>> sorted([36, 5, -12, 9, -21], key=abs)
[5, 9, -12, -21, 36]
```

```key```指定的函数将作用于```list```的每一个元素上，并根据```key```函数返回的结果进行排序。对比原始的list和经过```key=abs```处理过的list：

```python
list = [36, 5, -12, 9, -21]
keys = [36, 5,  12, 9,  21]
```

然后```sorted()```函数按照```keys```进行排序，并按照对应关系返回list相应的元素：

```python
keys排序结果 => [5, 9,  12,  21, 36]
                |  |    |    |   |
最终结果     => [5, 9, -12, -21, 36]
```
我们再看一个字符串排序的例子：

```python
>>> sorted(['bob', 'about', 'Zoo', 'Credit'])
['Credit', 'Zoo', 'about', 'bob']
```

默认情况下，对字符串排序，是按照ASCII的大小比较的，由于```'Z' < 'a'```，结果，大写字母Z会排在小写字母a的前面。

现在，我们提出排序应该忽略大小写，按照字母序排序。要实现这个算法，不必对现有代码大加改动，只要我们能用一个```key```函数把字符串映射为忽略大小写排序即可。忽略大小写来比较两个字符串，实际上就是先把字符串都变成大写（或者都变成小写），再比较。

这样，我们给sorted传入key函数，即可实现忽略大小写的排序：

```python
>>> sorted(['bob', 'about', 'Zoo', 'Credit'], key=str.lower)
['about', 'bob', 'Credit', 'Zoo']
```

要进行反向排序，不必改动key函数，可以传入第三个参数```reverse=True```：

```python
>>> sorted(['bob', 'about', 'Zoo', 'Credit'], key=str.lower, reverse=True)
['Zoo', 'Credit', 'bob', 'about']
```

### 装饰器

由于函数也是一个对象，而且函数对象可以被赋值给变量，所以，通过变量也能调用该函数。

```python
>>> def now():
...     print('2015-3-25')
...
>>> f = now
>>> f()
2015-3-25
```

函数对象有一个```__name__```属性（注意：是前后各两个下划线），可以拿到函数的名字：

```python
>>> now.__name__
'now'
>>> f.__name__
'now'
```

现在，假设我们要增强```now()```函数的功能，比如，在函数调用前后自动打印日志，但又不希望修改```now()```函数的定义，这种在```代码运行期间动态增加功能的方式，称之为“装饰器”```（Decorator）。

本质上，decorator就是一个返回函数的高阶函数。所以，我们要定义一个能打印日志的decorator，可以定义如下：

```python
def log(func):
    def wrapper(*args, **kw):
        print('call %s():' % func.__name__)
        return func(*args, **kw)
    return wrapper
```

观察上面的```log```，因为它是一个decorator，所以接受一个函数作为参数，并返回一个函数。我们要借助Python的@语法，把decorator置于函数的定义处：

```python
@log
def now():
    print('2015-3-25')
```

调用```now()```函数，不仅会运行```now()```函数本身，还会在运行```now()```函数前打印一行日志：

```python
>>> now()
call now():
2015-3-25
```

把```@log```放到```now()```函数的定义处，相当于执行了语句：

```python
now = log(now)
```

由于```log()```是一个decorator，返回一个函数，所以，原来的```now()```函数仍然存在，只是现在同名的```now```变量指向了新的函数，于是调用```now()```将执行新函数，即在```log()```函数中返回的```wrapper()```函数。

```wrapper()```函数的参数定义是```(*args, **kw)```，因此，```wrapper()```函数可以接受任意参数的调用。在```wrapper()```函数内，首先打印日志，再紧接着调用原始函数。

如果```decorator```本身需要传入参数，那就需要编写一个返回```decorator```的高阶函数，写出来会更复杂。比如，要自定义log的文本：

```python
def log(text):
    def decorator(func):
        def wrapper(*args, **kw):
            print('%s %s():' % (text, func.__name__))
            return func(*args, **kw)
        return wrapper
    return decorator
```

这个3层嵌套的decorator用法如下：

```python
@log('execute')
def now():
    print('2015-3-25')
```

执行结果如下：

```python
>>> now()
execute now():
2015-3-25
```

和两层嵌套的decorator相比，3层嵌套的效果是这样的：

```python
>>> now = log('execute')(now)
```

我们来剖析上面的语句，首先执行```log('execute')```，返回的是```decorator函数```，再调用返回的函数，参数是```now函数```，返回值最终是```wrapper```函数。

以上两种decorator的定义都没有问题，但还差最后一步。因为我们讲了函数也是对象，它有```__name__```等属性，但你去看经过decorator装饰之后的函数，它们的```__name__```已经从原来的```'now'```变成了```'wrapper'```：

```python
>>> now.__name__
'wrapper'
```

因为返回的那个```wrapper()```函数名字就是```'wrapper'```，所以，需要把原始函数的```__name__```等属性复制到```wrapper()```函数中，否则，有些依赖函数签名的代码执行就会出错。

不需要编写```wrapper.__name__ = func.__name__```这样的代码，Python内置的```functools.wraps```就是干这个事的，所以，一个完整的decorator的写法如下：

```python
import functools

def log(func):
    @functools.wraps(func)
    def wrapper(*args, **kw):
        print('call %s():' % func.__name__)
        return func(*args, **kw)
    return wrapper
```

或者针对带参数的decorator：

```python
import functools

def log(text):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kw):
            print('%s %s():' % (text, func.__name__))
            return func(*args, **kw)
        return wrapper
    return decorator
```

在面向对象（OOP）的设计模式中，*decorator被称为装饰模式*。OOP的装饰模式需要通过继承和组合来实现，而Python除了能支持OOP的decorator外，直接从语法层次支持decorator。Python的decorator可以用函数实现，也可以用类实现。

decorator可以增强函数的功能，定义起来虽然有点复杂，但使用起来非常灵活和方便。

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


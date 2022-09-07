## python basic
- ```python``` 的编辑器叫做 ```pycharm```
- ```python```中貌似没有基础类型，全是对象类型，其中 数字， 字符串， 元组都是不可变对象

## 注释
```py
# 这是一个注释
'''
这也
是一个
注释
'''
"""
这还
是一
个注释
"""
```
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

## string formating <-> 字符串格式化
- ```python```中格式化字符串输出和```c```语言很相似,多个参数也是如此
- 模板字符串.format(分割参数)
```py
print("转换后的温度是: {:.2f}CF".format(argc))
#                 此处的{}表示 槽，format中的实参会填充到 槽 中

print( "{1}:计算机{0}的cpu占用率为{2}%".format("2012-1-1","@@",10))
# @@:计算机2012-1-1的cpu占用率为10%
# "{}"中的槽若有参数，则按照format中实参填充，否则按照 0 1 2 ... 的默认顺序填充

# 槽内部的格式化配置
# { <参数序号> ：<格式控制标记> }

```

| : | <填充> | <对齐> | <宽度> | <,> | <.精度> | <类型>
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| 引导符号 | 用于填充的单个字符 | <左对齐 >右对齐 ^居中 | 槽输出宽度 | 数字的千位分隔符 | 小数精度或string长度 | 整数类型b c d o x X 浮点数类型 e,E,f,$ 
## 字符串的索引和切片
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

# string function
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

## string method
```py
str.lower() # 返回字符串的副本，全部字符小写 "AbcDe".lower() -> "abcde"
str.upper() # 返回字符串的副本，全部字符大写 "AbcDe".upper() -> "ABCDE"
str.split(sep=None) # 返回一个列表，"A,B,C".split(",") -> ["A","B","C"]
str.count(sub) # 返回子串sub在str中出现的次数 “Hello”.count("l") -> 2
str.replace(old,new)  # 返回str的副本，所有old字串被替换为new，"Hello".replace("e","@") -> "H@llo"
str.center(width [, fillchar])  # str 根据 width 居中，“Hello”.center(10,"=") -> "==Hello==="
str.strip(chars)    # 从str两端去掉chars，"o Helloo".strip(" o") -> "Hell"
str.join(iter)    # ",".join("Hello") -> "H,e,l,l,o"
```


## array(数组)?.list(列表)
- ```python```中列表用```[]```表示
- 运算符```in```可以用来判断其左值是否在右侧的```list```内

## eval  ->  评估函数
```eval```函数可以将字符串解析为```python```语句并执行

## for循环
```py
for i in range(3):
  print(i)

# 0 1 2
# range 这个函数表示范围，实参n表示循环到 n - 1 
# 若参数为 range(5,8), 则输出为 5 6 7

# 99乘法表的输出
for i in range(9):
  for j in range(i+1):
    print(j+1, "x", "i+1", "=", (i+1) * (j+1), "\t", end="")
  print("\t")
```

## float 浮点数
```py
0.1 + 0.2 == 0.3
# False
round(0.1+0.2, 1) ===0.3
# True
```

## time 库
```py
import time

time.time() # 时间戳
time.ctime()  # 字符串形式的可读时间
time.gmtime() # 程序处理需要的格式

time.strftime(tpl,ts)
# tpl 是格式化模板字符串 -> 定义输出结果
# ts 是计算机内部时间类型变量
t = time.gmtime()
time.strftime("%Y-%m-%d %H:%M:%S",t)
# "2022-08-07 14:40:26"   # pycharm 跑出来的时间比我本机慢 8 小时

time.strptime(str,tpl)
# str 是字符串形式的时间值
# tpl 是格式化模板字符串，用来定义输入效果 
# 和 time.strftime()  互逆


time.perf_counter() 
# 返回一个cpu级别的精确时间计数值，单位为秒
# 由于这个计数值起点不确定，连续调用差值才有意义

# time.sleep(s) # s 是休眠的时间，单位是秒，可以是浮点数
```

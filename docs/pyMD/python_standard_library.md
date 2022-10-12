# python standard library   python 标准库 

# random library
## 伪随机数： 采用梅森旋转算法生成的伪随机序列中的元素
## 随机数种子 -> 梅森旋转算法 -> 随机序列(随机序列是根据种子唯一确定的)
- random库主要用于生成随机数
- random库包括两类函数，常用共8个
```py
基本随机函数：seed() random()

扩展随机数函数：randint() getrandbits() uniform()
                randrange() choice() shuffle()
```

## 基本随机数函数
```py
seed(a = None) 
# random.seed(10) 生成种子10对应的序列
# 初始化给定的随机数种子，默认为当前系统时间

random()
# 生成一个[ 0.0 , 1.0 ) 之间的随即小数
```

## 扩展随机数函数
```py
randint( a , b)
# 生成一个 [ a, b ] 之间的整数

randrange( m , n [, k] )
# 生成一个 [ m , n ) 之间以 k 为步长的随机整数

getrandbits( k ) 
# 生成一个k比特长的随机整数

uniform( a , b)
# 生成一个 [ a , b ] 之间的随机小数

choice( seq )
# 从序列 seq 中随机选择一个元素

shuffle( seq )
# 将序列 seq 中元素随机排列，返回打乱后的序列
```

# time 库
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

## string library
```py
import string

>>> string.ascii_letters	# 打印所有字母
'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
>>> string.ascii_uppercase	# 打印大写字母
'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
>>> string.ascii_lowercase	# 打印小写字母
'abcdefghijklmnopqrstuvwxyz'
>>> string.punctuation		# 打印所有特殊字符
'!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~'
>>> string.digits			# 打印数字
'0123456789'

```

## sys

```__file__``` 返回当前脚本的绝对路径

- ```sys.path``` 模块查找路径，返回一个列表
- ```sys.argv``` 以list返回命令行调用脚本时添加的参数,list[0]为文件名

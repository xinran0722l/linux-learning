# Python 高级语法


## list
- 运算符```in```可以用来判断其左值是否在右侧的```list```内
- 列表可通过下标 -1 快速访问最后一个元素
    * `list.[-2]` 为倒数第二个元素，`list.[- len(list)]` 表示第一个元素


###  列表的函数和方法

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


### list.sort() 排序元素

`list.sort()` 执行成功后会对元素造成修改

```py
>>> cars
['bmw', 'audi', 'toyota', 'subaru']
>>> cars.sort()
>>> cars
['audi', 'bmw', 'subaru', 'toyota']
```

反向排序(逆序)

```py
>>> cars
['audi', 'bmw', 'subaru', 'toyota']
>>> cars.sort(reverse=True)
>>> cars
['toyota', 'subaru', 'bmw', 'audi']
```

### sorted() 函数

`若不想影响 list 内的元素顺序，则可使用 sorted() 函数来排序`。sorted() 函数可以按特定顺序显示列表元素，同时不影响它们在列表中的原始顺序

```py
>>> cars
['bmw', 'audi', 'toyota', 'subaru']
>>> sorted(cars)
['audi', 'bmw', 'subaru', 'toyota']
>>> cars
['bmw', 'audi', 'toyota', 'subaru']
```

`sorted()`函数同 `list.sort()` 可以逆序

```py
>>> cars
['bmw', 'audi', 'toyota', 'subaru']
>>> sorted(cars,reverse=True)
['toyota', 'subaru', 'bmw', 'audi']
>>> cars
['bmw', 'audi', 'toyota', 'subaru']
```

### list.reverse() 反转列表

`list.reverse()`并不是排序，只是反转列表元素的排列顺序。

```py
>>> cars
['bmw', 'audi', 'toyota', 'subaru']
>>> cars.reverse()
>>> cars
['subaru', 'toyota', 'audi', 'bmw']
```

虽然 `list.reverse()` 会修改列表元素的顺序，但只需再次 `list.reverse()` 即可得到最初排列的列表

```py
>>> cars
['bmw', 'audi', 'toyota', 'subaru']
>>> cars.reverse()
>>> cars
['subaru', 'toyota', 'audi', 'bmw']
>>> cars.reverse()
>>> cars
['bmw', 'audi', 'toyota', 'subaru']
```



### 添加元素

list 添加元素而方法为 `list.append()` 和 `list.insert()`

#### list.append()

```py
>>> ls
[]
>>> ls.append('C')
>>> ls.append('Java')
>>> ls.append('Python')
>>> ls

['C', 'Java', 'Python']
```

`list.append()` 可以接收任意形式的参数，如下

```py
>>> ls
['C', 'Java', 'Python']
>>>
>>> ls.append(123)
>>> ls
['C', 'Java', 'Python', 123]
>>> ls.append(['AA','bb'])
>>> ls
['C', 'Java', 'Python', 123, ['AA', 'bb']]
>>> ls.append({'k1':123,'k2':234})
>>> ls
['C', 'Java', 'Python', 123, ['AA', 'bb'], {'k1': 123, 'k2': 234}]
```

#### list.insert()

`list.insert(index,value)`需要两个参数，在 list 的 index 号位置上插入元素 value

```py
>>> ls
['C', 'Java', 'Python']
>>>
>>> ls.insert(3,'go')
>>> ls
['C', 'Java', 'Python', 'go']
>>> ls.insert(0,'c++')
>>> ls
['c++', 'C', 'Java', 'Python', 'go']
```

### 删除列表元素

删除列表内的元素有三种，分别为 `del`,`list.pop()`和`list.remove()`

#### del 

`del list[index]`,其中 index 为元素在列表中的下标

```py
>>> ls = ['apple','banana','clear','web']
>>> del ls[2]
>>> ls
['apple', 'banana', 'web']
```

#### list.pop()

`list.pop()` 执行成功，会返回删除的元素。*同 del ，需要被删除元素的下标* 

```py
>>> ls.pop()
'web'
>>> ls
['apple', 'banana']
```

#### list.remove()

`list.remove()` 无需下标，只需要将*要删除的元素传入即可* 

```sh
>>> ls
['apple', 'banana', 'clear', 'web']
>>> ls.remove('banana')
>>> ls
['apple', 'clear', 'web']
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

#### 可变参数-元组

`def fn(*argc):` 会让 Python 创建一个名为 `argc 的空元组`，并将接收的所有值存入元组中(即便只收到一个值也是如此)

```py
def make_pizza(*toppings):
    """打印顾客点的所有配料"""
    print(toppings)

make_pizza('pepperoni')
make_pizza('mushrooms','green peppers','extra cheese')
make_pizza(('aa','bb',123))
# ('pepperoni',)
# ('mushrooms', 'green peppers', 'extra cheese')
# (('aa', 'bb', 123),)
```

#### 可变参数-字典

有时候，*需要接收任意数量的实参，但预先不知道传递给函数的是怎样的信息*。这种情况下，可`将函数编写成能接收任意数量的键-值对。调用语句提供了多少就接收多少` 

下面的 `build_profile()` 函数接收名和姓，同时还接收任意数量的关键字实参

```py
def build_profile(first,last,**userinfo):
    """创建一个字典，其包含我们知道的有关用户的一切"""
    profile = {}
    profile['first_name'] = first
    profile['last_name'] = last
    for key,value in userinfo.items():
        profile[key] = value
    return profile

user_profile = build_profile("albert","einstein",
                             location='princeton',
                             field='physics')

print(user_profile)
# {'first_name': 'albert', 'last_name': 'einstein', 'location': 'princeton', 'field': 'physics'}
```




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

### 遍历字典

`dict.items()` 会返回一个键值对列表

> 遍历字典时，键值对的返回顺序和存储顺序不同。Python 不关心键值对的存储顺序，只跟踪键值对之间的关联关系

```py
user = {
    'Username': 'efermi',
    'first': 'enrico',
    'last': 'fermi',
}

for key,value in user.items():
    print(f"Current key = {key}\t value = {value}")

# Current key = Username   value = efermi
# Current key = first      value = enrico
# Current key = last       value = fermi
```

#### 遍历字典所有键

遍历字典时，默认会遍历所有键。因此，将下面代码中： `for name in favorite_languages.keys():` 替换为 `for name in favorite_languages:`，输出不会改变。显式的调用 `keys()` 方法，会让代码更容易理解

```py
favorite_languages = {
    'jen': 'python',
    'sarah': 'C',
    'edward': 'rust',
    'phil': 'java',
}

for name in favorite_languages.keys():
    print(name.title()) # str.title() 会返回字符首字母大写，其余小写的形式，不改变原 str

# Jen
# Sarah
# Edward
# Phil
```

> `dict.keys()` 并非只能用来遍历。实际上，他返回一个列表,其中包含字典中的所有键

```py
print(favorite_languages.keys())
print(favorite_languages.values())
print(favorite_languages.items())
# dict_keys(['jen', 'sarah', 'edward', 'phil'])
# dict_values(['python', 'C', 'rust', 'java'])
# dict_items([('jen', 'python'), ('sarah', 'C'), ('edward', 'rust'), ('phil', 'java')])
```

#### 排序字典的键

由于获取字典的元素时，获取顺序是不可预测的。如果要以特定顺序返回元素，一种办法是在 for 循环中对返回的键进行排序。为此，可用 `sorted()` 函数来获得按特定顺序排列的键列表的副本

```py
favorite_languages = {
    'jen': 'python',
    'sarah': 'C',
    'edward': 'rust',
    'phil': 'java',
}

for name in sorted(favorite_languages.keys()):
    print(name.title())

# Edward
# Jen
# Phil
# Sarah
```

#### 遍历字典所有值

`dict.values()` 返回字典的所有值的一个列表。由于字典的 value 不具有唯一性，所以可能出现重复，要解决这个问题可使用 `set` 集合来处理

```py
favorite_languages = {
    'jen': 'python',
    'sarah': 'C',
    'edward': 'rust',
    'phil': 'java',
}

for language in sorted(favorite_languages.values()):
    print(language.title())

# C
# Java
# Python
# Rust
```

### 字典添加元素

```py
>>> alien
{'color': 'green', 'points': 5}
>>> alien['x_position'] = 0
>>> alien['y_position'] = 25
>>> alien
{'color': 'green', 'points': 5, 'x_position': 0, 'y_position': 25}
```

### 修改字典的值

```py
>>> alien
{'color': 'green', 'points': 5, 'x_position': 0, 'y_position': 25}
>>> alien['color'] = 'yellow'
>>> alien
{'color': 'yellow', 'points': 5, 'x_position': 0, 'y_position': 25}
```

### 删除键值对

```py
>>> alien
{'color': 'yellow', 'points': 5, 'x_position': 0, 'y_position': 25}
>>> del alien['points']
>>> alien
{'color': 'yellow', 'x_position': 0, 'y_position': 25}
```


### 嵌套字典

有时候，需要将列表存储在字典中

```py
favorite_languages = {
    'jen': ['ruby','python'],
    'sarah': ['c'],
    'edward': ['rust','golang'],
    'phil': ['shell','java'],
}

for name,languages in favorite_languages.items():
    print(f"\n{name.title()}'s favorite language are: ")
    for language in languages:
        print("\t" + language.title())


# Jen's favorite language are:
#         Ruby
#         Python
# 
# Sarah's favorite language are:
#         C
# 
# Edward's favorite language are:
#         Rust
#         Golang
# 
# Phil's favorite language are:
#         Shell
#         Java
```


有时也需要在字典内嵌套字典，虽然这样做，代码可能很快复杂起来

现在以网站用户信息为例

```py
users = {
    'aeinstein':{
        "first": 'albert',
        "last": 'einstein',
        "location": 'princeton',
    },
    'mcurie': {
        'first': 'marie',
        'last': 'curie',
        'location': 'paris',
    },
}

for username,userinfo in users.items():
    print('\nUsername = ' + username)
    full_name = userinfo['first'] + " " + userinfo['last']
    location = userinfo['location']

    print('\tFull name = ' + full_name)
    print('\tLocation  = ' + location)

# Username = aeinstein
#         Full name = albert einstein
#         Location  = princeton
# 
# Username = mcurie
#         Full name = marie curie
#         Location  = paris
```

## 模块

要让函数是可导入的，首先要创建模块。`模块是扩展名为 .py 的文件`，包含要导入到程序中的代码。

### 导入模块

现在创建一个包含函数 make_pizza() 的模块

```py
> cat pizza.py
def make_pizza(size,*toppings):
    """概述要制作的披萨"""
    print("\nMaking a " + str(size) +
        ' -inch pizza with the following toppings:')
    for topping in toppings:
        print("- " + topping)
```

然后，在 pizza.py 所在目录中创建另一个名为 `making_pizzas.py` 的文件，这个文件导入刚才创建的模块，再调用 make_pizza() 两次

```py
> cat making_pizzas.py
import pizza

pizza.make_pizza(16,'pepperoni')
pizza.make_pizza(12,'mushrooms','green peppers','extra cheese')

> python making_pizzas.py

# Making a 16 -inch pizza with the following toppings:
# - pepperoni
# 
# Making a 12 -inch pizza with the following toppings:
# - mushrooms
# - green peppers
# - extra cheese
```

### 导入特定的函数

可以导入模块中特定的函数，语法如下

```py
from module_name import function_name
```

通过用逗号分隔函数名，可根据需要从模块中导入任意数量的函数

```py
from module_name import function_0,function_1,function_2
```

对于前面的 making_pizzas.py ，如果只想导入要使用的函数，可做如下更改

```py
from pizza import make_pizza

make_pizza(16,'pepperoni')
make_pizza(12,'mushrooms','green peppers','extra cheese')
```
使用这种语法，调用函数时就无需使用句点。

### 使用 as 给函数指定别名

如果要导入的函数的名称与程序中现有的名称冲突，可通过 as 来指定别名

下面给函数 `make_pizza()` 指定了别名 `mp()`。

```py
from pizza import make_pizza as mp

mp(16,'pepperoni')
mp(12,'mushrooms','green peppers','extra cheese')
```

### 使用 as 给模块指定别名

as 还可以给模块指定别名 (eg：给模块 pizza 指定别名 p)

```py
import pizza as p

p.make_pizza(16,'pepperoni')
p.make_pizza(12,'mushrooms','green peppers','extra cheese')
```

上面 import 语句给模块 pizza 指定了别名 p,`但该模块中所有函数的名称都没变`

### 导入模块中的所有函数

使用通配符可让 Python 导入模块中的所有函数

```py
from pizza import *

make_pizza(16,'pepperoni')
make_pizza(12,'mushrooms','green peppers','extra cheese')
```

> import 语句中的 * 让 Python 将模块 pizza 中的每个函数都复制到这个程序文件中。但如果导入了并非自己编写的模块时，Python 可能遇到多个名称相同的函数或变量，进而覆盖函数，而不是分别导入所有函数

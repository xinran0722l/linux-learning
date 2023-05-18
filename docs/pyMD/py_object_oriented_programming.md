# 面向对象

面向对象：将函数和数据整洁地封装起来，让开发者能够灵活而高效地使用


## 计算思维
- 逻辑思维：推理和演绎，数学为代表 A -> B B -> C A -> C
- 实证思维：实验和验证，物理为代表，引力波 <- 实验
- 计算思维：设计和构造，计算机为代表，汉诺塔递归
- 计算思维：Computational Thinking
- 抽象问题的计算过程，利用计算机自动化求解
- 计算思维是基于计算机的思维方式
- 计算思维基于计算机强大的算例及海量数据
- 抽象计算过程，关注设计和构造，而非因果

## class

现在编写一个表示汽车的类，他存储了有关汽车的信息，还有一个汇总这些信息的方法

```py
class Car():
    """一次模拟汽车的简单尝试"""

    def __init__(self, make, model,year):
        """初始化描述汽车的属性"""
        self.make = make
        self.model = model
        self.year = year

    def get_descriptive_name(self):
        """返回整洁的描述性信息"""
        long_name = str(self.year) + " " + self.make + " " + self.model
        return long_name.title()

my_new_car = Car('audi','a4',2060)
print(my_new_car)
print(my_new_car.get_descriptive_name())
# <__main__.Car object at 0x7f51022e8390>
# 2060 Audi A4
```

为了让这个类更有趣，现在给他添加一个随时间变化的属性`slef.odometer_reading`，他存储汽车的总里程，其初始值为 0,同时添加一个名为 `self.read_odometer()`的方法，用于读取汽车的里程表

```py
class Car():
    """一次模拟汽车的简单尝试"""

    def __init__(self, make, model,year):
        """初始化描述汽车的属性"""
        self.make = make
        self.model = model
        self.year = year
        self.odometer_reading = 0

    def get_descriptive_name(self):
        """返回整洁的描述性信息"""
        long_name = str(self.year) + " " + self.make + " " + self.model
        return long_name.title()

    def read_odometer(self):
        """打印一条指出汽车总里程的消息"""
        print("This car has " + str(self.odometer_reading) + " miles on it.")

my_new_car = Car('audi','a4',2060)
print(my_new_car.get_descriptive_name())
my_new_car.read_odometer()
# 2060 Audi A4
# This car has 0 miles on it.
```

里程表读数不变的汽车不多，因此我们需要一个修改该属性的值的途径

- 可以通过 3 种方式修改属性的值
    1. 直接修改属性的值 `my_new_car.odometer_reading = 2233`
    2. 通过方法修改属性的值 `my_new_car.update_odometer(2233)`
    3. 通过方法对属性的值递增 `my_new_car.increment_odometer(100)`

```py
class Car():
    """一次模拟汽车的简单尝试"""

    def __init__(self, make, model,year):
        """初始化描述汽车的属性"""
        self.make = make
        self.model = model
        self.year = year
        self.odometer_reading = 0

    def get_descriptive_name(self):
        """返回整洁的描述性信息"""
        long_name = str(self.year) + " " + self.make + " " + self.model
        return long_name.title()

    def read_odometer(self):
        """打印一条指出汽车总里程的消息"""
        print("This car has " + str(self.odometer_reading) + " miles on it.")

    def update_odometer(self, mileage):
        """将里程表读数设置为指定的值"""
        if mileage >= self.odometer_reading: #里程数不能小于当前值
            self.odometer_reading = mileage
        else:
            print("You can't roll back an odometer!!")

    def increment_odometer(self, miles):
        """将里程表读数增加指定的量"""
        self.odometer_reading = miles
```

### 导入类

首先创建一个只包含 Car 类的模块，命名为 car.py

```py
"""一个可用于表示汽车的类"""
class Car():
    """一次模拟汽车的简单尝试"""

    def __init__(self, make, model,year):
        """初始化描述汽车的属性"""
        self.make = make
        self.model = model
        self.year = year
        self.odometer_reading = 0

    def get_descriptive_name(self):
        """返回整洁的描述性信息"""
        long_name = str(self.year) + " " + self.make + " " + self.model
        return long_name.title()

    def read_odometer(self):
        """打印一条指出汽车总里程的消息"""
        print("This car has " + str(self.odometer_reading) + " miles on it.")

    def update_odometer(self, mileage):
        """将里程表读数设置为指定的值"""
        if mileage >= self.odometer_reading: #里程数不能小于当前值
            self.odometer_reading = mileage
        else:
            print("You can't roll back an odometer!!")

    def increment_odometer(self, miles):
        """将里程表读数增加指定的量"""
        self.odometer_reading = miles
```

在另一个 my_car.py 的文件中导入 Car 类并创建实例

```py
> cat my_car.py
from car import Car

my_new_car = Car('audi','a4',2060)
print(my_new_car.get_descriptive_name()) #2060 Audi A4

my_new_car.odometer_reading = 23
my_new_car.read_odometer() # This car has 23 miles on it.
```

> 导入类是一种有效的编程方式。如果在这个程序中包含整个 Car 类，它会很长！铜鼓导入，使得主程序文件变得整洁而易于阅读。这能让人将大部分逻辑存储在独立的文件中;确定类像你希望的那样工作后，就可以不管这些文件，而专注于主程序的逻辑了


### 构造方法

- Python类中可以使用```__init__()```方法(构造方法)
    * 在创建类对象(构造类)的时候，会自动执行
    * 在创建类对象(构造类)的时候，将传入参数自动传递给___init__方法使用

```python
#使用构造方法对成员变量进行赋值
#构造方法的名称__init__
class Student:
    由于使用了__init__(),所以下3行可以不用
    # name = None
    # age = None
    # tel = None
    
    # 实例化类的时候，__init__()内的语句被自动执行
    def __init__(self,name,age,tel):
        self.name = name
        self.age = age
        self.tel = tel
        print("Student Class 创建了一个类对象")

s1 = Student("alex",22,"123321")
#Student Class 创建了一个类对象
```
### 魔术方法

```python
class Student:
    #构造方法，用于创建类对象的时候设置初始化行为
    def __init__(self,name,age):
        self.name = name
        self.age = age

    #实现类对象转字符串的行为
    def __str__(self):
        return f"Student类对象，name:{self.name},age:{self.age}"

    #用于2个类对象进行小于或大于比较
    def __lt__(self,other):
        return self.age < other.age

    #用于2个类对象进行小于等于或大于等于比较
    def __le__(self,other):
        return self.age <= other.age

    #用于2个类对象进行相等比较
    def __eq__(self,other):
        return self.age == other.age

stu = Student("alex",88)
# 位使用__str__ 之前，会输出地址
print(stu)
print(str(stu))
# <__main__.Student object at 0x7f2fd3f5ffa0>
# <__main__.Student object at 0x7f2fd3f5ffa0>
#增加了__str__后，输出自定义
print(stu)
print(str(stu))
# Student类对象，name:alex,age:88
# Student类对象，name:alex,age:88

# __lt__
s1 = Student("jira",23)
s2 = Student("tom",45)
print(s1 < s2)
print(s1 > s2)
# True
# False

#__le__
s1 = Student("jira",23)
s2 = Student("tom",45)
s3 = Student("ak",45)
print(s1 <= s2 and s2 >= s3)
print(s1 >= s2)
print(s2 >= s3 >= s1)
# True
# False
# True

#__eq__
s1 = Student("jira",23)
s2 = Student("tom",23)
print(s1 == s2)
print(s1 >= s2)
# True
# True
```

## 封装

- 类中提供了私有成员的形式来支持
    * 私有成员变量
    * 私有成员方法
- 定义私有成员的方式：
    * 私有变量：变量名以__开头(2个下划线)
    * 私有方法：变方名以__开头(2个下划线)

外部无法访问类中的私有成员，私有成员```仅供类内部使用```

```python

class Phton:

    #当前手机运行电压
    __current_voltage = None

    def __keep_single_core(self):
        print("让CPU以单核模式运行")

    #内部调用私有成员
    def call_by_5g(self):
        if self.__current_voltage > 2:
            print("5G通话以开启")
        else:
            self.__keep_single_core()
            print("电量不足，无法使用5G通话，已设置单核模式")


p = Phton()

print(p.__current_voltage)
# 'Phton' object has no attribute '__current_voltage'
p.__keep_single_core()
# 'Phton' object has no attribute '__keep_single_core'

p.call_by_5g()
# 5G通话以开启
# 让CPU以单核模式运行
# 电量不足，无法使用5G通话，已设置单核模式
```
## 继承

- 单继承(一个子类继承一个父类)

```python
class Phone:
    IMEI = 123
    producer = "Apple"

    def call_by_4g(self):
        print("4g通话")

class Phone_new(Phone):
    face_id = "853"

    def call_by_5g(self):
        print("5g通话")

p = Phone_new()
print(p.face_id)
print(p.IMEI)
print(p.producer)
p.call_by_4g()
p.call_by_5g()
# 853
# 123
# Apple
# 4g通话
# 5g通话
```

### 多继承(一个子类继承多个父类)
    * 多继承中，如果多个父类的属性相同，则```左边的父类优先级最高```

```python
class Phone:
    IMEI = 123
    producer = "Apple"

    def call_by_4g(self):
        print("4g通话")

# class Phone_new(Phone):
#     face_id = "853"
#     def call_by_5g(self):
#         print("5g通话")

class NFCReader:
    nfc_type = "第五代NFC"
    producer = "Banana"
    def read_card(self):
        print("NFC读卡")
    def write_card(self):
        print("NFC写卡")

class RemoteControl:
    rc_type = "红外遥控"
    def control(self):
        print("红外遥控启动")

#class MyPhone(Phone,Phone_new,NFCReader,RemoteControl):
class MyPhone(Phone,NFCReader,RemoteControl):
    #不再MyPhone中添加成员，所以用pass
    pass

p = MyPhone()
p.call_by_4g()  # 4g通话
p.read_card()   # NFC读卡
p.write_card()  # NFC写卡
print(p.nfc_type)   # 第五代NFC
print(p.producer)   # Apple
print(p.rc_type)    # 红外遥控
p.control() # 红外遥控启动
# p.call_by_5g()
```

### 复写父类成员

```python
class Phone:
    producer = "Apple"
    def call_by_5g(self):
        print("使用5g通话")

class MyPhone(Phone):
    producer = "Meta"

    def call_by_5g(self):
        print("开启CPU单核")
        #不使用父类的成员
        # print("使用5g通话")
        #方式一 调用父类成员
        # print(f"父类的厂商是{Phone.producer}")
        # Phone.call_by_5g(self)
        #方式二 调用父类成员
        print(f"父类的厂商是{super().producer}")
        super().call_by_5g()
        print("关闭CPU单核")

p = MyPhone()
```
对父类的成员重新定义
```python
p.call_by_5g()
print(p.producer)
# 开启CPU单核
# 使用5g通话
# 关闭CPU单核
# Meta
```
访问父类成员--通过*父类.成员*形式，若是父类方法，则*父类.方法(self)*
```python
p.call_by_5g()
print(p.producer)
# 开启CPU单核
# 父类的厂商是Apple
# 使用5g通话
# 关闭CPU单核
# Meta
```
访问父类成员--通过*super().成员*形式，调用父类方法不传入*self*
```python 
p.call_by_5g()
print(p.producer)
# 开启CPU单核
# 父类的厂商是Apple
# 使用5g通话
# 关闭CPU单核
# Meta
```


## 获取对象信息

当我们得到一个对象的引用时，如何知道这个对象的类型，有哪些方法？

### isinstance 判断是否为某个class的实例

```python
isinstance( object, classinfo )
# object 实例对象
# classinfo 直接或间接类名、基本类型或由它们组成的元组
```

```python
print(isinstance(p,Phone))      #True
print(isinstance(p,(Phone,MyPhone)))    #True
```

由于 p 的 class (MyPhone) 继承自 Phone,所以上面个为True

但是反过来确不行

```bash
p = MyPhone()
print(isinstance(ip,MyPhone))   # False
```

能用 type() 判断的基本类型也可以用 isinstance() 判断

```python
print(isinstance(123,int))
print(isinstance("abc",str))
print(isinstance([],list))
True
True
True
```

### dir() 获得对象的所有属性和方法

```python
print( dir("abc") )
print("#".center(20,"-"))
print( dir(123) )
print("#".center(20,"-"))
print( dir([]) )
['__add__', '__class__', '__contains__', '__delattr__', '__dir__', '__doc__', '__eq__', '__format__', '__ge__', '__getattribute__', '__getitem__', '__getnewargs__', '__gt__', '__hash__', '__init__', '__init_subclass__', '__iter__', '__le__', '__len__', '__lt__', '__mod__', '__mul__', '__ne__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__rmod__', '__rmul__', '__setattr__', '__sizeof__', '__str__', '__subclasshook__', 'capitalize', 'casefold', 'center', 'count', 'encode', 'endswith', 'expandtabs', 'find', 'format', 'format_map', 'index', 'isalnum', 'isalpha', 'isascii', 'isdecimal', 'isdigit', 'isidentifier', 'islower', 'isnumeric', 'isprintable', 'isspace', 'istitle', 'isupper', 'join', 'ljust', 'lower', 'lstrip', 'maketrans', 'partition', 'removeprefix', 'removesuffix', 'replace', 'rfind', 'rindex', 'rjust', 'rpartition', 'rsplit', 'rstrip', 'split', 'splitlines', 'startswith', 'strip', 'swapcase', 'title', 'translate', 'upper', 'zfill']
---------#----------
['__abs__', '__add__', '__and__', '__bool__', '__ceil__', '__class__', '__delattr__', '__dir__', '__divmod__', '__doc__', '__eq__', '__float__', '__floor__', '__floordiv__', '__format__', '__ge__', '__getattribute__', '__getnewargs__', '__gt__', '__hash__', '__index__', '__init__', '__init_subclass__', '__int__', '__invert__', '__le__', '__lshift__', '__lt__', '__mod__', '__mul__', '__ne__', '__neg__', '__new__', '__or__', '__pos__', '__pow__', '__radd__', '__rand__', '__rdivmod__', '__reduce__', '__reduce_ex__', '__repr__', '__rfloordiv__', '__rlshift__', '__rmod__', '__rmul__', '__ror__', '__round__', '__rpow__', '__rrshift__', '__rshift__', '__rsub__', '__rtruediv__', '__rxor__', '__setattr__', '__sizeof__', '__str__', '__sub__', '__subclasshook__', '__truediv__', '__trunc__', '__xor__', 'as_integer_ratio', 'bit_count', 'bit_length', 'conjugate', 'denominator', 'from_bytes', 'imag', 'numerator', 'real', 'to_bytes']
---------#----------
['__add__', '__class__', '__class_getitem__', '__contains__', '__delattr__', '__delitem__', '__dir__', '__doc__', '__eq__', '__format__', '__ge__', '__getattribute__', '__getitem__', '__gt__', '__hash__', '__iadd__', '__imul__', '__init__', '__init_subclass__', '__iter__', '__le__', '__len__', '__lt__', '__mul__', '__ne__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__reversed__', '__rmul__', '__setattr__', '__setitem__', '__sizeof__', '__str__', '__subclasshook__', 'append', 'clear', 'copy', 'count', 'extend', 'index', 'insert', 'pop', 'remove', 'reverse', 'sort']
```

类似```__xxx__```的属性和方法在Python中都是有特殊用途的，比如```__len__```方法返回长度。在Python中，如果你调用```len()```函数试图获取一个对象的长度，实际上，在```len()```函数内部，它自动去调用该对象的```__len__()```方法，所以，下面的代码是等价的：

```python
len("abc")  # 3
"abc".__len__() # 3
```

仅仅把属性和方法列出来是不够的，配合```getattr()```、```setattr()```以及```hasattr()```，我们可以直接操作一个对象的状态：

```python
class MyObject(object):
    def __init__(self):
        self.x = 9

    def power(self):
        return self.x * self.x

obj = MyObject()

# obj上有属性 x 吗？
print(hasattr(obj,"x")) # True
# obj上有属性 y 吗？
print(hasattr(obj,"y")) # False
# 为obj设置一个属性 y
print(setattr(obj,"y",19))  # None
# obj上有属性 y 吗？
print(hasattr(obj,"y")) # True
# 获取 obj 的属性 y
print(getattr(obj,'y')) # 19
print(obj.y)    # 19
```

如果试图获取不存在的属性，会抛出AttributeError错误

```python
getattr(obj,'z')
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: 'MyObject' object has no attribute 'z'
```

可以传入一个 default 参数，如果属性不存在，就返回默认值

```python
print(getattr(obj,'z',"Not Found 404"))     # Not Found 404
print(hasattr(obj,'z')) # False
```

也可以获得对象的方法

```python
# 有属性 power 吗
print(hasattr(obj,"power")) # True
# 获得属性 power
print(getattr(obj,'power')) # <bound method MyObject.power of <__main__.MyObject object at 0x7fd2de057fd0>>
# 获得属性 power, 并赋值给 fn
fn = getattr(obj,"power")
# fn 指向 obj.power
print(fn)   # <bound method MyObject.power of <__main__.MyObject object at 0x7fd2de057fd0>>
# 调用 fn
print(fn()) # 81
```

## 实例属性和类属性

由于Python是动态语言，根据类创建的实例可以任意绑定属性。给实例绑定属性的方法是通过实例变量，或者通过self变量：

```python
class Stu(object):

    def __init__(self,name):
        self.name = name

s = Stu("Bob")
print(s)    # <__main__.Stu object at 0x7f96a6457fd0>
print(s.name) # Bob
print(dir(s))
# ['__class__', '__delattr__', '__dict__', '__dir__', '__doc__', '__eq__', '__format__', '__ge__', '__getattribute__', '__gt__', '__hash__', '__init__', '__init_subclass__', '__le__', '__lt__', '__module__', '__ne__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__sizeof__', '__str__', '__subclasshook__', '__weakref__', 'name']
s.core = 90
print(s.core) # 90
print(dir(s))
# ['__class__', '__delattr__', '__dict__', '__dir__', '__doc__', '__eq__', '__format__', '__ge__', '__getattribute__', '__gt__', '__hash__', '__init__', '__init_subclass__', '__le__', '__lt__', '__module__', '__ne__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__sizeof__', '__str__', '__subclasshook__', '__weakref__', 'core', 'name']
```

如果 Stu 类本身需要绑定一个属性，可以直接在 class 类中定义属性，这种属性是类属性，归 Stu 类所有

```python
class Stu(object):
    name = "Student"
```

当我们定义了一个类属性后，这个属性虽然归类所有，但类的所有实例都可以访问到。来测试一下：

```python
class Stu(object):

    name = "Student"

    def __init__(self,age):
        self.age = age

s = Stu(33)
print(s.name)   # Student
print(Stu.name) # Student
s.name = "Rich"
print(s.name)   # Rich
print(Stu.name) # Student
del s.name
print(Stu.name) # Student
```

从上面的例子可以看出，在编写程序的时候，千万不要对实例属性和类属性使用相同的名字，因为相同名称的实例属性将屏蔽掉类属性，但是当你删除实例属性后，再使用相同的名称，访问到的将是类属性。

***

练习：为了统计学生人数，可以给Student类增加一个类属性，每创建一个实例，该属性自动增加：

```python
class Student(object):
    count = 0

    def __init__(self, name):
        self.name = name
        Student.count += 1

    def getCount(self):
        return self.count

for i in range(3):
    s = Student(f"I'm student the {i} ")
    print(s.name)

print(s.getCount()) # 此处直接调用 s.count亦可
# I'm student the 0 
# I'm student the 1 
# I'm student the 2 
# 3
```



## 类型注解

类型注解是通过IDE对数据类型进行显式说明
```python 
#基础类型注解
v1: int = 10
v2: str = "string"
v3: bool = True

#对象类型注解
class Student:
    pass
stu: Student = Student()

#基础容器类型注解
ls: list = [1,2,3]
tp: tuple = (1,2,3)
dt: dict = {"it":555}

#容器类型详细注解
my_list: list[int] = [1,3,6]
my_tuple: tuple[int,str,bool] = (2,"cc",False)
my_dict: dict[str,int] = {"jira":333}


#在注释中进行注解
def func():
    return 10
fn = func() #type: int

import random
var1 = random.randint(1,10) # type:int
import json
var2 = json.loads('{"name":"alex"}')    # type: dict[str,str]

#对函数型参注解
# def func(型参: 类型,型参: 类型) -> 返回值类型 :
def add(x: int, y: int):
    return x + y

#对函数返回值注解
def func(data: list) -> int:
    return 18
```
- Union联合注解

```python 
from typing import Union

my_ls: list[Union[int, str]] = [1, 2, "alex", "ak"]

def fn(data: Union[int, str]) -> Union[int, str]:
    pass
```

## 多态

多态指```多重状态，即完成某个行为时，使用不同的对象会得到不同的状态```

同样的行为(函数),传入不同的对象，得到不同的状态

以父类做声明，以子类做实际工作，获得同一行为，不同状态

- 什么是多态？
    * 同样的行为(函数),传入不同的对象，得到不同的状态
    * 定义函数(方法),通过类型注解声明需要父类对象，```实际传入子类对象```进行工作，从而获得不同的工作状态
- 什么是抽象类(接口)?
    * 包含抽象方法的类，称为抽象类。
    * 抽象方法指：```没有具体实现的方法(pass)```
- 抽象类的作用
    * 多用于做*顶层设计(```设计标准```)*,以便子类做具体实现
    * 也是对子类的一种软性约束，要求子类必须复写(实现)父类的一些方法,配合多态，获得不同的状态
    

```python 
#演示多态
class Animal:
    def speak():
        pass

class Dog(Animal):
    def speak(self):
        print("汪汪汪")

class Cat(Animal):
    def speak(self):
        print("喵喵喵")

def make_noise(animal: Animal):
    animal.speak()

cat = Cat()
dog = Dog()

make_noise(cat)
make_noise(dog)
# 喵喵喵
# 汪汪汪
```

```python
# 抽象类
class AC:
    def cool_wind(self):
        """制冷"""
        pass
    def hot_wind(self):
        """制热"""
        pass
    def swing_l_r(self):
        """左右摆风"""
        pass

class Midea_AC(AC):
    def cool_wind(self):
        print("美的空调制冷")
        """制冷"""
    def hot_wind(self):
        print("美的空调制热")
        """制热"""
    def swing_l_r(self):
        print("美的空调左右摆风")
        """左右摆风"""

class GREE_AC(AC):
    def cool_wind(self):
        print("格力空调制冷")
        """制冷"""
    def hot_wind(self):
        print("格力空调制热")
        """制热"""
    def swing_l_r(self):
        print("空格力调左右摆风")
        """左右摆风"""

def make_cool(ac:AC):
    ac.cool_wind()

midea_ac = Midea_AC()
gree_ac = GREE_AC()

make_cool(midea_ac)
make_cool(gree_ac)
# 美的空调制冷
# 格力空调制冷
```

## 闭包
```python
def outer(logo):

    def inner(msg):
        print(f"<{logo}>{msg}<{logo}>")

    return inner

fn1 = outer("super man")
fn1("jira")
# <super man>jira<super man>
```
- 使用nonlocal关键字修改外部函数的值

```python
def outer(n1):

    def inner(n2):
        nonlocal n1
        n1 += n2
        print(n1)

    return inner

fn1 = outer(10)
fn1(2)  # 12
fn1(1)  # 13
fn1(3)  # 16
```
***

- 闭包小案例

```python
def atm(account=0):

    def atm_calc(num,deposit=True):
        nonlocal account
        if deposit:
            account += num
            print(f"存款：{num},账户余额：{account}")
        else:
            account -= num
            print(f"取款:{num}, 账户余额:{account}")

    return atm_calc

my = atm(100)
my(100) # 存款：100,账户余额：200
my(200) # 存款：200,账户余额：400
my(100,False)   # 取款:100, 账户余额:300
```

## 装饰器

装饰器也是一种闭包，其功能是```在不破坏目标函数原有的代码和功能的前提下，为目标函数增加新功能```

- 基础写法

```python
def outer(func):
    def inner():
        print("睡觉了")
        func()
        print("起床了")

    return inner

def sleep():
    import random
    import time
    print("睡眠中".center(20,"-"))
    time.sleep(random.randint(1,3))

fn = outer(sleep)
fn()
```

- 语法糖

```python
def outer(func):
    def inner():
        print("睡觉了")
        func()
        print("起床了")

    return inner

@outer
def sleep():
    import random
    import time
    print("睡眠中".center(20,"-"))
    time.sleep(random.randint(1,3))

sleep()
```



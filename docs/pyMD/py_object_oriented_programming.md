# 计算思维
- 逻辑思维：推理和演绎，数学为代表 A -> B B -> C A -> C
- 实证思维：实验和验证，物理为代表，引力波 <- 实验
- 计算思维：设计和构造，计算机为代表，汉诺塔递归
- 计算思维：Computational Thinking
- 抽象问题的计算过程，利用计算机自动化求解
- 计算思维是基于计算机的思维方式
- 计算思维基于计算机强大的算例及海量数据
- 抽象计算过程，关注设计和构造，而非因果

## class

#### 构造方法

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
#### 魔术方法

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

- 多继承(一个子类继承多个父类)
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

## 复写父类成员

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

#### 类型注解

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

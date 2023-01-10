# 面向对象高级

## 使用 ```__slots__```

正常情况下，当我们定义了一个class，创建了一个class的实例后，我们可以给该实例绑定任何属性和方法，这就是动态语言的灵活性。先定义class：

```python
class Student(object):
    pass
```

然后，尝试给实例绑定一个属性：

```python
s = Student()
s.name = "Rich"
print(s.name) # Rich
```

还可以给实例绑定一个方法

```python
def set_age(self,age):
    self.age = age

from types import MethodType
s.set_age = MethodType(set_age,s) # 给实例绑定一个方法
s.set_age(25)
 print(s.age)
# Rich
# 25

# 另一种方法
s.set_age = set_age
s.set_age(s,13)
print(s.age)
# Rich
# 13
```

但是，给一个实例绑定的方法，对另一个实例是不起作用的：

```python
s2 = Student() # 创建新的实例
s2.set_age(25) # 尝试调用方法
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: 'Student' object has no attribute 'set_age'
```

为了给所有实例都绑定方法，可以给class绑定方法：

```python
def set_score(self,score):
    self.score = score

Student.set_score = set_score # 在这之前的实例不存在set_score方法

s3 = Student()
s3.set_score(88)
print(s3.score) # 88
```

通常情况下，上面的*set_score*方法可以直接定义在class中，但动态绑定允许我们在程序运行的过程中动态给class加上功能，这在静态语言中很难实现。

但是，如果我们想要限制实例的属性怎么办？比如，只允许对```Student```实例添加```name```和```age```属性。

为了达到限制的目的，Python允许在定义```class```的时候，定义一个特殊的```__slots__```变量，来限制该class实例能添加的属性：

```python
class Student(object):
    __slots__=("name","age") # 用tuple 定义允许绑定的属性名称
```

```python
s = Student() # 创建新的实例
s.name = 'Michael' # 绑定属性'name'
s.age = 25 # 绑定属性'age'
s.score = 99 # 绑定属性'score'
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: 'Student' object has no attribute 'score'
```

由于```score```没有被放到```__slots__```中，所以不能绑定```score```属性，试图绑定```score```将得到```AttributeError```的错误。

使用```__slots__```要注意，```__slots__```定义的属性仅对当前类实例起作用，对继承的子类是不起作用的：

```python
class GraduateStudent(Student):
    pass

g = GraduateStudent()
g.score = 9999  # 正常执行
```

除非在子类中也定义```__slots__```，这样，子类实例允许定义的属性就是自身的```__slots__```加上父类的```__slots__```。

## 使用 @property

在绑定属性时，如果我们直接把属性暴露出去，虽然写起来很简单，但是，没办法检查参数，导致可以把成绩随便改：

```python
s = Student()
s.score = 9999
```

这显然不合逻辑。为了限制score的范围，可以通过一个```set_score()```方法来设置成绩，再通过一个```get_score()```来获取成绩，这样，在```set_score()```方法里，就可以检查参数：

```python
class Student(object):

    def get_score(self):
         return self._score

    def set_score(self, value):
        if not isinstance(value, int):
            raise ValueError('score must be an integer!')
        if value < 0 or value > 100:
            raise ValueError('score must between 0 ~ 100!')
        self._score = value
```

现在，对任意的Student实例进行操作，就不能随心所欲地设置score了：

```python
s = Student()
s.set_score(60) # ok!
s.get_score() # 60
s.set_score(9999)
Traceback (most recent call last):
  ...
ValueError: score must between 0 ~ 100!
```

但是，上面的调用方法又略显复杂，没有直接用属性这么直接简单。

```装饰器```（decorator）可以给函数动态加上功能。对于类的方法，装饰器一样起作用。Python内置的```@property```装饰器就是负责把一个方法变成属性调用的：

```python
class Student(object):

    @property
    def score(self):
        return self._score

    @score.setter
    def score(self, value):
        if not isinstance(value, int):
            raise ValueError('score must be an integer!')
        if value < 0 or value > 100:
            raise ValueError('score must between 0 ~ 100!')
        self._score = value
```

```@property```的实现比较复杂，我们先考察如何使用。把一个```getter方```法变成属性，只需要加上```@property```就可以了，此时，```@property```本身又创建了另一个装饰器```@score.setter```，负责把一个```setter```方法变成属性赋值，于是，我们就拥有一个可控的属性操作：

```python
s = Student()
s.score = 60 # OK，实际转化为s.set_score(60)
s.score # OK，实际转化为s.get_score()
# 60
s.score = 9999
Traceback (most recent call last):
  ...
ValueError: score must between 0 ~ 100!
```

注意到这个神奇的```@property```，我们在对实例属性操作的时候，就知道该属性很可能不是直接暴露的，而是通过```getter```和```setter```方法来实现的。

还可以定义只读属性，只定义```getter```方法，不定义```setter方```法就是一个只读属性：

```python
class Student(object):

    @property
    def birth(self):
        return self._birth

    @birth.setter
    def birth(self, value):
        self._birth = value

    @property
    def age(self):
        return 2015 - self._birth
```

上面的```birth```是可读写属性，而```age```就是一个```只读```属性，因为```age```可以根据birth和当前时间计算出来。

要特别注意：属性的方法名不要和实例变量重名。例如，以下的代码是错误的：

```python
class Student(object):

    # 方法名称和实例变量均为birth:
    @property
    def birth(self):
        return self.birth
```

这是因为调用```s.birth```时，首先转换为方法调用，在执行r```eturn self.birth```时，又视为访问```self```的属性，于是又转换为方法调用，造成无限递归，最终导致栈溢出报错```RecursionError```。

### 练习

利用@property给一个Screen对象加上width和height属性，以及一个只读属性resolution：

```python
class Screen(object):

    @property
    def width(self):
        return self._width
    @width.setter
    def width(self, value):
        self._width = value

    @property
    def height(self):
        return self._height
    @height.setter
    def height(self, value):
        self._height = value
    
    @property
    def resolution(self):
        self._resolution = 332
        return self._resolution

s = Screen()
s.width = 1024
s.height = 768
print("resolution = ",s.resolution)
print("Test Success")
print(f"width = {s.width}")
print(f"height = {s.height}")
# resolution =  332
# Test Success
# width = 1024
# height = 768
```

## 定制类

看到类似```__slots__```这种形如```__xxx__```的变量或者函数名就要注意，这些在Python中是有特殊用途的。

Python的class中还有许多这样有特殊用途的函数，可以帮助我们定制类。

### \_\_str\_\_

我们先定义一个Student类，打印一个实例：

```python
class Student(object):

    def __init__(self,name):
        self.name = name

print(Student("Rich"))
# <__main__.Student object at 0x7fdf51f5bf10>
```

打印出一堆<__main__.Student object at 0x109afb190>，不好看。只需要定义好__str__()方法，返回一个好看的字符串就可以了：

```python
class Student(object):

    def __init__(self,name):
        self.name = name

    def __str__(self):
        return f"Student object (name: {self.name})"

print(Student("Rich"))
# Student object (name: Rich)
```

如果直接敲变量不用print，打印出来的实例还是不好看

```python
>>> s = Student('Michael')
>>> s
# <__main__.Student object at 0x109afb310>
```

这是因为直接显示变量调用的不是```__str__()```，而是```__repr__()```，两者的区别是```__str__()```返回用户看到的字符串，而```__repr__()```返回程序开发者看到的字符串，也就是说，```__repr__()```是为调试服务的。

### \_\_repr\_\_

解决办法是再定义一个```__repr__()```。但是通常```__str__()```和```__repr__()```代码都是一样的，所以，有个偷懒的写法：

```python
class Student(object):
    def __init__(self, name):
        self.name = name
    def __str__(self):
        return 'Student object (name=%s)' % self.name
    __repr__ = __str__
```

### \_\_iter\_\_

如果一个类想被用于```for ... in```循环，类似```list```或```tuple```那样，就必须实现一个```__iter__()```方法，该方法返回一个迭代对象，然后，Python的for循环就会不断调用该迭代对象的```__next__()```方法拿到循环的下一个值，直到遇到```StopIteration```错误时退出循环。

我们以斐波那契数列为例，写一个Fib类，可以作用于for循环：

```python
class Fib(object):

    def __init__(self):
        self.a,self.b = 0,1

    def __iter__(self):
        return self

        def __next__(self):
            self.a,self.b = self.b,self.a+self.b
            if self.a > 50:
            raise StopIteration()
            return self.a

for fib in Fib(): 
    print(fib)

# 1
# 2
# 3
# 5
# 8
# 13
# 21
# 34
```

### \_\_getitem\_\_

Fib实例虽然能作用于for循环，看起来和list有点像，但是，把它当成list来使用还是不行，比如，取第5个元素：

```bash
Fib()[5]
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: 'Fib' object does not support indexing
```

要表现得像```list```那样按照下标取出元素，需要实现```__getitem__()```方法：

```python
class Fib(object):
    def __getitem__(self,n):
        a,b = 1,1
        for x in range(n):
            a,b = b,a+b
        return a

f = Fib()
print(f[0])
print(f[1])
print(f[3])
print(f[4])
print(f[10])
# 1
# 1
# 3
# 5
# 89
```

现在，就可以按下标访问数列的任意一项了：

但是list有个神奇的切片方法：

```python
list(range(100))[5:10]
[5, 6, 7, 8, 9]
```
对于*Fib*却报错。原因是```__getitem__()```传入的参数可能是一个```int```，也可能是一个切片对象```slice```，所以要做判断：

```python
class Fib(object):
    def __getitem__(self, n):
        if isinstance(n, int): # n是索引
            a, b = 1, 1
            for x in range(n):
                a, b = b, a + b
            return a
        if isinstance(n, slice): # n是切片
            start = n.start
            stop = n.stop
            if start is None:
                start = 0
            a, b = 1, 1
            L = []
            for x in range(stop):
                if x >= start:
                    L.append(a)
                a, b = b, a + b
            return L
```

现在试试Fib的切片：

```python
f = Fib()
print(f[0:5])
# [1, 1, 2, 3, 5]
print(f[:10])
# [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]
```

但是没有对step参数作处理：

```python
f[:10:2]
[1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89]
```

也没有对负数作处理，所以，要正确实现一个```__getitem__()```还是有很多工作要做的。

此外，如果把对象看成```dict```，```__getitem__()```的参数也可能是一个可以作```key```的```object```，例如```str```。

总之，通过上面的方法，我们自己定义的类表现得和Python自带的list、tuple、dict没什么区别，这完全归功于动态语言的“鸭子类型”，不需要强制继承某个接口。

### \_\_getattr\_\_

正常情况下，当我们调用类的方法或属性时，如果不存在，就会报错。比如定义Student类：

```python
class Student(object):
    
    def __init__(self):
        self.name = 'Michael'
```

调用*name*属性，没问题，但是，调用不存在的*score*属性，就有问题了：

```python
>>> s = Student()
>>> print(s.name)
Michael
>>> print(s.score)
Traceback (most recent call last):
  ...
AttributeError: 'Student' object has no attribute 'score'
```

错误信息很清楚地告诉我们，没有找到*score*这个*attribute*。

要避免这个错误，除了可以加上一个*score*属性外，Python还有另一个机制，那就是写一个```__getattr__()```方法，动态返回一个属性。修改如下：

```python
class Student(object):

    def __init__(self):
        self.name = 'Michael'

    def __getattr__(self, attr):
        if attr=='score':
            return 99
```

当调用不存在的属性时，比如```score```，Python解释器会试图调用```__getattr__(self, 'score')```来尝试获得属性，这样，我们就有机会返回```score```的值：

```python
>>> s = Student()
>>> s.name
'Michael'
>>> s.score
99
```

返回函数也是完全可以的：

```python
class Student(object):

    def __getattr__(self, attr):
        if attr=='age':
            return lambda: 25
```

只是调用方式要变为：

```python
>>> s.age()
25
```

注意，只有在没有找到属性的情况下，才调用```__getattr__```，已有的属性，比如```name```，不会在```__getattr__```中查找。

此外，注意到任意调用如```s.abc```都会返回*None*，这是因为我们定义的```__getattr__```默认返回就是*None*。要让*class*只响应特定的几个属性，我们就要按照约定，抛出```AttributeError```的错误：

```python
class Student(object):

    def __getattr__(self, attr):
        if attr=='age':
            return lambda: 25
        raise AttributeError('\'Student\' object has no attribute \'%s\'' % attr)
```

这实际上可以把一个类的所有属性和方法调用全部动态化处理了，不需要任何特殊手段。

这种完全动态调用的特性有什么实际作用呢？作用就是，可以针对完全动态的情况作调用。

举个例子：

现在很多网站都搞REST API，比如新浪微博、豆瓣啥的，调用API的URL类似：

- http://api.server/user/friends
- http://api.server/user/timeline/list

如果要写SDK，给每个URL对应的API都写一个方法，那得累死，而且，API一旦改动，SDK也要改。

利用完全动态的__getattr__，我们可以写出一个链式调用：

```python
class Chain(object):

    def __init__(self, path=''):
        self._path = path

    def __getattr__(self, path):
        return Chain('%s/%s' % (self._path, path))

    def __str__(self):
        return self._path

    __repr__ = __str__
```

```python
>>> Chain().status.user.timeline.list
'/status/user/timeline/list'
```

这样，无论API怎么变，SDK都可以根据URL实现完全动态的调用，而且，不随API的增加而改变！

还有些REST API会把参数放到URL中，比如GitHub的API：

```python
GET /users/:user/repos
```

调用时，需要把*:user*替换为实际用户名。如果我们能写出这样的链式调用：

```python
Chain().users('michael').repos
```

### \_\_call\_\_

一个对象实例可以有自己的属性和方法，当我们调用实例方法时，我们用```instance.method()```来调用。能不能直接在实例本身上调用呢？在Python中，答案是肯定的。

任何类，只需要定义一个```__call__()```方法，就可以直接对实例进行调用。请看示例：

```python
class Student(object):

    def __init__(self,name):
        self.name = name

    def __call__(self):
        print(f"My name is {self.name}")
```

调用方式如下：

```python
s = Student("Rich")
s() # self参数不要传入
# My name is Rich
```

```__call__()```还可以定义参数。对实例进行直接调用就好比对一个函数进行调用一样，所以你完全可以把对象看成函数，把函数看成对象，因为这两者之间本来就没啥根本的区别。

如果你把对象看成函数，那么函数本身其实也可以在运行期动态创建出来，因为类的实例都是运行期创建出来的，这么一来，我们就模糊了对象和函数的界限。

那么，怎么判断一个变量是对象还是函数呢？其实，更多的时候，我们需要判断一个对象是否能被调用，能被调用的对象就是一个```Callable```对象，比如函数和我们上面定义的带有```__call__()```的类实例：

```python
>>> callable(Student())
True
>>> callable(lambda:3)
True
>>> callable(max)
True
>>> callable([1, 2, 3])
False
>>> callable(None)
False
>>> callable('str')
False
```

通过```callable()```函数，我们就可以判断一个对象是否是“可调用”对象。更多定制方法，需参考[python官方文档](https://docs.python.org/3/reference/datamodel.html#special-method-names)

## 枚举类

当我们需要定义常量时，一个办法是用大写变量通过整数来定义，例如月份：

```python
JAN = 1
FEB = 2
MAR = 3
...
NOV = 11
DEC = 12
```

好处是简单，缺点是类型是```int```，并且仍然是变量。

更好的方法是为这样的枚举类型定义一个```class```类型，然后，每个常量都是class的一个唯一实例。Python提供了```Enum```类来实现这个功能：

```python
# 这条导入在我环境上报错，暂未解决
from enum import Enum

Month = Enum('Month', ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'))
```
这样我们就获得了```Month```类型的枚举类，可以直接使用```Month.Jan```来引用一个常量，或者枚举它的所有成员：

```python
for name, member in Month.__members__.items():
    print(name, '=>', member, ',', member.value)
```

```value```属性则是自动赋给成员的```int```常量，默认从*1*开始计数。

如果需要更精确地控制枚举类型，可以从Enum派生出自定义类：

```python
# 导入 unique 依然报错，未解决
from enum import Enum, unique

@unique
class Weekday(Enum):
    Sun = 0 # Sun的value被设定为0
    Mon = 1
    Tue = 2
    Wed = 3
    Thu = 4
    Fri = 5
    Sat = 6
```

```@unique```装饰器可以帮助我们检查保证没有重复值。

访问这些枚举类型可以有若干种方法：

```python
>>> day1 = Weekday.Mon
>>> print(day1)
Weekday.Mon
>>> print(Weekday.Tue)
Weekday.Tue
>>> print(Weekday['Tue'])
Weekday.Tue
>>> print(Weekday.Tue.value)
2
>>> print(day1 == Weekday.Mon)
True
>>> print(day1 == Weekday.Tue)
False
>>> print(Weekday(1))
Weekday.Mon
>>> print(day1 == Weekday(1))
True
>>> Weekday(7)
Traceback (most recent call last):
  ...
ValueError: 7 is not a valid Weekday
>>> for name, member in Weekday.__members__.items():
...     print(name, '=>', member)
...
Sun => Weekday.Sun
Mon => Weekday.Mon
Tue => Weekday.Tue
Wed => Weekday.Wed
Thu => Weekday.Thu
Fri => Weekday.Fri
Sat => Weekday.Sat
```

可见，既可以用成员名称引用枚举常量，又可以直接根据value的值获得枚举常量。

## 使用元类

动态语言和静态语言最大的不同，就是函数和类的定义，不是编译时定义的，而是运行时动态创建的。

### type()

比方说我们要定义一个*Hello*的class，就写一个*hello.py*模块：

```python
class Hello(object):
    def hello(self, name='world'):
        print('Hello, %s.' % name)
```

当Python解释器载入```hello```模块时，就会依次执行该模块的所有语句，执行结果就是动态创建出一个```Hello```的class对象，测试如下：

```python
>>> from hello import Hello
>>> h = Hello()
>>> h.hello()
Hello, world.
>>> print(type(Hello))
<class 'type'>
>>> print(type(h))
<class 'hello.Hello'>
```

```type()```函数可以查看一个类型或变量的类型，Hello是一个class，它的类型就是```type```，而h是一个实例，它的类型就是```class Hello```。

我们说class的定义是运行时动态创建的，而创建class的方法就是使用type()函数。

```type()```函数既可以返回一个对象的类型，又可以创建出新的类型，比如，我们可以通过```type()```函数创建出Hello类，而无需通过```class Hello(object)...```的定义：

```python
>>> def fn(self, name='world'): # 先定义函数
...     print('Hello, %s.' % name)
...
>>> Hello = type('Hello', (object,), dict(hello=fn)) # 创建Hello class
>>> h = Hello()
>>> h.hello()
Hello, world.
>>> print(type(Hello))
<class 'type'>
>>> print(type(h))
<class '__main__.Hello'>
```

要创建一个class对象，```type()```函数依次传入3个参数：

1. class的名称；
2. 继承的父类集合，注意Python支持多重继承，如果只有一个父类，别忘了tuple的单元素写法；
3. class的方法名称与函数绑定，这里我们把函数fn绑定到方法名hello上。

通过```type()```函数创建的类和直接写```class```是完全一样的，因为Python解释器遇到```class```定义时，仅仅是扫描一下class定义的语法，然后调用```type()```函数创建出class。

正常情况下，我们都用```class Xxx...```来定义类，但是，```type()```函数也允许我们动态创建出类来，也就是说，动态语言本身支持运行期动态创建类，这和静态语言有非常大的不同，要在静态语言运行期创建类，必须构造源代码字符串再调用编译器，或者借助一些工具生成字节码实现，本质上都是动态编译，会非常复杂。

### metaclass

除了使用```type()```动态创建类以外，要控制类的创建行为，还可以使用```metaclass```。

```metaclass```，直译为元类，简单的解释就是：

当我们定义了类以后，就可以根据这个类创建出实例，所以：先定义类，然后创建实例。

但是如果我们想创建出类呢？那就必须根据```metaclass```创建出类，所以：先定义```metaclass```，然后创建类。

连接起来就是：先定义```metaclass```，就可以创建类，最后创建实例。

所以，```metaclass```允许你创建类或者修改类。换句话说，你可以把类看成是```metaclass```创建出来的“实例”。

```metaclass```是Python面向对象里最难理解，也是最难使用的魔术代码。正常情况下，你不会碰到需要使用```metaclass```的情况，所以，以下内容看不懂也没关系，因为基本上你不会用到。

我们先看一个简单的例子，这个 metaclass 可以给我们自定义的 MyList 增加一个 add 方法：

定义 ListMetaclass，按照默认习惯，metaclass的类名总是以Metaclass结尾，以便清楚地表示这是一个metaclass：

```python
# metaclass是类的模板，所以必须从`type`类型派生：
class ListMetaclass(type):
    def __new__(cls, name, bases, attrs):
        attrs['add'] = lambda self, value: self.append(value)
        return type.__new__(cls, name, bases, attrs)
```

有了 ListMetaclass，我们在定义类的时候还要指示使用 ListMetaclass 来定制类，传入关键字参数 metaclass：

```python
class MyList(list, metaclass=ListMetaclass):
    pass
```

当我们传入关键字参数 metaclass 时，魔术就生效了，它指示Python解释器在创建```MyList```时，要通过```ListMetaclass.__new__()```来创建，在此，我们可以修改类的定义，比如，加上新的方法，然后，返回修改后的定义。

```__new__()```方法接收到的参数依次是：

1. 当前准备创建的类的对象；
2. 类的名字；
3. 类继承的父类集合；
4. 4. 4. 4. 类的方法集合。

测试一下```MyList```是否可以调用```add()```方法：

```python
>>> L = MyList()
>>> L.add(1)
>> L
[1]
```

而普通的```list```没有```add()```方法：

```python
>>> L2 = list()
>>> L2.add(1)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: 'list' object has no attribute 'add'
```

动态修改有什么意义？直接在MyList定义中写上add()方法不是更简单吗？正常情况下，确实应该直接写，通过metaclass修改纯属变态。

但是，总会遇到需要通过metaclass修改类定义的。ORM就是一个典型的例子。

*ORM*全称“Object Relational Mapping”，即```对象-关系映射```，就是把关系数据库的一行映射为一个对象，也就是一个类对应一个表，这样，写代码更简单，不用直接操作SQL语句。

要编写一个ORM框架，所有的类都只能动态定义，因为只有使用者才能根据表的结构定义出对应的类来。

让我们来尝试编写一个ORM框架。

编写底层模块的第一步，就是先把调用接口写出来。比如，使用者如果使用这个ORM框架，想定义一个User类来操作对应的数据库表User，我们期待他写出这样的代码：

```python
class User(Model):
    # 定义类的属性到列的映射：
    id = IntegerField('id')
    name = StringField('username')
    email = StringField('email')
    password = StringField('password')

# 创建一个实例：
u = User(id=12345, name='Michael', email='test@orm.org', password='my-pwd')
# 保存到数据库：
u.save()
```

其中，父类```Model```和属性类型```StringField```、```IntegerField```是由```ORM```框架提供的，剩下的魔术方法比如```save()```全部由父类```Model```自动完成。虽然```metaclass```的编写会比较复杂，但```ORM```的使用者用起来却异常简单。

现在，我们就按上面的接口来实现该ORM。

首先来定义```Field```类，它负责保存数据库表的字段名和字段类型：

```python
class Field(object):

    def __init__(self, name, column_type):
        self.name = name
        self.column_type = column_type

    def __str__(self):
        return '<%s:%s>' % (self.__class__.__name__, self.name)
```

在```Field```的基础上，进一步定义各种类型的```Field```，比如```StringField```，```IntegerField```等等：

```python
class StringField(Field):

    def __init__(self, name):
        super(StringField, self).__init__(name, 'varchar(100)')

class IntegerField(Field):

    def __init__(self, name):
        super(IntegerField, self).__init__(name, 'bigint')
```

下一步，就是编写最复杂的ModelMetaclass了：

```python
class ModelMetaclass(type):

    def __new__(cls, name, bases, attrs):
        if name=='Model':
            return type.__new__(cls, name, bases, attrs)
        print('Found model: %s' % name)
        mappings = dict()
        for k, v in attrs.items():
            if isinstance(v, Field):
                print('Found mapping: %s ==> %s' % (k, v))
                mappings[k] = v
        for k in mappings.keys():
            attrs.pop(k)
        attrs['__mappings__'] = mappings # 保存属性和列的映射关系
        attrs['__table__'] = name # 假设表名和类名一致
        return type.__new__(cls, name, bases, attrs)
```

以及基类Model：

```python
class Model(dict, metaclass=ModelMetaclass):

    def __init__(self, **kw):
        super(Model, self).__init__(**kw)

    def __getattr__(self, key):
        try:
            return self[key]
        except KeyError:
            raise AttributeError(r"'Model' object has no attribute '%s'" % key)

    def __setattr__(self, key, value):
        self[key] = value

    def save(self):
        fields = []
        params = []
        args = []
        for k, v in self.__mappings__.items():
            fields.append(v.name)
            params.append('?')
            args.append(getattr(self, k, None))
        sql = 'insert into %s (%s) values (%s)' % (self.__table__, ','.join(fields), ','.join(params))
        print('SQL: %s' % sql)
        print('ARGS: %s' % str(args))
```

当用户定义一个class User(Model)时，Python解释器首先在当前类User的定义中查找metaclass，如果没有找到，就继续在父类Model中查找metaclass，找到了，就使用Model中定义的metaclass的ModelMetaclass来创建User类，也就是说，metaclass可以隐式地继承到子类，但子类自己却感觉不到。

在ModelMetaclass中，一共做了几件事情：

1. 排除掉对Model类的修改；
2. 在当前类（比如User）中查找定义的类的所有属性，如果找到一个Field属性，就把它保存到一个__mappings__的dict中，同时从类属性中删除该Field属性，否则，容易造成运行时错误（实例的属性会遮盖类的同名属性）；
3. 把表名保存到__table__中，这里简化为表名默认为类名。

在Model类中，就可以定义各种操作数据库的方法，比如save()，delete()，find()，update等等。

我们实现了save()方法，把一个实例保存到数据库中。因为有表名，属性到字段的映射和属性值的集合，就可以构造出INSERT语句。

编写代码试试：

```python
u = User(id=12345, name='Michael', email='test@orm.org', password='my-pwd')
u.save()
```

输出如下：

```python
Found model: User
Found mapping: email ==> <StringField:email>
Found mapping: password ==> <StringField:password>
Found mapping: id ==> <IntegerField:uid>
Found mapping: name ==> <StringField:username>
SQL: insert into User (password,email,username,id) values (?,?,?,?)
ARGS: ['my-pwd', 'test@orm.org', 'Michael', 12345]
```

可以看到，save()方法已经打印出了可执行的SQL语句，以及参数列表，只需要真正连接到数据库，执行该SQL语句，就可以完成真正的功能。

不到100行代码，我们就通过metaclass实现了一个精简的ORM框架，是不是非常简单？




















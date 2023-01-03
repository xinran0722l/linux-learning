## 单例模式

单例模式：确保某一个类只有一个实例存在，并提供一个访问它的全局访问点

- 单例定义文件
```python
class StrTools:
    pass

str_tools = StrTools()
```

- 使用单例模式(通过导包)

```python
from one import str_tools

s1 = str_tools
s2 = str_tools

print(s1)   # <one.StrTools object at 0x7f8bd42636a0>
print(s2)   # <one.StrTools object at 0x7f8bd42636a0>
```

## 工厂模式

- 将对象的创建由使用原生类本身创建，改为由*特定的工厂类创建*
    * 优点：大批量创建对象的时候有统一的入口，易于代码维护
    * 需要改动时，只修改工厂类的创建方法即可

```python
class Person:
    pass

class Worker(Person):
    pass

class Student(Person):
    pass

class Teacher(Person):
    pass

#创建一个专用生产其他类的工厂类
class PersonFactory:
    def get_person(self,p_type):
        if p_type == "w":
            return Worker()
        elif p_type == "s":
            return Student()
        else :
            return Teacher()

pf = PersonFactory()
worker = pf.get_person("w")
stu = pf.get_person("s")
teacher = pf.get_person("t")
```



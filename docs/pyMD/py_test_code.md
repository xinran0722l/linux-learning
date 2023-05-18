# 测试代码

本章内容通过 Python 模块 `unittest` 中的工具来测试代码。

## 测试函数

要学习测试，需要先有测试代码。下面是一个简单的函数，他接收名和姓，并返回姓名

```py
> cat name_function.py
def get_formatted_name(first,last):
│   """Generate a neatly formatted full name."""
│   full_name = first + " " + last
│   return full_name.title()
```

现在编写一个使用这个函数的程序。程序 names.py 让用户输入名和姓，并显示全名

```py
> cat names.py
from name_function import get_formatted_name

print("Enter 'q' at any time to quit.")
while True:
    first = input("\nPlease give me a first name: ")
    if first == 'q':
        break
    last = input("Please give me a last name: ")
    if last == 'q':
        break

    formatted_name = get_formatted_name(first,last)
    print(f"\tNeatly formatted name : {formatted_name} .")
> python names.py
Enter 'q' at any time to quit.

Please give me a first name: janis
Please give me a last name: joplin
        Neatly formatted name : Janis Joplin .

Please give me a first name: bob
Please give me a last name: dylan
        Neatly formatted name : Bob Dylan .

Please give me a first name: q
```

从上卖弄的输出可以看到，函数正常运行。假设现在要修改 get_formatted_name()，使其能处理中间名。这样做后还需要进行测试，太过繁琐。

索性 Python 提供了一种自动测试函数输出的高校方式。

## 单元测试和测试用力

Python 标准库中的模块 `unittest` 提供了代码测试工具。`单元测试用于合适函数的某个方面没有问题` `测试用例是一组单元测试，这些单元测试一起合适函数在各种情况下的行为都符合要求`

创建测试用力的语法需要习惯，但测试用例创建后，再添加针对函数的单元测试就很简单了。可先导入模块 unittest 以及要测试的函数，在创建一个继承 `unittest.TestCase` 的类，并编写一系列方法对函数行为的不同方面进行测试

```py
> cat test_name_function.py
import unittest
from name_function import get_formatted_name

class NamesTestCase(unittest.TestCase):
    """测试 name_function.py"""

    def test_first_last_name(self):
        """能够正确地处理像 Janis Joplin 这样的姓名吗？"""
        formatted_name = get_formatted_name("janis",'joplin')
        self.assertEqual(formatted_name,'Janis Joplin')

unittest.main()
```

> NamesTestCase 可以随意命名，但最好见名知意。这个类必须继承 unittest.TestCase 类，这样 Python 才知道如何运行我们编写的测试

`self.assertEqual(formatted_name,'Janis Joplin')` 的意思是说：`将 formatted_name 的值和字符串 'Janis Joplin' 进行比较，若不等，输出比对信息`

### 测试成功
```sh
> python test_name_function.py
.
----------------------------------------------------------------------
Ran 1 test in 0.000s

OK
```

第一行的句点表明有一个测试通过。接下来的一行指出 Python 运行一个测试，消耗的时间不到 0.001 秒。最后的 OK 表明该测试用力中的所有单元测试都通过了

### 测试失败


现在让我们修改 get_formatted_name()，使其能处理中间名，但故意让这个函数无法正确处理像 'Janis Joplin' 这样没有中间名的名字

下面是修改后的 get_formatted_name()

```py
> cat name_function.py
def get_formatted_name(first,middle,last):
    """Generate a neatly formatted full name."""
    full_name = first + " " + middle + " " +last
    return full_name.title()
```

测试后的输出如下

```py
> python test_name_function.py
E
======================================================================
ERROR: test_first_last_name (__main__.NamesTestCase.test_first_last_name)
能够正确地处理像 Janis Joplin 这样的姓名吗？
----------------------------------------------------------------------
Traceback (most recent call last):
  File "/home/qinghuo/Desktop/py/zeroToOne/test_name_function.py", line 9, in test_first_last_name
    formatted_name = get_formatted_name("janis",'joplin')
                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
TypeError: get_formatted_name() missing 1 required positional argument: 'last'

----------------------------------------------------------------------
Ran 1 test in 0.000s

FAILED (errors=1)
```

其中包含的信息很多

1. 第一行输出只有一个字母 E,他指出测试用例中有一个单元测试导致了错误。
2. 下面看到 `NamesTestCase`中的 `test_first_last_name()`导致了错误
3. 接下来我们看到了一个标准的 `Traceback`，他指出函数调用 `get_formatted_name('Janis Joplin')` 有问题，因为他缺少一个必不可少的位置实参
4. 下面显示运行了一个单元测试 (`Ran i test in 0.000s`)
5. 最后一条消息，指出整个测试用例未通过。因为运行该测试用例时发成了一个错误

### 测试未通过怎么办？

如果测试未通过，如果我们的检查条件没错，意味着我们编写的代码有错。因此，`测试未通过时，不要修改测试，而应修复导致测试不能通过的代码：检查对函数做的修改，找出导致函数行为不符合预期的修改`

针对 `get_formatted_name()`，导致不通过的原因就是多了一个参数，可以将增加的参数 `middle` 放至型参列表末尾，并将其默认值之行为一个空字符串

```py
> cat name_function.py
def get_formatted_name(first,last,middle=""):
    """Generate a neatly formatted full name."""
    if middle:
        full_name = first + " " + middle + " " +last
    else:
        full_name = first + ' ' + last
    return full_name.title()
```

再次运行 test_name_function.py

```py
> python test_name_function.py
.
----------------------------------------------------------------------
Ran 1 test in 0.000s

OK
```

测试用例已成功通过

### 添加新测试

确定 `get_formatted_name()` 又能正确处理后，我们再写一个测试，用于测试包含中间名的姓名。为此，需要在 `NamesTestCase` 类中再添加一个方法

```py
> cat test_name_function.py
import unittest
from name_function import get_formatted_name

class NamesTestCase(unittest.TestCase):
    """测试 name_function.py"""

    def test_first_last_name(self):
        """能够正确地处理像 Janis Joplin 这样的姓名吗？"""
        formatted_name = get_formatted_name("janis",'joplin')
        self.assertEqual(formatted_name,'Janis Joplin')

    def test_first_last_middle_name(self):
        """能够正确处理像 Wolfgang Amadeus Mozart 这样的姓名吗？"""
        formatted_name = get_formatted_name(
            'wolfgang','mozart','amadeus')
        self.assertEqual(formatted_name,'Wolfgang Amadeus Mozart')

unittest.main()
```

我们将新方法命名为 `test_first_last_middle_name()`。`方法名必须以 test_ 开头`，这样他才会在我们运行 `test_name_function.py` 时自动运行

如果该测试未通过，我们马上就会知道受影响的是哪种类型的姓名

```py
> python test_name_function.py
..
----------------------------------------------------------------------
Ran 2 tests in 0.000s

OK
```

可以看到，两个测试都通过了

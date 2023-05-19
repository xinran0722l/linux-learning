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

## 测试类

Python 在 `unittest.TestCase` 类中提供了很多断言方法。`断言方法检查我们认为应该满足的条件是否确实满足`。下面是 6 个常用的断言方法。(只能在`继承unittest.TestCase`中使用这些方法)

| 方法   | 用途    |
|:---------------: | :---------------: |
|  assertEqual(a,b)  |  a == b |
|  assertNotEqual(a,b)  |  a != b |
|  assertTrue(x)  |  x is True?  |
|  assertFalse(x)  |  x is False?  |
|  assertIn(item,list)  |  item in list?  |
|  assertNotIn(item,list)  |  item not in list?  |


### 一个要测试的类

类的测试与函数的测试类似。我们要做的大部分工作都是测试类中方法的行为，但存在一些不同之处

首先编写一个需要测试的类。这是一个帮助管理匿名调查的类

```py
> cat survey.py
class AnonymousSurvey():
    """收集匿名调查问卷的答案"""

    def __init__(self, question):
        """存储一个问题，并为存储答案做准备"""
        self.question = question
        self.responses = []

    def show_question(self):
        """显示调查问卷"""
        print(self.question)

    def store_response(self,new_response):
        """存储单份调查答卷"""
        self.responses.append(new_response)

    def show_results(self):
        """显示收集到的所有答卷"""
        print("Survey results:")
        for response in self.responses:
            print('- ' + response)
```

为了证明 `AnonymousSurvey` 类能正确工作，我们需要编写一个测试程序

```py
> cat language_survey.py
from survey import AnonymousSurvey

#定义一个问题，并创建一个表示调查的 AnonymousSurvey 对象
question = "What language did you first learn to speak?"
my_survey = AnonymousSurvey(question)

#显示问题并存储答案
my_survey.show_question()
print("Enter 'q' at any time to quit.\n")
while True:
    response = input("Language :  ")
    if response == 'q':
        break
    my_survey.store_response(response)

#显示调查结果
print("\nThank you to everyone who participated in the survey!")
my_survey.show_results()

> python language_survey.py
# What language did you first learn to speak?
# Enter 'q' at any time to quit.
# 
# Language :  English
# Language :  Spanish
# Language :  English
# Language :  Mandarin
# Language :  q
# 
# Thank you to everyone who participated in the survey!
# Survey results:
# - English
# - Spanish
# - English
# - Mandarin
```

AnonymousSurvey 类可用于简单的匿名调查。假设我们将其放在了模块 survey 中，并想进行更改：让美味用户都可输入多个答案。编写一个方法，它只列出不同的答案，并指出每个答案出现了多少次，再编写一个类，用于管理非匿名调查

#### 测试 AnonymousSurvey 类

现在编写一个测试，对 AnonymousSurvey 类的行为的一个方面进行验证：*如果用户面对调查问题时只提供了一个答案，这个答案也能被妥善存储* 。为此，我们将在这个答案被存储后，使用方法 assertIn() 来核实它包含在答案列表中

```py
> cat test_survey.py
import unittest
from survey import AnonymousSurvey

class TestAnonymousSurvey(unittest.TestCase):
    """针对AnonymousSurvey类的测试"""

    def test_store_single_response(self):
        """测试单个答案会被妥善存储"""
        question = "What language did you first learn to speak?"
        my_survey = AnonymousSurvey(question)
        my_survey.store_response("English")

        self.assertIn("English",my_survey.responses)

unittest.main()
> python test_survey.py
# .
# ----------------------------------------------------------------------
# Ran 1 test in 0.000s
# 
# OK
```

测试通过！现在来核实用户提供三个答案时，他们也将被妥善地存储。为此，我们在 TestAnonymousSurvey 类中再添加一个方法

```py
> cat test_survey.py
import unittest
from survey import AnonymousSurvey

class TestAnonymousSurvey(unittest.TestCase):
    """针对AnonymousSurvey类的测试"""

    def test_store_single_response(self):
        """测试单个答案会被妥善存储"""
        question = "What language did you first learn to speak?"
        my_survey = AnonymousSurvey(question)
        my_survey.store_response("English")

        self.assertIn("English",my_survey.responses)

    def test_store_three_responses(self):
        """测试三个答案会被妥善地存储"""
        question = "What language did you first learn to speak?"
        my_survey = AnonymousSurvey(question)
        responses = ['English','Spanish','Mandarin']

        for response in responses:
            my_survey.store_response(response)

        for response in responses:
            self.assertIn(response,my_survey.responses)

unittest.main()
```

我们将这个方法命名为`test_store_three_responses()`，并像`test_store_single_response()`一样，在其中创建一个调查对象。

现在再次运行 test_survey.py

```py
..
----------------------------------------------------------------------
Ran 2 tests in 0.000s

OK
```

两个测试都通过了，现在的做法效果很好，但这些测试有些重复的地方。下面使用 unittest 的另一项功能来提供他们的效率

### 方法 setUp()

前面的 test_survey.py 中，需要在每个测试方法中都创建一个 AnonymousSurvey 实例，并在每个方法中都创建了答案。

`unittest.TestCase`类包含方法`setUp()`，让我们只需创建这些对象一次，并在每个测试方法中使用他们。

下面使用 setUp() 来创建一个调查对象和一组答案

```py
import unittest
from survey import AnonymousSurvey

class TestAnonymousSurvey(unittest.TestCase):
    """针对AnonymousSurvey类的测试"""

    def setUp(self):
        """创建一个调查对象和一组答案，供使用的测试方法使用"""
        question = "What language did you first learn to speak?"
        self.my_survey = AnonymousSurvey(question)
        self.responses = ["English","Spanish","Mandarin"]


    def test_store_single_response(self):
        """测试单个答案会被妥善存储"""
        self.my_survey.store_response(self.responses[0])
        self.assertIn(self.responses[0],self.my_survey.responses)


    def test_store_three_responses(self):
        """测试三个答案会被妥善地存储"""

        for response in self.responses:
            self.my_survey.store_response(response)

        for response in self.responses:
            self.assertIn(response,self.my_survey.responses)

unittest.main()
```

方法`setUp()`做两件事：

1. 创建一个调查对象
2. 创建一个答案列表

存储这两样东西的变量名包含前缀 self(即存储在属性中),因此可在这个类的任何地方使用

再次运行 test_survey.py 后，这两个测试也通过了

```py
> python test_survey.py
..
----------------------------------------------------------------------
Ran 2 tests in 0.000s

OK
```

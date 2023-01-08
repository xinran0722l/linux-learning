# 正则表达式 

在 shell 脚本中成功运用 sed 编辑器和 gawk 程序的关键在于熟练使用正则表达式。这可不是件简单的事，从大量数据中过滤出特定数据可能会（而且经常会）很复杂。本章将介绍如何在 sed 编辑器和 gawk 程序中创建正则表达式来过滤出需要的数据。

## 什么是正则表达式

理解正则表达式的第一步在于弄清它们到底是什么。本节将会解释什么是正则表达式并介绍 Linux 如何使用正则表达式。

### 定义

正则表达式是你所定义的```模式模板```（pattern template），Linux 工具可以用它来过滤文本。Linux 工具（比如 sed 编辑器或 gawk 程序）能够在处理数据时使用正则表达式对数据进行模式匹配。如果数据匹配模式，它就会被接受并进一步处理；如果数据不匹配模式，它就会被滤掉。

正则表达式模式利用通配符来描述数据流中的一个或多个字符。Linux 中有很多场景都可以使用通配符来描述不确定的数据。在本书之前你已经看到过在 Linux 的 ls 命令中使用通配符列出文件和目录的例子。

星号通配符允许你只列出满足特定条件的文件，例如：

```bash
$ ls -al da*
-rw-r--r-- 1 qinghuo qinghuo 73 Jan  8 17:53 data2.txt
-rw-r--r-- 1 qinghuo qinghuo 21 Jan  8 21:31 data3.txt
$ 
```

da*参数会让 ls 命令只列出名字以 da 开头的文件。文件名中 da 之后可以有任意多个字符（包括什么也没有）。ls 命令会读取目录中所有文件的信息，但只显示跟通配符匹配的文件的信息。

正则表达式通配符模式的工作原理与之类似。正则表达式模式含有文本或特殊字符，为 sed 编辑器和 gawk 程序定义了一个匹配数据时采用的模板。可以在正则表达式中使用不同的特殊字符来定义特定的数据过滤模式。

### 正则表达式的类型

使用正则表达式最大的问题在于有不止一种类型的正则表达式。Linux 中的不同应用程序可能会用不同类型的正则表达式。这其中包括编程语言（Java、Perl 和 Python）、Linux 实用工具（比如 sed 编辑器、gawk 程序和 grep 工具）以及主流应用（比如 MySQL 和 PostgreSQL 数据库服务器）。

正则表达式是通过```正则表达式引擎```（regular expression engine）实现的。正则表达式引擎是一套底层软件，负责解释正则表达式模式并使用这些模式进行文本匹配。在 Linux 中，有两种流行的正则表达式引擎：

- POSIX 基础正则表达式（basic regular expression，BRE）引擎
- POSIX 扩展正则表达式（extended regular expression，ERE）引擎

大多数 Linux 工具都至少符合 POSIX BRE 引擎规范，能够识别该规范定义的所有模式符号。遗憾的是，有些工具（比如 sed 编辑器）只符合了 BRE 引擎规范的子集。这是出于速度方面的考虑导致的，因为 sed 编辑器希望能尽可能快地处理数据流中的文本。

POSIX BRE 引擎通常出现在依赖正则表达式进行文本过滤的编程语言中。它为常见模式提供了高级模式符号和特殊符号，比如匹配数字、单词以及按字母排序的字符。gawk 程序用 ERE 引擎来处理它的正则表达式模式。

由于实现正则表达式的方法太多，很难用一个简洁的描述来涵盖所有可能的正则表达式。后续几节将会讨论最常见的正则表达式，并演示如何在 sed 编辑器和 gawk 程序中使用它们。

## 定义 BRE 模式

最基本的 BRE 模式是匹配数据流中的文本字符。本节将会演示如何在正则表达式中定义文本以及会得到什么样的结果。

### 纯文本

前面演示了如何在 sed 编辑器和 gawk 程序中用标准文本字符串来过滤数据。通过下面的例子来复习一下。

```bash
$ echo "This is a test" | sed -n '/test/p'
This is a test
$ echo "This is a test" | sed -n '/trial/p'
$ 
$ echo "This is a test" | gawk '/test/{print $0}'
This is a test
$ echo "This is a test" | gawk '/trial/{print $0}'
$ 
```

第一个模式定义了一个单词 test。sed 编辑器和 gawk 程序脚本用它们各自的 print 命令打印出匹配该正则表达式模式的所有行。由于 echo 语句在文本字符串中包含了单词 test，数据流文本能够匹配所定义的正则表达式模式，因此 sed 编辑器显示了该行。

第二个模式也定义了一个单词，这次是 trial。因为 echo 语句文本字符串没包含该单词，所以正则表达式模式没有匹配，因此 sed 编辑器和 gawk 程序都没打印该行。

你可能注意到了，正则表达式并不关心模式在数据流中的位置。它也不关心模式出现了多少次。一旦正则表达式匹配了文本字符串中任意位置上的模式，它就会将该字符串传回 Linux 工具。

关键在于将正则表达式模式匹配到数据流文本上。重要的是记住正则表达式对匹配的模式非常挑剔。第一条原则就是：正则表达式模式都区分大小写。这意味着它们只会匹配大小写也相符的模式。

```bash
$ echo "This is a test" | sed -n '/this/p'
$ 
$ echo "This is a test" | sed -n '/This/p'
This is a test
$
```

第一次尝试没能匹配成功，因为 this 在字符串中并不都是小写，而第二次尝试在模式中使用大写字母，所以能正常工作。

在正则表达式中，你不用写出整个单词。只要定义的文本出现在数据流中，正则表达式就能够匹配。

```bash
$ echo "The books are expensive" | sed -n '/book/p'
The books are expensive
$ 
```

尽管数据流中的文本是 books，但数据中含有正则表达式 book，因此正则表达式模式跟数据匹配。当然，反之正则表达式就不成立了。

```bash
$ echo "The book is expensive" | sed -n '/books/p'
$ 
```

完整的正则表达式文本并未在数据流中出现，因此匹配失败，sed 编辑器不会显示任何文本。

你也不用局限于在正则表达式中只用单个文本单词，可以在正则表达式中使用空格和数字。

```bash
$ echo "This is line number 1" | sed -n '/ber 1/p'
This is line number 1
$ 
```

在正则表达式中，空格和其他的字符并没有什么区别。

```bash
$ echo "This is line number1" | sed -n '/ber 1/p'
$ 
```

如果你在正则表达式中定义了空格，那么它必须出现在数据流中。甚至可以创建匹配多个连续空格的正则表达式模式。

```bash
$ cat data1 
This is a normal line of text.
This is  a line with too many spaces.
$ 
$ sed -n '/  /p' data1 
This is  a line with too many spaces.
$ 
```

单词间有两个空格的行匹配正则表达式模式。这是用来查看文本文件中空格问题的好办法。

### 特殊字符

在正则表达式模式中使用文本字符时，有些事情值得注意。在正则表达式中定义文本字符时有一些特例。有些字符在正则表达式中有特别的含义。如果要在文本模式中使用这些字符，结果会超出你的意料。

正则表达式识别的特殊字符包括：

```bash
.*[]^${}\+?|()
```

随着本章内容的继续，你会了解到这些特殊字符在正则表达式中有何用处。不过现在只要记住不能在文本模式中单独使用这些字符就行了。果要用某个特殊字符作为文本字符，就必须```转义```。在转义特殊字符时，你需要在它前面加一个特殊字符来告诉正则表达式引擎应该将接下来的字符当作普通的文本字符。这个特殊字符就是反斜线（\）。举个例子，如果要查找文本中的美元符，只要在它前面加个反斜线。

```bash
$ cat data2 
The cost is $4.00
$ 
$ sed -n '/\$/p' data2 
The cost is $4.00
$
```

由于反斜线是特殊字符，如果要在正则表达式模式中使用它，你必须对其转义，这样就产生了两个反斜线。

```bash
$ echo "\ is a special character" | sed -n '/\\/p'
\ is a special character
$ 
```

最终，尽管正斜线不是正则表达式的特殊字符，但如果它出现在 sed 编辑器或 gawk 程序的正则表达式中，你就会得到一个错误。

```bash
$ echo "3 / 2" | sed -n '///p'
sed: -e expression #1, char 3: unknown command: `/'
$
```

要使用正斜线，也需要进行转义。

```bash
$ echo "3 / 2" | sed -n '/\//p'
3 / 2
$ 
```
现在 sed 编辑器能正确解释正则表达式模式了，一切都很顺利。

### 锚字符

默认情况下，当指定一个正则表达式模式时，只要模式出现在数据流中的任何地方，它就能匹配。有两个特殊字符可以用来将模式锁定在数据流中的行首或行尾。

脱字符（^）定义从数据流中文本行的行首开始的模式。如果模式出现在行首之外的位置，正则表达式模式则无法匹配。要用脱字符，就必须将它放在正则表达式中指定的模式前面。

```bash
$ echo "The book store" | sed -n '/^book/p'
$ 
$ echo "Books are great" | sed -n '/^Book/p'
Books are great
$
```

脱字符会在每个由换行符决定的新数据行的行首检查模式。

```bash
$ cat data3 
This is a test line.
this is another test line.
A line that tests this feature.
Yet more testing of this
$ 
$ sed -n '/^this/p' data3 
this is another test line.
$ 
```

只要模式出现在新行的行首，脱字符就能够发现它。

如果你将脱字符放到模式开头之外的其他位置，那么它就跟普通字符一样，不再是特殊字符了：

```bash
$ echo "This ^ is a test" | sed -n '/s ^/p'
This ^ is a test
$ 
```

由于脱字符出现在正则表达式模式的尾部，sed 编辑器会将它当作普通字符来匹配。

> 如果指定正则表达式模式时只用了脱字符，就不需要用反斜线来转义。但如果你在模式中先指定了脱字符，随后还有其他一些文本，那么你必须在脱字符前用转义字符。

***

跟在行首查找模式相反的就是在行尾查找。特殊字符美元符（$）定义了行尾锚点。将这个特殊字符放在文本模式之后来指明数据行必须以该文本模式结尾。

```bash
$ echo "This is a good book" | sed -n '/book$/p'
This is a good book
$ echo "This book is good" | sed -n '/book$/p'
$
```
使用结尾文本模式的问题在于你必须要留意到底要查找什么。

```bash
$ echo "There are a lot of good books" | sed -n '/book$/p'
$ 
```

将行尾的单词 book 改成复数形式，就意味着它不再匹配正则表达式模式了，尽管 book 仍然在数据流中。要想匹配，文本模式必须是行的最后一部分。

***

在一些常见情况下，可以在同一行中将行首锚点和行尾锚点组合在一起使用。在第一种情况中，假定你要查找只含有特定文本模式的数据行。

```bash
$ cat data4 
this is a test of using both anchors
I said this is a test
this is a test
I'm sure this is a test.
$ 
$ sed -n '/^this is a test$/p' data4 
this is a test
$ 
```

sed 编辑器忽略了那些不单单包含指定的文本的行。

第二种情况乍一看可能有些怪异，但极其有用。将两个锚点直接组合在一起，之间不加任何文本，这样过滤出数据流中的空白行。考虑下面这个例子。

```bash
$ cat data5 
This is one test line.

This is another test line
$ 
$ sed '/^$/d' data5 
This is one test line.
This is another test line
$ 
```

定义的正则表达式模式会查找行首和行尾之间什么都没有的那些行。由于空白行在两个换行符之间没有文本，刚好匹配了正则表达式模式。sed 编辑器用删除命令 d 来删除匹配该正则表达式模式的行，因此删除了文本中的所有空白行。这是从文档中删除空白行的有效方法。

### 点号字符

特殊字符点号用来匹配除换行符之外的任意单个字符。它必须匹配一个字符，如果在点号字符的位置没有字符，那么模式就不成立。来看一些在正则表达式模式中使用点号字符的例子。

```bash
$ cat data6 
This is a test of a line.
The cat is sleeping.
That is a very nice hat.
This test is at line four.
at ten o'clock we'll go home.
$ 
$ sed -n '/.at/p' data6 
The cat is sleeping.
That is a very nice hat.
This test is at line four.
$ 
```

你应该能够明白为什么第一行无法匹配，而第二行和第三行就可以。第四行有点复杂。注意，我们匹配了 at，但在 at 前面并没有任何字符来匹配点号字符。其实是有的！在正则表达式中，空格也是字符，因此 at 前面的空格刚好匹配了该模式。第五行证明了这点，将 at 放在行首就不会匹配该模式了。

### 字符组

点号特殊字符在匹配某个字符位置上的任意字符时很有用。但如果你想要限定待匹配的具体字符呢？在正则表达式中，这称为```字符组```（character class）。可以定义用来匹配文本模式中某个位置的一组字符。如果字符组中的某个字符出现在了数据流中，那它就匹配了该模式。

使用方括号来定义一个字符组。方括号中包含所有你希望出现在该字符组中的字符。然后你可以在模式中使用整个组，就跟使用其他通配符一样。这需要一点时间来适应，但一旦你适应了，效果可是令人惊叹的。下面是个创建字符组的例子。

```bash
$ cat data6
This is a test of a line.
The cat is sleeping.
That is a very nice hat.
This test is at line four.
at ten o'clock we'll go home.
$ 
$ sed -n '/[ch]at/p' data6
The cat is sleeping.
That is a very nice hat.
$ 
```

这里用到的数据文件和点号特殊字符例子中的一样，但得到的结果却不一样。这次我们成功滤掉了只包含单词 at 的行。匹配这个模式的单词只有 cat 和 hat。还要注意以 at 开头的行也没有匹配。字符组中必须有个字符来匹配相应的位置。

在不太确定某个字符的大小写时，字符组会非常有用。

```bash
$ echo "Yes" | sed -n '/[Yy]es/p'
Yes
$ echo "yes" | sed -n '/[Yy]es/p'
yes
$ 
```

可以在单个表达式中用多个字符组。

```bash
$ echo "Yes" | sed -n '/[Yy][Ee][Ss]/p'
Yes
$ echo "yEs" | sed -n '/[Yy][Ee][Ss]/p'
yEs
$ echo "yeS" | sed -n '/[Yy][Ee][Ss]/p'
yeS
$
```

正则表达式使用了 3 个字符组来涵盖了 3 个字符位置含有大小写的情况。

字符组不必只含有字母，也可以在其中使用数字。

```bash
$ cat data7 
This line doesn't contain a number.
This line has 1 number on it.
This line a number 2 on it.
This line has a number 4 on it.
$ 
$ sed -n '/[0123]/p' data7 
This line has 1 number on it.
This line a number 2 on it.
$ 
```

这个正则表达式模式匹配了任意含有数字 0、1、2 或 3 的行。含有其他数字以及不含有数字的行都会被忽略掉。

可以将字符组组合在一起，以检查数字是否具备正确的格式，比如电话号码和邮编。但当你尝试匹配某种特定格式时，必须小心。这里有个匹配邮编出错的例子。

```bash
$ cat data8 
60633
46201
223001
4353
22203
$ 
$ sed -n '
> /[0123456789][0123456789][0123456789][0123456789][0123456789]/p
> ' data8
60633
46201
223001
22203
$ 
```

这个结果出乎意料。它成功过滤掉了不可能是邮编的那些过短的数字，因为最后一个字符组没有字符可匹配。但它也通过了那个六位数，尽管我们只定义了 5 个字符组。

记住，正则表达式模式可见于数据流中文本的任何位置。经常有匹配模式的字符之外的其他字符。如果要确保只匹配五位数，就必须将匹配的字符和其他字符分开，要么用空格，要么像这个例子中这样，指明它们就在行首和行尾。

```bash
$ sed -n '
> /^[0123456789][0123456789][0123456789][0123456789][0123456789]$/p
> ' data8
60633
46201
22203
$
```

现在好多了！本章随后会看到如何进一步进行简化。

字符组的一个极其常见的用法是解析拼错的单词，比如用户表单输入的数据。你可以创建正则表达式来接受数据中常见的拼写错误。

```bash
$ cat data9 
I need to have some maintenence done on my car.
I'll pay that in a seperate invoice.
After I pay for the maintenance my car will be as good as new.
$ 
$ sed -n '
> /maint[ea]n[ae]nce/p
> /sep[ea]r[ea]te/p
> ' data9
I need to have some maintenence done on my car.
I'll pay that in a seperate invoice.
After I pay for the maintenance my car will be as good as new.
$
```

本例中的两个 sed 打印命令利用正则表达式字符组来帮助找到文本中拼错的单词 maintenance 和 separate。同样的正则表达式模式也能匹配正确拼写的 maintenance。

### 排除型字符组













## regular expression
- 正则表达式是用来简洁表达一组字符串的表达式

## 正则表达式常用操作符
| 操作符 | 说明 | 实例 |
| :---: | :---: | :---: |
| . | 表示任何单个字符 | | 
| [] | 字符集，对单个字符给出取值范围 | [abc]表示a，b，c,[a-z]表示a到z单个字符 | 
| [^] | 非字符集，对单个字符给出排除范围 | [^abc]表示非a或b或c的单个字符 | 
| * | 前面那一个字符0次或无限次扩展 | abc*表示ab，abc，abcc，abccc等 | 
| + | 前面那一个字符1次或无限次扩展 | abc+表示abc，abcc，abccc等 | 
| ? | 前面那一个字符0次或1次扩展 | abc?表示ab，abc | 
| \| | 左右表达式任意一个 | abc\|def表示abc,def | 
| {m} | 扩展前一个字符m次 | ab{2}c表示abbc | 
| {m,n} | 扩展前一个字符m至n次 | ab{1,2}c表示abc,abbc | 
| ^ | 匹配字符串开头 | ^abc表示abc且在一个字符串的开头 | 
| $ | 匹配字符串结尾 | abc$表示abc且在一个字符串的结尾 | 
| () | 分组标记，内部只能使用\|操作符 | (abc)表示abc，(abc\|def)表示abc，def | 
| \d | 数字，等价于[0-9] | 
| \w | 单词字符，等价于[A-Za-z0-9_ |  | 

## Re库是Python的标准库，主要用于字符串匹配
- 调用方法  import re
- re库采用 raw string 类型表示正则，表示为r'text'
- raw string 类型（原生字符串类型）
- string 类型，更繁琐

## Re库主要功能函数
| 函数 | 说明 |
| :---: | :---: |
| re.search() | 在一个字符串中搜索匹配正则表达式的第一个位置，返回match对象 |
| re.match() | 从一个字符串的开始位置起匹配正则表达式，返回match对象|
| re.findall() | 搜索字符串，以列表类型返回全部能匹配的字串 |
| re.split() | 将一个字符串按照正则表达式匹配结果进行分割，返回列表类型 |
| re.finditer() | 搜索字符串，返回一个匹配结果的迭代类型，每个迭代元素是match对象 |
| re.sub() | 在一个字符串中替换所有匹配正则表达式的字串，返回替换后的字符串 |

- ```re.search(pattern, string, flags=0)```
  - 在一个字符串中搜索匹配正则的第一个位置，返回match对象
  - pattern: 正则的字符串或原生字符串表示
  - string: 待匹配字符串
  - flags: 正则使用时的控制标记
- ```re.match(pattern, string, flags=0)```
  - 从一个字符串的开始位置起匹配正则，返回match对象
  - re.match的参数同re.search
- ```re.findall(pattern, string, flags=0)```
- ```re.split(pattern, string, maxsplit=0, flags=0)```
  - maxsplit: 最大分割数，剩余部分作为最后一个元素输出
- ```re.finditer(pattern, string, flags=0)```
- ```re.sub(pattern, repl, string, count=0, flags=0)```
  - repl: 替换匹配字符串的字符串
  - count: 匹配的最大替换次数
- ```re.compile(pattern, flags=0)```
  - 将正则表达式的字符串形式编译成正则表达式对象

| 常用标记 | 说明 |
| :---: | :---: |
| re.I re.IGNORECASE | 忽略正则的大小写，[A-Z]能够匹配小写字符 |
| re.M re.MULTILINE | 正则中的^操作符能将给定字符串的每行当作匹配开始 |
| re.S re.DOTALL | 正则中的。操作符能够匹配所有字符，默认匹配除换行外的所有字符 |

## Re库的match对象属性
| 属性 | 说明 |
| :---: | :---: |
| .string | 待匹配的文本 |
| .re | 匹配时使用的pattern对象(正则表达式) |
| .pos | 正则表达式搜索文本的开始位置 |
| .endpos | 正则表达式搜索文本的结束位置 |

## Match对象的放法
- match对象是一次正则匹配的结果
- match对象包含了很多匹配的相关信息
| 放法 | 说明 |
| :---: | :---: |
| .group(0) | 获得匹配后的字符串 |
| .start() | 匹配字符串在原始字符串的开始位置 |
| .end() | 匹配字符串在原始字符串的结束位置 |
| .span() | 返回(.start(), .end()) |

## 贪婪匹配
- Re库默认采用贪婪匹配，即输出匹配最长的字串
下面给出最小匹配操作符
| 操作符 | 说明 |
| :---: | :---: |
| *? | 前一个字符0次或无限次扩展，最小匹配 |
| +? | 前一个字符1次或无限次扩展，最小匹配 |
| ?? | 前一个字符0次或1次扩展，最小匹配 |
| {m,n}? | 前一个字符m次至n次(含n)，最小匹配 |

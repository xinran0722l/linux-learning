## BeautifulSoup4 
- BeautifulSoup库用于对爬取下来的html&XML页面解析
```py
from bs4 import BeautifulSoup4
soup = BeautifulSoup('<p>data</p>', 'html.parser')
print(soup.prettify())
```

## Beautiful Soup库解析器
| 解析器 | 描述 |  条件 |
| :---: | :---: | :---: |
| bs4的HTML解析器 | BeautifulSoup("mk", 'html.parser") | 安装bs4库| 
| lxml的HTML解析器 | BeautifulSoup("mk", 'lxml") | pip install lxml | 
| lxml的HTML解析器 | BeautifulSoup("mk", 'xml") | pip install lxml | 
| html5lib的HTML解析器 | BeautifulSoup("mk", 'html5lib") | pip install html5lib | 


## Beautiful Soup类的基本元素
| 解析器 | 描述 |
| :---: | :---: |
| Tag | 标签，最基本的信息组织单元，分别用<>和</>标明开头和结尾 |
| Name | 标签的名字，<p>...</p>的名字是“p”，格式：<tag>.name |
| Attributes | 标签的属性，字典形式组织，格式：<tag>.attrs |
| NavigableString | 标签内非属性字符串，<>/..</>中的字符串，格式：<tag>.string |
| Comment | 标签内字符串的注释部分， 一种特殊的Comment类型 |

## 标签树的下行遍历
| 属性 | 描述 |
| :---: | :---: |
| .contents | 子节点的列表，将<tag>所有儿子节点存入列表 |
| .children | 子节点的迭代类型，与.content类型，用于循环遍历儿子节点 |
| .descendants | 子孙节点的迭代类型，包含所有子孙节点，用于循环遍历 |
```py
遍历儿子节点
for child in soup.body.children:
  print(child)

遍历子孙节点
for child in soup.body.descendants:
  print(child)
```

## 标签树的上行遍历
| 属性 | 描述 |
| :---: | :---: |
| .parent | 节点的父亲标签 |
| .parents | 节点先辈标签的迭代类型，用于循环遍历先辈节点 |

- 遍历一个标签的所有先辈标签时，会遍历到soup本身，会返回```None```
```py
soup = BeautifulSoup(demo, "html.parser")
遍历a标签的父节点
for parent in soup.a.parents:
  if parent is None:
    print(parent)
  else:
    print(parent.name)
```

## 标签树的平行遍历
- 平行遍历发生在同一个父节点下的各节点间
| 属性 | 描述 |
| :---: | :---: |
| .next_sibling | 返回按照HTML文本顺序的下一个平行节点标签 |
| .previous_siling | 返回按照HTML文本顺序的上一个平行节点标签 |
| .next_siblings | 迭代类型，返回按照HTML文本顺序的后续所有平行节点标签 |
| .previous_silings | 迭代类型，返回按照HTML文本顺序的前序所有平行节点标签 |
```py
遍历a标签的的后续节点
for sibling in soup.a.next_siblings:
  print(sibling)

遍历a标签的的前序节点
for sibling in soup.a.previous_siblings:
  print(sibling)
```


## 提取信息
```py
获取一段html中所有链接的方法
for link in soup.find_all("a"):
  print(link.get("href"))
```

- <>.find_all(name,attrs,recursive,string,**kwargs)
- 返回一个列表，存储查找的结果
- name: 对标签名称的检索字符串，可以是string，list
  - 如果是True，则返回所有的标签名称
  - 也可以传入正则，返回相匹配的标签
- attrs: 对标签属性值的检索字符串，可标注属性检索
- recursive: 是否对子孙全部检索，默认是True
- string: <>...</>中字符串区域的检索字符串


- 由于find_all方法非常常用，以下有2种简写方法
```py
<tag>(...) 等价于 <tag>.find_all(...)
soup(...) 等价于 soup.find_all(...)
```
## find_all的7个扩展方法
| 方法 | 描述 |
| :---: | :---: |
| <>.find() | 搜索且只返回一个结果，字符串类型，同.find_all()参数 |
| <>.find_parents() | 在先辈节点中搜索，返回列表类型，同.find_all（）参数 |
| <>.find_parent() | 在先辈节点中返回一个结果，字符串类型，同.find()参数 |
| <>.find_next_siblings() | 在后续平行节点中搜索，返回列表类型，同.find_all()参数 |
| <>.find_next_sibling() | 在后续平行节点中返回一个结果，字符串类型，同.find()参数 |
| <>.find_previous_siblings() | 在前续平行节点中搜索，返回列表类型，同.find_all()参数 |
| <>.find_previous_sibling() | 在前续平行节点中返回一个结果，字符串类型，同.find()参数 |

## module import
- 自定义的模块在同级目录下可以直接引入文件名
- 若自定义模块不在当前目录下，则需要引入```sys```标准库
- 之后通过修改```sys.path```列表来添加待引入模块的路径
- ```__file__```变量代表当前文件的绝对路径
- ```os.path.dirname()```代表当前目录的绝对路径，以上均为动态值

## package
- 只要目录下有一个```__init__.py```文件，这个目录就是包

## OS library
- 得到当前工作目录，```os.getcwd()```
- 返回指定目录下的文件名和目录名: ```os.listdir()```
- 删除一个文件: ```os.remove()```
- 删除多个目录: ```os.removedirs(r"c:\python")```
- 检查给出的路径是否为一个文件: ```os.path.isfile()```
- 检查给出的路径是否为一个目录: ```os.path.isdir()```
- 检查给出的路径是否真实存在: ```os.path.exists()```
- 获取路径名: ```os.path.dirname()```
- 获得绝对路径: ```os.path.abspath()```
- 获取文件名: ```os.path.basename()```
- 运行shell命令: ```os.system()```
- 重命名: ```os.rename(old, new)```
- 创建多级目录: ```os.makedirs(r"c:\python\test")```
- 创建单个目录: ```os.mkdir("test")```
- 获取文件属性: ```os.stat(file)```
- 获取文件大小: ```os.path.getsize(filename)```

## sys library
- 获取系统环境变量 ```sys.path```
- 获取脚本参数 ```sys.argv```

## datetime library
- 相比于time模块，datetime模块的接口更直观
- datetime.date: 表示日期的类，常用属性有year，month，day
- datetime.time: 表示时间的类，常用属性：hour，minute，second，microsecond
- datetime.datetime: 表示日期时间
- datetime.timedelta: 表示时间间隔，即两个时间点之间的长度
- datetime.tzinfo: 与时区有关的信息

- ```d=datetime.datetime.now()```返回当前的datetime日期类型
  * d.timestamp(),d.today(),d.year(),d.timetuple()等方法可以调用
- ```datetime.date.fromtimestamp(时间戳)```把一个时间戳转为datetime日期类型
- 时间运算
```py
>>> datetime.datetime.now()
datetime.datetime(2022, 10, 5, 9, 32, 26, 157134)

>>> datetime.datetime.now() + datetime.timedelta(4)	# 当前时间+4天
datetime.datetime(2022, 10, 9, 9, 33, 54, 449055)

>>> datetime.datetime.now() + datetime.timedelta(hours=5)	# 当前时间+4小时
datetime.datetime(2022, 10, 5, 14, 35, 18, 124386)

```

- 时间替换
```py
>>> datetime.datetime.now().replace(year=1949,month=10,day=1)
datetime.datetime(1949, 10, 1, 9, 38, 46, 852179)
```

## excel 处理
```py
from openpyxl import Workbook

wb = Workbook()	#实例化
sheet = wb.active

sheet.title = "qinghuo"
sheet["B7"] = "Alex"
sheet["C7"] = 18
sheet["D7"] = "man linux is free ,as jira"
sheet["C7"] = 81
sheet["F7"] = "python"

sheet.append([5,6,7,8,9,11])	# append是在上次操作的最后面追加
sheet["A2"] = datetime.datetime.now()

wb.save("excel_test.xlsx")	# 不指定路径则默认当前目录下
```

## 遍历表
```py
from openpyxl import Workbook, load_workbook

wb = load_workbook("E:\\test\excel_test.xlsx")  # 打开文件
print(wb.sheetnames)  # 获取所有sheetnames (表名)
sheet = wb["qinghuo"]   # 打开 表
print(sheet["B5"].value)  # 打印当前列的内容
print(sheet["B5:B10"])  # 打印特定范围内的内容(元组)

# 打印特定范围内，具体信息  (按列遍历)
for cell in sheet["B5:B10"]:
    print(cell[0].value)    #元组

# 遍历整个表
for row in sheet:   # 遍历行
    # print(row)
    for cell in row:    # 遍历列
        print(cell.value,end="\t")
    print()

# 指定遍历范围               start3   end9        遍历3列
for row in sheet.iter_rows(min_row=3,max_row=9,max_col=3):
    for cell in row:
        print(cell.value,end="\t")
    print()

# 按列循环
for col in sheet.columns:
    for row in col:
        print(row.value,end="\t")
    print()

# 按列指定范围
for col in sheet.iter_cols(min_col=2,max_col=4,min_row=1,max_row=4):
    for row in col:
        print(row.value,end="\t")
    print()

# 删除表
# wb.remove(sheet)
# del wb[sheet]


sheet["B5"] = "更改后"

wb.save("E:\\test\excel_test2.xlsx")    # 另存为一个文件，也可直接覆盖
```

## excel style
```py
# 接上
from openpyxl.styles import Font,colors,Alignment

sheet["B5"] = "更改后"

#           字体名                   		  斜体
myFont = Font(name='宋体', size=20, italic=True, color=colors.BLUE)

sheet["B5"].font = myFont

#                       走向，校准           垂直                    水平
sheet["B5"].alignment = Alignment(vertical="center",horizontal="center")

# 第2行行高
sheet.row_dimensions[2].height = 80
# C列列宽
sheet.column_dimensions["C"].width = 30

wb.save("E:\\test\excel_test3.xlsx")   
```

## 定时发送email
- SMTP(Simple Mail Transfer Protocol) 简单邮件传输协议
  * 它是一组用于源地址到目的地址传送邮件的规则，由他来控制新建的中转方式
- 想要实现发送邮件需要经过一下几步:
  * 1.登录 邮件服务器
  * 2.构造符合邮件协议规则要求的邮件内容
  * 3.发送
- Python对SMTP支持有```smtplib```和```email```两个模块
  * ```email```负责构造邮件
  * ```smtplib```负责发送邮件，它对smtp协议进行了简单封装

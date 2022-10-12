# Scrapy爬虫框架结构
- 5+2结构，5个模块，2个中间件
- Scrapy是为持续运行设计的专业爬虫框架，提供操作的Scrapy命令行
- Scrapy采用命令行，更容易自动化，适合脚本控制

## Engine
- scrapy的核心，控制所有模块之间的数据流
- 根据条件触发事件

## Downloader
- 根据请求下载网页

## Scheduler
- 对所有爬取请求进行调度管理

## Downloader middleware
- 目的 实施Engine, Scheduler和Downloader之间进行用户可配置的控制
- 功能: 修改，丢弃，新增请求或响应 

## Spider
- 解析Downloader返回的响应(Response)
- 产生爬取项(scraped item)
- 产生额外的爬取请求(Request)

## Item Pipelines
- 以流水线方式处理Spider产生的爬取项
- 以一组操作顺序组成，类似流水线，每个操作是一个Item Pipeline类型
- 操作包括：清理，检验和查重爬取项中的HTML数据，将数据存储到数据库

## Spider Middleware
- 目的：对请求和爬取项的再处理
- 功能：修改，丢弃，新增请求或爬取项


## Requests vs Scrapy
- 相同点：
  * 两者都可以进行页面请求和爬取，Python爬虫的两个重要技术路线
  * 两者可用性都好，文档丰富，入门简单
  * 两者都没有处理js，提交表单，应对见证吗等功能(可扩展)

- 不同点：

| Requests | Scrapy |
| :---: | :---: |
| 页面级爬虫 | 网站级爬虫 | 
| 功能库 | 框架 | 
| 并发性不足，功能较差 | 并发性好，功能较高 | 
| 重点在于页面下载 | 重点爬虫结构 | 
| 定制灵活 | 一般定制灵活，深度定制困难 | 
| 上手简单 | 入门稍难 | 


## Scrapy 常用命令
| 命令 | 说明 | 格式 |
| :---: | :---: | :---: |
| startproject | 创建一个新工程 | scrapy startproject <name> [dir] |
| genspider | 创建一个爬虫 | scrapy genspider [options] <name> <domain> |
| settings | 获得爬虫配置信息 | scrapy settings [options] |
| crawl | 运行一个爬虫 | scrapy crawl <spider> |
| list | 列出工程中所有爬虫 | scrapy list |
| shell | 启动URL调试命令行 | scrapy shell [url] |


## Scrapy默认目录结构
- 以创建一个```python123demo```工程为例
- 命令行中键入```scrapy staartproject python123demo```会生成一个文件夹
  * 其内容如下
```py
  python123demo/    -> 外层目录
  scrapy.cfg        -> 部署Scrapy爬虫的配置文件
  python123demo/    -> scrapy框架的用户自定义Python代码
    __init__.py     -> 初始化脚本
    items.py        -> Items代码模板(继承类)
    middlewares.py  -> Middlewares代码模板(继承类)
    pipelines.py    -> Pipelines代码模板(继承类)
    settings.py     -> Scrapy爬虫的配置文件
    spiders/        -> Spiders代码模板目录(继承类)
      __init__.py    -> 初始文件，无需修改
     __pycache__/    -> 缓存目录，无需修改
```
- 之后通过```scrapy genspider demo python123.io```生成一个爬虫
  * 会在```spiders/```下生成一个名为```demo```的文件，


## yield
- yield <-> 生成器
- 生成器是一个不断产生值的函数
- 包含yield语句的函数是一个生成器
- 生成器每次产生一个值(yield语句)，函数被冻结，被唤醒后再产生一个值
```py
def gen(n):
  for i in range(n):
    yield i**2

for i in gen(5):
  print("i", " ", end="")
0 1 4 9 16
```

### 为什么要有生成器？
- 生成器相比一次列出所有内容的优势
  * 更节省存储空间
  * 响应更循序
  * 使用更灵活

## Scrapy爬虫使用步骤
- 1.创建一个工程和Spider模板
- 2.编写Spider
- 3.编写Item Pipeline
- 4.优化配置策略

- Scrapy爬虫的数据类型
  * Request类
  * Response类
  * Item类

####  Request 类
- class scrapy.http.Request()
  * Request对象表示一个HTTP请求
  * 由Spider生成，由Downloader执行

| 属性或方法 | 说明 |
| :---: | :---: |
| .url | Request对应的请求URL地址 | 
| .method | 对应的请求方法，GET，POST等 | 
| .headers | 字典类型风格的请求头 | 
| .body | 请求内容主体，字符串类型 | 
| .meta | 用户添加的扩展信息，在Scrapy内部模块间传递信息使用 | 
| .copy() | 复制该请求 | 

#### Response类
- class scrapy.http.Response()
  * Response对象表示一个http响应
  * 由Downloader生成，由Spider处理

| 属性或方法 | 说明 |
| :---: | :---: |
| .url | Response对应的URL地址 | 
| .status | HTTP状态码，默认是200 | 
| .headers | Response对应的头部信息 |
| .body | Response对应的内容信息，字符串类型 |
| .flags | 一组标记 |
| .request | 产生Response类型对应的Request对象 |
| .copy() | 复制该响应 |

#### Item类
- class scrapy.item.Item()
  * Item对象表示一个从HTML页面中提取的信息内容
  * 由Spider生成，由Item Pipeline处理
  * Item类似字典类型，可以按照字典类型操作


### Scrapy爬虫提取信息的方法
- Scrapy爬虫支持多种HTML信息提取方法
- Beautiful Soup
- lxml
- re
- XPath Selector
- CSS Selector


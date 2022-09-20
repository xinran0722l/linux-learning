## HTTP协议
- HTTP是一个基于```请求与响应```模式的，无状态的应用层协议
- HTTP协议采用URL作为定位网络资源的标识
- URL格式：http://host[:port][path]
- host：合法的Internet主机域名或ip地址
- prot：端口号，缺省端口为80
- path：请求资源的路径
- URL是通过HTTP协议存取资源的一个Internet路径
- 一个URL对应一个数据资源

## Requests method
| 方法 | 描述 | 
| :---: | :---: |
| requests.request() | 构造一个请求，支撑以下各方法的基础方法 | 
| requests.get() | 获取HTML网页的主要方法，对应HTTP的GET | 
| requests.head() | 获取HTML网页的头信息的方法，对应HTTP的HEAD | 
| requests.post() | 向HTML网页提交POST请求，对应HTTP的POST | 
| requests.put() | 向HTML网页提交PUT请求，对应HTTP的PUT | 
| requests.patch() | 向HTML网页提交局部修改请求，对应HTTP的PATCH | 
| requests.delete() | 向HTML网页提交删除请求，对应HTTP的DELETE | 

```py
requests.get( url, params=None, **kwargs )
url: 拟获取页面的url链接
params: url中的额外参数，字典或字节流格式，可选
**kwargs： 12个控制访问的参数，

requests.head(url, **kwargs)
**kwargs: 13个控制访问的参数

requests.post(url,data=None,json=None,**kwargs)
data:字典，字节序列或文件，Request的内容
json: JSON格式的数据，Request的内容
**kwargs: 11个控制访问的参数

requests.put(url,data=None,**kwargs)
**kwargs: 12个控制访问的参数

requests.patch(url,data=None,**kwargs)
**kwargs: 12个控制访问的参数

requests.delete(url,**kwargs)
url: 拟删除页面的url链接
*8kwargs：13个控制访问的参数
```

## Requests.requests解析
```py
requeasts.request( method, url, **kwargs )
请求方式
r = requests.request( "GET". url, **kwargs )
r = requests.request( "HEAD". url, **kwargs )
r = requests.request( "POST". url, **kwargs )
r = requests.request( "PUT". url, **kwargs )
r = requests.request( "PATCH". url, **kwargs )
r = requests.request( "delete". url, **kwargs )
r = requests.request( "OPTIONS". url, **kwargs )
    options指向服务器获取服务器和客户端打交道的参数,不直接获取资源
```
* **kwargs: 控制访问的参数，均为可选项
  -  params: 自带你或字节序列，作为参数增加到url中
  -  data: 字典，字节序列或文件对象，作为Request的内容
  - json: JSON格式的数据，作为Request的内容
  -  headers: 字典，HTTP定制头
  - cookies: 字典或CookieJar，Request中的cookie
  - auth: 元组，支持HTTP认证功能
  - files: 字典类型，传输文件
  - timeout: 设定超时时间，秒为单位
  - proxies: 字典类型，设定访问代理服务器，可以增加登录认证
  - allow_redirects: True/False,默认为True，重定向开关
  - stream: True/False,默认为True，获取内容立即下载开关
  - verify: True/False,默认为True，获取SSL证书开关
  - cert：本地SSL证书路径
- 

## Response对象的属性
| 属性 | 描述 | 
| :---: | :---: |
| r.status_code | HTTP请求的返回状态码，200表示连接成功，404表示失败 | 
| r.text | HTTP响应内容的字符串形式，即，url对应的页面内容 | 
| r.encoding | 从HTTP header中猜测的相应内容编码方式 | 
| r.apparent_encoding | 从内容中分析出的响应内容编码方式(备选编码方式) | 
| r.content | HTTP响应内容的二进制形式 | 

## 爬虫的限制
- 来源审查：判断User-Agent进行限制
  - 检查来访HTTP协议头的User-Agent域，只响应浏览器或友好爬虫的访问
- 发布公告：Robots协议
  - 告知所有爬虫网站的爬取策略，要求爬虫遵守

## Robots协议
- Robots Exclusion Standard 网络爬虫排除标准
- 作用：网站告知网络爬虫哪些页面可以爬取，哪些不行
- 形式：在网站根目录下的robots.txt文件

```py
# 注释 * 代表所有 /代表根目录
User-Agent: *   代表所有爬虫
Disallow：/     代表禁止爬取根目录
```

## Requests库的异常
| Error | 描述 | 
| :---: | :---: |
| requests.ConnectionError | 网络连接错误异常，如DNS查询失败，拒绝连接等 | 
| requests.HttpError | HTTP错误异常 | 
| requests.URLRequired | URL缺失异常 | 
| requests.TooManyRedirects | 超过最大重定向次数，产生重定向异常 | 
| requests.ConnectTimeout | 连接服务器超时异常(特指连接服务器) | 
| requests.Timeout | 请求URL超时，产生超时异常(包括等待服务器返回信息的时间) | 
| requests.raise_for_status() | 如果不是200，产生requests.HTTPError | 


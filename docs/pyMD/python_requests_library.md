
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
```

## Response对象的属性
| 属性 | 描述 | 
| :---: | :---: |
| r.status_code | HTTP请求的返回状态码，200表示连接成功，404表示失败 | 
| r.text | HTTP响应内容的字符串形式，即，url对应的页面内容 | 
| r.encoding | 从HTTP header中猜测的相应内容编码方式 | 
| r.apparent_encoding | 从内容中分析出的响应内容编码方式(备选编码方式) | 
| r.content | HTTP响应内容的二进制形式 | 

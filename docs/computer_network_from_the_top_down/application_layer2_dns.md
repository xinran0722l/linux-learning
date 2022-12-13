# 应用层(续)
## DNS (Domain Name System)
- DNS的必要性
  * IP地址标识主机，路由器
  * 但IP地址不好记忆，不便于人类使用
  * 存在着字符串-IP地址的转换的必要性
  * 人类用户提供要访问机器的"字符串"名称
  * 由DNS负责转换成为二进制的网络地址

#### DNS系统需要解决的问题
1. 如何命名设备
  - 用有意义的字符串
  - 解决一个平面命名的重名问题：层次化命名
2. 如何完成名字到IP地址的转换
  - 分布式的数据库维护和响应名字查询
3. 如何维护：
  - 增加或删除一个域，需要在域名系统中做哪些工作

#### 问题1,DNS命名空间(The DNS Name Space)
- DNS域名结构
  * 一个层面明明设备会有很多重名
  * DNS采用层次树状结构的命名方法
  * Internet根被划为几百个顶级域(Top Lever Domainss)
    - 通用的(Generic)
      * .com .edu .int .gov .net .org .rec .web ...
    - 国家的(Countries)
      * .cn .us .nl .jp
  * 每个(子)域下面可划分为若干子域(Subdomains)
  * 树叶是主机

- 域名(Domain Name)
  * 从本域往上，直到树根
  * 中间使用"."间隔不同的级别
  * 例如：
    - ustc.edu.cn
    - auto.ustc.edu.cn
  * 域的域名：可以用来表示一个域
  * 主机的域名：一个域上的一个主机

- 域名的管理
  * 一个域管理其下的子域
    - .jp被划分为 ac.jp co.jp
    - .cn被划分为 edu.cn com.cn
  * 创建一个新的域，必须征得它所属的域的同意
- 域与物理网络无关
  * 域遵从组织界限，而不是物理网络
    - 一个域的主机可以不在同一个网络
    - 一个网络的主机不一定在一个域
  * 域的划分是逻辑的，而不是物理的


#### 问题2：解析问题 - 名字服务器(Name Server)
- 一个名字服务器的问题
  * 可靠性问题：单点故障
  * 扩展性问题：通信容量
  * 维护问题：远距离的集中式数据库
- 区域(Zone)
  * 区域的划分有区域管理者自己决定
  * 将DNS名字空间划分为互不相交的区域，每个区域都是树的一部分
  * 名字服务器：
    - 每个区域都有一个名字服务器，维护者它所有管辖区域的权威信息(Authoritative Record)
    - 名字服务器允许被放置在区域之外，以保障可靠性
- ```权威DNS服务器：```
  * 组织机构的DNS服务器，提供组织机构服务器(如Web和Mail)可访问的主机和IP之间的映射
  * 组织机构可以选择实现自己维护或由某个服务提供商来维护

- TLD服务器
  * 顶级域(TLD)服务器:
    - 负责顶级域名和所有国家级的顶级域名
    - 顶级域名如com,org,net,edu,gov
    - 国际级顶级域名如cn,uk,fr,ca,jp
  * Network olutions公司负责维护com TLD服务器
  * Educause公司负责维护edu TLD服务器

### 区域名字服务器维护资源记录
- 资源记录(Resource Records)
  * 作用：维护 域名-IP地址(其他)的映射关系
  * 位置：Name Server的分布式数据库中
- RR格式：(Domain_Name,ttl,type,class,Value)
  * Domain_name：域名
  * Ttl：time to live：生存时间(权威，缓冲记录)
  * Class类别：对于Internet，值为IN
  * Value值：可以是数字，域名或ASCII串
  * Type类别：资源记录的类型

### DNS记录
- DNS：保存资源记录(RR)的分布式数据库
  * RR格式(name, value, type, ttl)
- Type=A
  * Name为主机，Value为IP地址
- Type=CNAME
  * Name为规范名字的别名
  * www.ibm.com的规范名字为servereast.backup2.ibm.com
  * value为规范名字
- Type=NS
  * Name域名(如foo.com)
  * Value为该域名的权威服务器的域名
- Type=MX
  * Value为name对应的邮件服务器的名字

- TTL：生存时间，决定了资源记录应当从缓存中删除的时间

## DNS大致工作过程
- 应用调用解析器(Resolver)
- 解析器作为客户，向Name Server发出查询报文(封装在UDP段中)
- Name Server返回响应报文(name/ip)

#### 本地名字服务器(Local Name Server)
- 并不严格属于层次结构
- 每个ISP(居民区的ISP，工资，大学)都有一个本地的DNS服务器
  * 也称为"默认名字服务器"
- 当一个主机发起一个DNS查询时，查询被送到其本地DNS服务器
  * 起着代理的作用，将查询转发到层次结构中

#### 名字服务器(Name Server)
- 名字解析过程
  * 目标名字在Local Name Server中
    1. 查询的名字在该区域内部
    2. 缓存(cashing)

  * 当与本地名字服务器不能解析名字时
    - 联系根名字服务器，顺着根-TLD一直找到权威名字服务器

- 递归查询
  * 名字解析负担都放在当前联络的名字服务器上
  - 问题：跟服务器的负担太重
  - 解决：迭代查询(Iterated Queries)

- 迭代查询
  * 主机cis.poly.edu想知道主机gaia.cs.umass.edu的IP地址
  * 根(及各级域名)服务器返回的不是查询结果，而是下一个NS的地址
  * 最后由权威名字服务器给出解析结果
  * 当前联络的服务器给出可以联系的服务器的名字
  * "我不知道这个名字,但可以像这个服务器请求"

#### DNS 协议,报文
- DNS协议：```查询```和```响应```报文的```报文格式```相同
- 报文首部
  * 标识符(ID): 16位
  * flags：
    - 查询/应答
    - 希望递归
    - 递归可用
    - 应答为权威

- 提高性能：缓存
  * 一旦名字服务器学到了一个映射，就将该映射```缓存```起来
  * 跟服务器通常都在本地服务器中缓存着
    - 是的跟服务器不用经常被访问
  * 目的：提高效率
  * 可能存在的问题：
    - 如果情况变化，缓存结果和权威资源记录不一致
  * 解决方案：TTL(默认2天)

#### 问题3：维护问题：新增一个域
- 在上级域的名字服务器中增加两条记录，指向这个```新增的子域的域名```和```域名服务器的地址```
- 在新增子域的名字服务器上运行名字服务器，负责本欲的名字解析： 名字->IP地址
- 例子：在com域中建立一个”Network Utopia“
  * 到注册等级机构注册域名 networkUtopia.com
    - 需要向该机构提供权威DNS服务器(基本的，和辅助的)的名字和IP地址
    - 登记机构在com TLD服务器中插入两条RR记录
    (networkutopia.com, dnsl.networkutopia.com,NS)
    (dnsl.networkutopia.com, 212.212.212.1, A)
  * 在networkutopia.com的权威服务器中确保有
    - 用于Web服务器的www.networkutopia.com的类型位A的记录
    - 用于邮件服务器的mail.networkutopia.com的类型为MX的记录


## DNS(Domain Name System)总体思路和目标
- DNS的主要思路
  * ```分层的```，基于域的命名机制
  * 若干```分布式```的数据库完成名字到IP地址的转换
  * 运行在```UDP```之上端口号为53的```应用```服务
  * 核心的Internet功能，但以应用层协议实现
    - 在网络边缘处理复杂性

- DNS主要目的：
  * 实现主机名 - IP地址的转换(name / IP translate)
  * 其他目的
    - ```主机别名```到```规范名字```的转换：Host aliasing
    - 邮件服务器```别名```到邮件服务器的```正规名字```的转换：Mail server aliasing
    - ```负载均衡```：Load Distribution


#### 攻击DNS
详见教材

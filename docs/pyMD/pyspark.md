## PySpark

使用PySpark库完成数据处理，首先需要构建一个执行环境入口对象，
PySpark的执行环境入口对象是：*类SparkContext*的类对象

```python

# 导包
from pyspark import SparkConf,SparkContext
# 创建SparkConf类对象
conf = SparkConf().setMaster("local[*]").setAppName("test_spark_app")
# 基于SparkConf类对象创建SparkContext对象
sc = SparkContext(conf=conf)
# 打印PySpark的运行版本
print(sc.version)
# 停止SparkContext对象的运行(停止PySpark程序)
sc.stop()
# 23/01/02 21:49:54 WARN Utils: Your hostname, myarch resolves to a loopback address: 127.0.0.1; using 192.168.3.5 instead (on interface wlan0)
# 23/01/02 21:49:54 WARN Utils: Set SPARK_LOCAL_IP if you need to bind to another address
# 23/01/02 21:49:55 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
# 3.3.1 对应print的输出，上面3行是PySpark自身的输出
```

#### Rdd对象

pyspark支持多种数据的输入，在输入完成后，都会得到一个：RDD类的对象

RDD(Resilient Distributed Datasets) 弹性分布式数据集

PySpark针对数据的处理，都是以RDD对象为载体，即：*数据存储在RDD内*，
*各类数据的计算方法，也都是RDD的成员方法*，*RDD的数据计算方法，返回值依旧是RDD对象*

```python

"""
通过PySpark代码加载数据(数据输入)
"""
from pyspark import SparkConf,SparkContext

conf = SparkConf().setMaster("local[*]").setAppName("test_spark")
sc = SparkContext(conf=conf)

# 通过parallelize方法将Python对象加载到Spark内，成为RDD对象
rdd1 = sc.parallelize([1,2,3,4])
rdd2 = sc.parallelize((5,6,7,8))
rdd3 = sc.parallelize("abcdef")
rdd4 = sc.parallelize({11,12,13,14})
rdd5 = sc.parallelize({"k1":"v1","k2":"v2"})

# 如果要查看RDD的内容，需要用RDD.collect()方法
print(rdd1.collect())
print(rdd2.collect())
print(rdd3.collect())
print(rdd4.collect())
print(rdd5.collect())
# 23/01/02 22:04:04 WARN Utils: Your hostname, myarch resolves to a loopback address: 127.0.0.1; using 192.168.3.5 instead (on interface wlan0)
# 23/01/02 22:04:04 WARN Utils: Set SPARK_LOCAL_IP if you need to bind to another address
# 23/01/02 22:04:05 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
# [1, 2, 3, 4]
# [5, 6, 7, 8]
# ['a', 'b', 'c', 'd', 'e', 'f']
# [11, 12, 13, 14]
# ['k1', 'k2']

#通过textFile方法，读取文件数据加载到Spark内，成为RDD对象
rdd = sc.textFile("../test_file/txt.txt")
print(rdd.collect())
sc.stop()

# 23/01/02 22:11:14 WARN Utils: Your hostname, myarch resolves to a loopback address: 127.0.0.1; using 192.168.3.5 instead (on interface wlan0)
# 23/01/02 22:11:14 WARN Utils: Set SPARK_LOCAL_IP if you need to bind to another address
# 23/01/02 22:11:15 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
# ['Make English as your working language. （让英语成为你的工作语言）', 'Practice makes perfect. （熟能生巧）', 'All experience comes from mistakes. （所有的经验都源于你犯过的错误）', "Don't be one of the leeches. （不要当伸手党）", 'Either outstanding or out. （要么出众，要么出局）']
```

## 数据计算

PySpark的数据计算，都是基于RDD对象来进行的，如何进行呢？
自然是依赖，RDD对象内置丰富的：成员方法(算子)

- map方法
    * map算子，将RDD的数据一条条处理(基于map中接收的处理函数)，返回新的RDD
    * 对于返回值是新RDD的算子，可以通过链式调用多次调用算子

```python
from pyspark import SparkConf,SparkContext

conf = SparkConf().setMaster("local[*]").setAppName("test_spark")
sc = SparkContext(conf=conf)

# 准备一个RDD
rdd = sc.parallelize([1,2,3,4,5])

rdd2 = rdd.map(lambda x: x*10).map(lambda x: x+5)

print(rdd2.collect())
# 23/01/02 22:26:00 WARN Utils: Your hostname, myarch resolves to a loopback address: 127.0.0.1; using 192.168.3.5 instead (on interface wlan0)
# 23/01/02 22:26:00 WARN Utils: Set SPARK_LOCAL_IP if you need to bind to another address
# 23/01/02 22:26:01 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
# [15, 25, 35, 45, 55]
```
***

- flatMap算子
    * 对RDD执行map操作，然后进行*解除嵌套*

```python
from pyspark import SparkConf,SparkContext

conf = SparkConf().setMaster("local[*]").setAppName("test_spark")
sc = SparkContext(conf=conf)

rdd = sc.parallelize(["apple linux windows","java python c++","data date"])

rdd2 = rdd.map(lambda x: x.split(" "))
print(rdd2.collect())
# [['apple', 'linux', 'windows'], ['java', 'python', 'c++'], ['data', 'date']]

rdd3 = rdd.flatMap(lambda x: x.split(" "))
print(rdd3.collect())
# ['apple', 'linux', 'windows', 'java', 'python', 'c++', 'data', 'date']
```
***

- reduceByKey算子
    * *针对KV型*RDD,自动按Key分组，然后根据聚合逻辑，完成*组内数据(value)*的聚合

```python
from pyspark import SparkConf,SparkContext

conf = SparkConf().setMaster("local[*]").setAppName("test_spark")
sc = SparkContext(conf=conf)

rdd = sc.parallelize([('man',1),('man',2),('woman',10),('woman',20)])

rdd2 = rdd.reduceByKey(lambda a,b: a+b)
print(rdd2.collect())
# [('woman', 30), ('man', 3)]
```

***

- 练习

```python
"""文件存放目录位于./material_py/pyspark/hello.txt"""
"""读取文件，并统计每个单词出现了多少次"""
from pyspark import SparkConf,SparkContext

conf = SparkConf().setMaster("local[*]").setAppName("test_spark")
sc = SparkContext(conf=conf)

rdd = sc.textFile("./data/hello.txt")
# print(rdd.collect())
# ['itheima itheima itcast itheima', 'spark python spark python itheima', 'itheima itcast itcast itheima python', 'python python spark pyspark pyspark', 'itheima python pyspark itcast spark']

word_rdd = rdd.flatMap(lambda x: x.split(" "))
# print(word_rdd.collect())
# ['itheima', 'itheima', 'itcast', 'itheima', 'spark', 'python', 'spark', 'python', 'itheima', 'itheima', 'itcast', 'itcast', 'itheima', 'python', 'python', 'python', 'spark', 'pyspark', 'pyspark', 'itheima', 'python', 'pyspark', 'itcast', 'spark']

word_with_one_rdd = word_rdd.map(lambda x: (x,1))

result_rdd = word_with_one_rdd.reduceByKey(lambda a,b: a + b)
print(result_rdd.collect())
# [('itcast', 4), ('python', 6), ('itheima', 7), ('spark', 4), ('pyspark', 3)]
```

***

- filter,过滤想要的数据进行保留
    * 接收一个函数，返回是True的数据

```python
from pyspark import SparkConf,SparkContext

conf = SparkConf().setMaster("local[*]").setAppName("test_spark")
sc = SparkContext(conf=conf)

rdd = sc.parallelize([1,2,3,4,5])

rdd2 = rdd.filter(lambda x: x % 2 == 0)

print(rdd2.collect())
# [2, 4]
```

***

- distinct--对数据去充，无参数

```python
from pyspark import SparkConf,SparkContext

conf = SparkConf().setMaster("local[*]").setAppName("test_spark")
sc = SparkContext(conf=conf)

rdd = sc.parallelize([1,1,2,2,3,4,4,5,6])

rdd2 = rdd.distinct()

print(rdd2.collect())
# [1, 2, 3, 4, 5, 6]
```

***

- sortBy--对RDD数据进行排序，基于传入的排序依据
```python
rdd.sortBy(func, ascending=False, numPartitions=1)
#func: (T) -> U : 
#    告知按照rdd中的哪个数据进行排序(如lambda x : x[1],按照rdd中第二列元素进行排序)
#ascending True升序，False降序
#numPartitions: 用多少分区排序
```

```python
from pyspark import SparkConf,SparkContext

conf = SparkConf().setMaster("local[*]").setAppName("test_spark")
sc = SparkContext(conf=conf)

rdd = sc.textFile("./data/hello.txt")
# print(rdd.collect())
# ['itheima itheima itcast itheima', 'spark python spark python itheima', 'itheima itcast itcast itheima python', 'python python spark pyspark pyspark', 'itheima python pyspark itcast spark']

word_rdd = rdd.flatMap(lambda x: x.split(" "))
# print(word_rdd.collect())
# ['itheima', 'itheima', 'itcast', 'itheima', 'spark', 'python', 'spark', 'python', 'itheima', 'itheima', 'itcast', 'itcast', 'itheima', 'python', 'python', 'python', 'spark', 'pyspark', 'pyspark', 'itheima', 'python', 'pyspark', 'itcast', 'spark']

word_with_one_rdd = word_rdd.map(lambda x: (x,1))

result_rdd = word_with_one_rdd.reduceByKey(lambda a,b: a + b)
# print(result_rdd.collect())
# [('itcast', 4), ('python', 6), ('itheima', 7), ('spark', 4), ('pyspark', 3)]

#对上述结果降序输出
final_rdd = result_rdd.sortBy(lambda x: x[1], ascending=False, numPartitions=1)
print(final_rdd.collect())
# [('itheima', 7), ('python', 6), ('itcast', 4), ('spark', 4), ('pyspark', 3)]
```

***

- 小练习，文件存放目录为./material_py/pyspark/orders.txt

```python
"""
1. 各个城市销售额排名，从大到小
2. 全部城市，有哪些商品类别在售卖
3. 北京市有哪些商品类别在售卖
"""
from pyspark import SparkConf,SparkContext
import json

conf = SparkConf().setMaster("local[*]").setAppName("test_spark")
sc = SparkContext(conf=conf)

path = "./data/orders.txt"
frdd = sc.textFile(path)
# print(frdd.collect())
# ['{"id":1,"timestamp":"2019-05-08T01:03.00Z","category":"平板电脑","areaName":"北京","money":"1450"}|{"id":2,"timestamp":"2019-05-08T01:01.00Z","category":"手机","areaName":"北京","money":"1450"}|{"id":3,"timestamp":"2019-05-08T01:03.00Z","category":"手机","areaName":"北京","money":"8412"}', '{"id":4,"timestamp":"2019-05-08T05:01.00Z","category":"电脑","areaName":"上海","money":"1513"}|{"id":5,"timestamp":"2019-05-08T01:03.00Z","category":"家电","areaName":"北京","money":"1550"}|{"id":6,"timestamp":"2019-05-08T01:01.00Z","category":"电脑","areaName":"杭州","money":"1550"}', '{"id":7,"timestamp":"2019-05-08T01:03.00Z","category":"电脑","areaName":"北京","money":"5611"}|{"id":8,"timestamp":"2019-05-08T03:01.00Z","category":"家电","areaName":"北京","money":"4410"}|{"id":9,"timestamp":"2019-05-08T01:03.00Z","category":"家具","areaName":"郑州","money":"1120"}', '{"id":10,"timestamp":"2019-05-08T01:01.00Z","category":"家具","areaName":"北京","money":"6661"}|{"id":11,"timestamp":"2019-05-08T05:03.00Z","category":"家具","areaName":"杭州","money":"1230"}|{"id":12,"timestamp":"2019-05-08T01:01.00Z","category":"书籍","areaName":"北京","money":"5550"}', '{"id":13,"timestamp":"2019-05-08T01:03.00Z","category":"书籍","areaName":"北京","money":"5550"}|{"id":14,"timestamp":"2019-05-08T01:01.00Z","category":"电脑","areaName":"北京","money":"1261"}|{"id":15,"timestamp":"2019-05-08T03:03.00Z","category":"电脑","areaName":"杭州","money":"6660"}', '{"id":16,"timestamp":"2019-05-08T01:01.00Z","category":"电脑","areaName":"天津","money":"6660"}|{"id":17,"timestamp":"2019-05-08T01:03.00Z","category":"书籍","areaName":"北京","money":"9000"}|{"id":18,"timestamp":"2019-05-08T05:01.00Z","category":"书籍","areaName":"北京","money":"1230"}', '{"id":19,"timestamp":"2019-05-08T01:03.00Z","category":"电脑","areaName":"杭州","money":"5551"}|{"id":20,"timestamp":"2019-05-08T01:01.00Z","category":"电脑","areaName":"北京","money":"2450"}', '{"id":21,"timestamp":"2019-05-08T01:03.00Z","category":"食品","areaName":"北京","money":"5520"}|{"id":22,"timestamp":"2019-05-08T01:01.00Z","category":"食品","areaName":"北京","money":"6650"}', '{"id":23,"timestamp":"2019-05-08T01:03.00Z","category":"服饰","areaName":"杭州","money":"1240"}|{"id":24,"timestamp":"2019-05-08T01:01.00Z","category":"食品","areaName":"天津","money":"5600"}', '{"id":25,"timestamp":"2019-05-08T01:03.00Z","category":"食品","areaName":"北京","money":"7801"}|{"id":26,"timestamp":"2019-05-08T01:01.00Z","category":"服饰","areaName":"北京","money":"9000"}', '{"id":27,"timestamp":"2019-05-08T01:03.00Z","category":"服饰","areaName":"杭州","money":"5600"}|{"id":28,"timestamp":"2019-05-08T01:01.00Z","category":"食品","areaName":"北京","money":"8000"}|{"id":29,"timestamp":"2019-05-08T02:03.00Z","category":"服饰","areaName":"杭州","money":"7000"}']

json_str_rdd = frdd.flatMap(lambda x: x.split("|"))
# print(json_str_rdd.collect())
# ['{"id":1,"timestamp":"2019-05-08T01:03.00Z","category":"平板电脑","areaName":"北京","money":"1450"}', '{"id":2,"timestamp":"2019-05-08T01:01.00Z","category":"手机","areaName":"北京","money":"1450"}', '{"id":3,"timestamp":"2019-05-08T01:03.00Z","category":"手机","areaName":"北京","money":"8412"}', '{"id":4,"timestamp":"2019-05-08T05:01.00Z","category":"电脑","areaName":"上海","money":"1513"}', '{"id":5,"timestamp":"2019-05-08T01:03.00Z","category":"家电","areaName":"北京","money":"1550"}', '{"id":6,"timestamp":"2019-05-08T01:01.00Z","category":"电脑","areaName":"杭州","money":"1550"}', '{"id":7,"timestamp":"2019-05-08T01:03.00Z","category":"电脑","areaName":"北京","money":"5611"}', '{"id":8,"timestamp":"2019-05-08T03:01.00Z","category":"家电","areaName":"北京","money":"4410"}', '{"id":9,"timestamp":"2019-05-08T01:03.00Z","category":"家具","areaName":"郑州","money":"1120"}', '{"id":10,"timestamp":"2019-05-08T01:01.00Z","category":"家具","areaName":"北京","money":"6661"}', '{"id":11,"timestamp":"2019-05-08T05:03.00Z","category":"家具","areaName":"杭州","money":"1230"}', '{"id":12,"timestamp":"2019-05-08T01:01.00Z","category":"书籍","areaName":"北京","money":"5550"}', '{"id":13,"timestamp":"2019-05-08T01:03.00Z","category":"书籍","areaName":"北京","money":"5550"}', '{"id":14,"timestamp":"2019-05-08T01:01.00Z","category":"电脑","areaName":"北京","money":"1261"}', '{"id":15,"timestamp":"2019-05-08T03:03.00Z","category":"电脑","areaName":"杭州","money":"6660"}', '{"id":16,"timestamp":"2019-05-08T01:01.00Z","category":"电脑","areaName":"天津","money":"6660"}', '{"id":17,"timestamp":"2019-05-08T01:03.00Z","category":"书籍","areaName":"北京","money":"9000"}', '{"id":18,"timestamp":"2019-05-08T05:01.00Z","category":"书籍","areaName":"北京","money":"1230"}', '{"id":19,"timestamp":"2019-05-08T01:03.00Z","category":"电脑","areaName":"杭州","money":"5551"}', '{"id":20,"timestamp":"2019-05-08T01:01.00Z","category":"电脑","areaName":"北京","money":"2450"}', '{"id":21,"timestamp":"2019-05-08T01:03.00Z","category":"食品","areaName":"北京","money":"5520"}', '{"id":22,"timestamp":"2019-05-08T01:01.00Z","category":"食品","areaName":"北京","money":"6650"}', '{"id":23,"timestamp":"2019-05-08T01:03.00Z","category":"服饰","areaName":"杭州","money":"1240"}', '{"id":24,"timestamp":"2019-05-08T01:01.00Z","category":"食品","areaName":"天津","money":"5600"}', '{"id":25,"timestamp":"2019-05-08T01:03.00Z","category":"食品","areaName":"北京","money":"7801"}', '{"id":26,"timestamp":"2019-05-08T01:01.00Z","category":"服饰","areaName":"北京","money":"9000"}', '{"id":27,"timestamp":"2019-05-08T01:03.00Z","category":"服饰","areaName":"杭州","money":"5600"}', '{"id":28,"timestamp":"2019-05-08T01:01.00Z","category":"食品","areaName":"北京","money":"8000"}', '{"id":29,"timestamp":"2019-05-08T02:03.00Z","category":"服饰","areaName":"杭州","money":"7000"}']

dict_rdd = json_str_rdd.map(lambda x: json.loads(x))
print(dict_rdd.collect())
# [{'id': 1, 'timestamp': '2019-05-08T01:03.00Z', 'category': '平板电脑', 'areaName': '北京', 'money': '1450'}, {'id': 2, 'timestamp': '2019-05-08T01:01.00Z', 'category': '手机', 'areaName': '北京', 'money': '1450'}, {'id': 3, 'timestamp': '2019-05-08T01:03.00Z', 'category': '手机', 'areaName': '北京', 'money': '8412'}, {'id': 4, 'timestamp': '2019-05-08T05:01.00Z', 'category': '电脑', 'areaName': '上海', 'money': '1513'}, {'id': 5, 'timestamp': '2019-05-08T01:03.00Z', 'category': '家电', 'areaName': '北京', 'money': '1550'}, {'id': 6, 'timestamp': '2019-05-08T01:01.00Z', 'category': '电脑', 'areaName': '杭州', 'money': '1550'}, {'id': 7, 'timestamp': '2019-05-08T01:03.00Z', 'category': '电脑', 'areaName': '北京', 'money': '5611'}, {'id': 8, 'timestamp': '2019-05-08T03:01.00Z', 'category': '家电', 'areaName': '北京', 'money': '4410'}, {'id': 9, 'timestamp': '2019-05-08T01:03.00Z', 'category': '家具', 'areaName': '郑州', 'money': '1120'}, {'id': 10, 'timestamp': '2019-05-08T01:01.00Z', 'category': '家具', 'areaName': '北京', 'money': '6661'}, {'id': 11, 'timestamp': '2019-05-08T05:03.00Z', 'category': '家具', 'areaName': '杭州', 'money': '1230'}, {'id': 12, 'timestamp': '2019-05-08T01:01.00Z', 'category': '书籍', 'areaName': '北京', 'money': '5550'}, {'id': 13, 'timestamp': '2019-05-08T01:03.00Z', 'category': '书籍', 'areaName': '北京', 'money': '5550'}, {'id': 14, 'timestamp': '2019-05-08T01:01.00Z', 'category': '电脑', 'areaName': '北京', 'money': '1261'}, {'id': 15, 'timestamp': '2019-05-08T03:03.00Z', 'category': '电脑', 'areaName': '杭州', 'money': '6660'}, {'id': 16, 'timestamp': '2019-05-08T01:01.00Z', 'category': '电脑', 'areaName': '天津', 'money': '6660'}, {'id': 17, 'timestamp': '2019-05-08T01:03.00Z', 'category': '书籍', 'areaName': '北京', 'money': '9000'}, {'id': 18, 'timestamp': '2019-05-08T05:01.00Z', 'category': '书籍', 'areaName': '北京', 'money': '1230'}, {'id': 19, 'timestamp': '2019-05-08T01:03.00Z', 'category': '电脑', 'areaName': '杭州', 'money': '5551'}, {'id': 20, 'timestamp': '2019-05-08T01:01.00Z', 'category': '电脑', 'areaName': '北京', 'money': '2450'}, {'id': 21, 'timestamp': '2019-05-08T01:03.00Z', 'category': '食品', 'areaName': '北京', 'money': '5520'}, {'id': 22, 'timestamp': '2019-05-08T01:01.00Z', 'category': '食品', 'areaName': '北京', 'money': '6650'}, {'id': 23, 'timestamp': '2019-05-08T01:03.00Z', 'category': '服饰', 'areaName': '杭州', 'money': '1240'}, {'id': 24, 'timestamp': '2019-05-08T01:01.00Z', 'category': '食品', 'areaName': '天津', 'money': '5600'}, {'id': 25, 'timestamp': '2019-05-08T01:03.00Z', 'category': '食品', 'areaName': '北京', 'money': '7801'}, {'id': 26, 'timestamp': '2019-05-08T01:01.00Z', 'category': '服饰', 'areaName': '北京', 'money': '9000'}, {'id': 27, 'timestamp': '2019-05-08T01:03.00Z', 'category': '服饰', 'areaName': '杭州', 'money': '5600'}, {'id': 28, 'timestamp': '2019-05-08T01:01.00Z', 'category': '食品', 'areaName': '北京', 'money': '8000'}, {'id': 29, 'timestamp': '2019-05-08T02:03.00Z', 'category': '服饰', 'areaName': '杭州', 'money': '7000'}]
```
- 各个城市销售额排名，从大到小

```python
# 取出城市和销售额数据--(城市，销售额)
city_with_monry_rdd = dict_rdd.map(lambda x: (x["areaName"],int(x["money"])))
#按城市分组按销售额聚合
city_result_rdd = city_with_monry_rdd.reduceByKey(lambda a,b: a+b)
print(city_result_rdd.collect())
# [('杭州', 28831), ('天津', 12260), ('北京', 91556), ('上海', 1513), ('郑州', 1120)]

#按销售额聚合结果进行排序
result1_rdd = city_result_rdd.sortBy(lambda x: x[1],ascending=False,numPartitions=1)
print("需求1(各个城市销售额排名，从大到小)的结果： ",result1_rdd.collect())
# [('北京', 91556), ('杭州', 28831), ('天津', 12260), ('上海', 1513), ('郑州', 1120)]
```
- 全部城市，有哪些商品类别在售卖

```python
category_rdd = dict_rdd.map(lambda x: x["category"]).distinct()
print("需求2(全部城市，有哪些商品类别在售卖)的结果： ",category_rdd.collect())
# 需求2(全部城市，有哪些商品类别在售卖)的结果：  ['平板电脑', '家电', '书籍', '手机', '电脑', '家具', '食品', '服饰']
```
- 北京市有哪些商品类别在售卖

```python
#过滤北京市的数据
beiJing_data_rdd = dict_rdd.filter(lambda x: x['areaName'] == "北京")
#取出全部商品类别
result3_rdd = beiJing_data_rdd.map(lambda x: x["category"]).distinct()
print("需求3(北京市有哪些商品类别在售卖)的结果： ",result3_rdd.collect())
# ['平板电脑', '家电', '书籍', '手机', '电脑', '家具', '食品', '服饰']
```

## 输出

#### 输出为python对象

- rdd.collect()--输出为list

```python
from pyspark import SparkConf,SparkContext

conf = SparkConf().setMaster("local[*]").setAppName("test_spark")
sc = SparkContext(conf=conf)

rdd = sc.parallelize([1,2,3,4,5])

rdd_list = rdd.collect()
print(rdd_list)
print(type(rdd_list))
# [1, 2, 3, 4, 5]
# <class 'list'>
```
- reduce--对RDD数据集按传入的逻辑进行聚合
    * 不同于reduceByKey,reduce不会按Key分组，其只进行聚合

```python
num = rdd.reduce(lambda a,b: a+b)
print(num)
# 15
```
- take--取出RDD的前N个元素，组成list返回

```python
take_list = rdd.take(3)
print(take_list)
print(type(take_list))
# [1, 2, 3]
# <class 'list'>
```
- count--统计RDD内有多少条数据，返回值为数字

```python
num_count = rdd.count()
print(num_count)
# 5
```

#### RDD输出到文件

- rdd.saveAsTextFile("./dir_name")可以将rdd输出至文件(需要配置Hadoop)
    * 默认输出文件数量为CPU核心数，需要更改输出文件数需要配置，如下
    * 未配置Hadoop,这里不演示

```python
from pyspark import SparkConf,SparkContext

conf = SparkConf().setMaster("local[*]").setAppName("test_spark")
#方式1：修改输出分区为固定值--1,其默认输出按CPU核心数输出
conf.set("spark.default.parallelism","1")

sc = SparkContext(conf=conf)

rdd1 = sc.parallelize([1,2,3,4,5])
rdd2 = sc.parallelize([("hello",3),("Spark",4),("Hi",56)])
rdd3 = sc.parallelize([[1,3,4],[6,3,7],[9,1,0]])

rdd1.saveAsTextFile("./jira")
```
- 配置输出文件数量

```python
conf = SparkConf().setMaster("local[*]").setAppName("test_spark")
#方式1：修改输出分区为固定值--1,其默认输出按CPU核心数输出
conf.set("spark.default.parallelism","1")
sc = SparkContext(conf=conf)

#方式2: 设置numSlices参数
rdd4 = sc.parallelize([1,2,3,4,5],numSlices=1)
```
***
- 综合案例,数据文件位于./material_py/pyspark/backup_search_log.txt
    * 下面案例中的1,2两个需求代码可以同需求3一样简化

```python
# 打印输出：热门搜索时间段(小时精度)Top3
# 打印输出：热门搜索词Top3
# 打印输出：统计关键字在哪个时间段出现最多
# 将数据转为JSON,写出到文件
from pyspark import SparkConf,SparkContext

conf = SparkConf().setMaster("local[*]").setAppName("test_spark")
sc = SparkContext(conf=conf)

path = "./data/backup_search_log.txt"
frdd = sc.textFile(path)

# 打印输出：热门搜索时间段(小时精度)Top3
str_rdd = frdd.map(lambda x: x.split("\t")).\
    map(lambda x: x[0]).\
    map(lambda x: x.split(":")).\
    map(lambda x: x[0]).\
    map(lambda x: (x,1)).\
    reduceByKey(lambda a,b: a + b).\
    sortBy(lambda x: x[1],ascending=False,numPartitions=1).\
    take(3)
print(str_rdd)
# [('20', 3479), ('23', 3087), ('21', 2989)]

# 打印输出：热门搜索词Top3
result2_rdd_list = frdd.map(lambda x: x.split("\t")).\
    map(lambda x: x[2]).\
    map(lambda x: (x,1)).\
    reduceByKey(lambda a,b: a + b).\
    sortBy(lambda x: x[1],ascending=False,numPartitions=1).\
    take(3)
print(result2_rdd_list)
# [('scala', 2310), ('hadoop', 2268), ('博学谷', 2002)]

# 打印输出：统计黑马程序员关键字在哪个时间段出现最多
result3_rdd = frdd.map(lambda x: x.split("\t")).\
    filter(lambda x: x[2] == "黑马程序员").\
    map(lambda x: (x[0][:2],1)).\
    reduceByKey(lambda a,b: a+b).\
    sortBy(lambda x: x[1],ascending=False,numPartitions=1).\
    take(1)
print(result3_rdd)
# [('22', 245)]

#转为JSON格式的RDD,输出为文件
frdd.map(lambda x: x.split("\t")).\
    map(lambda x: {"time":x[0],"user_id":x[1],"key_word":x[2],"rank1":x[3],"rank2":x[4],"url":x[5]}).\
    saveAsTextFile("./path")
```

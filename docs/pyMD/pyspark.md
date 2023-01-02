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

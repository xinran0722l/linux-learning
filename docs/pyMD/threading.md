python的多线程可以通过threading模块实现

- 不通过多线程，无法让下面的两个函数同时运行

```python
import time

def sing():
    while True:
        print("我在唱歌～～～")
        time.sleep(1)

def dance():
    while True:
        print("我在跳舞------")
        time.sleep(1)

if __name__ == "__main__":
    sing()
    dance()
```
- 通过多线程同时运行2个函数

```python
import time
import threading

def sing():
    while True:
        print("我在唱歌～～～")
        time.sleep(1)

def dance():
    while True:
        print("我在跳舞------")
        time.sleep(1)

if __name__ == "__main__":
    # sing()
    # dance()
    sing_thread = threading.Thread(target=sing)
    dance_thread = threading.Thread(target=dance)

    sing_thread.start()
    dance_thread.start()
```
- 在多线程内运行函数时传参

```python
import time
import threading

def sing(msg):
    while True:
        print(msg)
        time.sleep(1)

def dance(msg):
    while True:
        print(msg)
        time.sleep(1)

if __name__ == "__main__":
    #元组只有一个元素，则后面必须有一个逗号
    sing_thread = threading.Thread(target=sing,args=("我要唱歌～～～",))    
    dance_thread = threading.Thread(target=dance,kwargs={"msg":"我要跳舞---"})

    sing_thread.start()
    dance_thread.start()
```

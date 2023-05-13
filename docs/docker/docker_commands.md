# Docker 常用命令

## 删除镜像

```sh
> sudo docker rmi image-ID
```

先下载 hello-world 镜像作为测试使用

```sh
>  sudo docker pull hello-world
Using default tag: latest
latest: Pulling from library/hello-world
719385e32844: Pull complete
Digest: sha256:fc6cf906cbfa013e80938cdf0bb199fbdbb86d6e3e013783e5a766f50f5dbce0
Status: Downloaded newer image for hello-world:latest
docker.io/library/hello-world:latest
> sudo docker images
REPOSITORY    TAG        IMAGE ID       CREATED         SIZE
hello-world   latest     9c7a54a9a43c   5 days ago      13.3kB
nginx         latest     448a08f1d2f9   6 days ago      142MB
redis         latest     116cad43b6af   6 days ago      117MB
ubuntu        latest     6b7dfa7e8fdb   5 months ago    77.8MB
centos        latest     5d0da3dc9764   20 months ago   231MB
centos        7.8.2003   afb6fca791e0   3 years ago     203MB
opensuse      latest     efc0e91c4ab2   4 years ago     110MB

#通过 rmi 命令删除本地镜像
#发现报错，原因: 被删除的镜像，不得有依赖的容器记录
> sudo docker rmi hello-world a37291e4c81a 正在使用 hello-world
Error response from daemon: conflict: unable to remove repository reference "hello-world" (must force) - container a37291e4c81a is using its referenced image 9c7a54a9a43c

#直接运行 docker ps 发现无记录
> sudo docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
# ps -a 参数查看运行过的所有镜像
> sudo docker ps -a
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS                     PORTS     NAMES
a37291e4c81a   hello-world    "/hello"                 2 minutes ago   Exited (0) 2 minutes ago             nostalgic_lehmann
aeb9a050f85b   nginx          "/docker-entrypoint.…"   4 hours ago     Created                              affectionate_stonebraker
16ccd806b7f8   nginx          "/docker-entrypoint.…"   4 hours ago     Exited (0) 4 seconds ago             unruffled_poincare
93452314d55e   efc0e91c4ab2   "bash"                   5 hours ago     Exited (0) 5 hours ago               jovial_mayer
d6e22e830baa   6b7dfa7e8fdb   "bash"                   5 hours ago     Exited (0) 5 hours ago               modest_lalande
7596e4a12dad   5d0da3dc9764   "bash"                   5 hours ago     Exited (0) 5 hours ago               condescending_buck
cf60b9c990d7   nginx          "/docker-entrypoint.…"   24 hours ago    Exited (0) 17 hours ago              beautiful_poitras

#删除容器记录
> sudo docker rm a37291e4c81a

#再次执行 rmi,成功
> sudo docker rmi hello-world
Untagged: hello-world:latest
Untagged: hello-world@sha256:fc6cf906cbfa013e80938cdf0bb199fbdbb86d6e3e013783e5a766f50f5dbce0
Deleted: sha256:9c7a54a9a43cca047013b82af109fe963fde787f63f9e016fdc3384500c2823d
Deleted: sha256:01bb4fce3eb1b56b05adf99504dafd31907a5aadac736e36b27595c8b92f07f1
```

通过 镜像 ID 删除镜像

```sh
> sudo docker images
REPOSITORY    TAG        IMAGE ID       CREATED         SIZE
hello-world   latest     9c7a54a9a43c   5 days ago      13.3kB
nginx         latest     448a08f1d2f9   6 days ago      142MB
redis         latest     116cad43b6af   6 days ago      117MB
ubuntu        latest     6b7dfa7e8fdb   5 months ago    77.8MB
centos        latest     5d0da3dc9764   20 months ago   231MB
centos        7.8.2003   afb6fca791e0   3 years ago     203MB
opensuse      latest     efc0e91c4ab2   4 years ago     110MB
#通过 image ID删除，只需要前三位 ID 即可
> sudo docker rmi 9c7
Untagged: hello-world:latest
Untagged: hello-world@sha256:fc6cf906cbfa013e80938cdf0bb199fbdbb86d6e3e013783e5a766f50f5dbce0
Deleted: sha256:9c7a54a9a43cca047013b82af109fe963fde787f63f9e016fdc3384500c2823d
Deleted: sha256:01bb4fce3eb1b56b05adf99504dafd31907a5aadac736e36b27595c8b92f07f1
```

## 批量删除镜像

```sh
#参数解释  -a 列出全部
#          -q 只列出 ID
> sudo docker images -aq
448a08f1d2f9
116cad43b6af
6b7dfa7e8fdb
5d0da3dc9764
afb6fca791e0
efc0e91c4ab2

#而命令行的反引号会取出 命令执行的结果
> echo `sudo docker images -q`
448a08f1d2f9 116cad43b6af 6b7dfa7e8fdb 5d0da3dc9764 afb6fca791e0 efc0e91c4ab2

#通过反引号删除镜像 慎用！！！！！
docker rmi `docker images -aq`

#通过反引号删除容器 慎用！！！！！
docker rm `docker images -aq`
```

## 导出镜像

```sh
> sudo docker images
REPOSITORY   TAG        IMAGE ID       CREATED         SIZE
nginx        latest     448a08f1d2f9   6 days ago      142MB
redis        latest     116cad43b6af   6 days ago      117MB
ubuntu       latest     6b7dfa7e8fdb   5 months ago    77.8MB
centos       latest     5d0da3dc9764   20 months ago   231MB
centos       7.8.2003   afb6fca791e0   3 years ago     203MB
opensuse     latest     efc0e91c4ab2   4 years ago     110MB

#连接 centOS:7.8.2003
< sudo docker run -it afb6fca791e0  bash
...#对 centOS:7.8.2003 做一些操作(下载一些东西)

#导出镜像(成功后没有提示)
> sudo docker image save centos:7.8.2003 > ~/Desktop/docker/centos7.8.2003.tgz
> l ~/Desktop/docker
total 202M
-rw-r--r-- 1 qinghuo qinghuo 202M May 10 16:16 centos7.8.2003.tgz



#查看容器记录,可配合 docker commit 命令提交镜像的更改
> sudo docker ps -a
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS                        PORTS     NAMES
66da7af0f532   afb6fca791e0   "bash"                   19 minutes ago   Exited (127) 7 seconds ago              sad_satoshi
44249307b30f   afb6fca791e0   "bash"                   20 minutes ago   Exited (127) 19 minutes ago             suspicious_sutherland
1f8cf250663b   afb6fca791e0   "-it bash"               21 minutes ago   Created                                 suspicious_bardeen
f677513247db   afb6fca791e0   "/bin/bash"              21 minutes ago   Exited (0) 21 minutes ago               youthful_hypatia
aeb9a050f85b   nginx          "/docker-entrypoint.…"   5 hours ago      Created                                 affectionate_stonebraker
16ccd806b7f8   nginx          "/docker-entrypoint.…"   5 hours ago      Exited (0) 48 minutes ago               unruffled_poincare
93452314d55e   efc0e91c4ab2   "bash"                   6 hours ago      Exited (0) 6 hours ago                  jovial_mayer
d6e22e830baa   6b7dfa7e8fdb   "bash"                   6 hours ago      Exited (0) 6 hours ago                  modest_lalande
7596e4a12dad   5d0da3dc9764   "bash"                   6 hours ago      Exited (0) 6 hours ago                  condescending_buck
cf60b9c990d7   nginx          "/docker-entrypoint.…"   25 hours ago     Exited (0) 18 hours ago                 beautiful_poitras
```

## 导入镜像

首先删除本地镜像，方便演示

```sh
#由于有容器记录(很多容器记录)，无法直接删除
#所以要先清除容器记录
> sudo docker rmi centos:7.8.2003
Error response from daemon: conflict: unable to remove repository reference "centos:7.8.2003" (must force) - container 66da7af0f532 is using its referenced image afb6fca791e0
#清除全部的容器记录
> sudo docker rm `sudo docker ps -aq`
66da7af0f532
aeb9a050f85b
16ccd806b7f8
93452314d55e
d6e22e830baa
7596e4a12dad
cf60b9c990d7
#再次查看容器记录
> sudo docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
#直接删除镜像
> sudo docker rmi centos:7.8.2003
Untagged: centos:7.8.2003
Untagged: centos@sha256:8540a199ad51c6b7b51492fa9fee27549fd11b3bb913e888ab2ccf77cbb72cc1
Deleted: sha256:afb6fca791e071c66276202f8efca5ce3d3dc4fb218bcddff1bc565d981ddd1e
Deleted: sha256:fb82b029bea0a2a3b6a62a9c1e47e57fae2a82f629b2d1a346da4fc8fb53a0b6
#查看镜像，已删除centos:7.8.2003
> sudo docker images
REPOSITORY   TAG       IMAGE ID       CREATED         SIZE
nginx        latest    448a08f1d2f9   6 days ago      142MB
redis        latest    116cad43b6af   6 days ago      117MB
ubuntu       latest    6b7dfa7e8fdb   5 months ago    77.8MB
centos       latest    5d0da3dc9764   20 months ago   231MB
opensuse     latest    efc0e91c4ab2   4 years ago     110MB

```

导入镜像

```sh
> sudo docker image load -i ~/Desktop/docker/centos7.8.2003.tgz
fb82b029bea0: Loading layer  211.1MB/211.1MB
Loaded image: centos:7.8.2003
#查看导入结果(成功)
> sudo docker images
REPOSITORY   TAG        IMAGE ID       CREATED         SIZE
nginx        latest     448a08f1d2f9   6 days ago      142MB
redis        latest     116cad43b6af   6 days ago      117MB
ubuntu       latest     6b7dfa7e8fdb   5 months ago    77.8MB
centos       latest     5d0da3dc9764   20 months ago   231MB
centos       7.8.2003   afb6fca791e0   3 years ago     203MB
opensuse     latest     efc0e91c4ab2   4 years ago     110MB
```

## 查看镜像详细信息

查看 Docker 的服务信息

```sh
> docker info
...
```

以 JSON 格式查看 镜像的详细信息

```sh
#以 centos:7.8.2003 为例
> sudo docker images
REPOSITORY   TAG        IMAGE ID       CREATED         SIZE
nginx        latest     448a08f1d2f9   6 days ago      142MB
redis        latest     116cad43b6af   6 days ago      117MB
ubuntu       latest     6b7dfa7e8fdb   5 months ago    77.8MB
centos       latest     5d0da3dc9764   20 months ago   231MB
centos       7.8.2003   afb6fca791e0   3 years ago     203MB
opensuse     latest     efc0e91c4ab2   4 years ago     110MB

以 JSON 格式查看镜像详细信息
> sudo docker image inspect afb
[
    {
        "Id": "sha256:afb6fca791e071c66276202f8efca5ce3d3dc4fb218bcddff1bc565d981ddd1e",
        "RepoTags": [
            "centos:7.8.2003"
        ],
        "RepoDigests": [],
        "Parent": "",
... 
```

## 基础命令(启停镜像)

### 搜索 dockerhub 仓库

```sh
> sudo docker search nginx
NAME                                              DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
nginx                                             Official build of Nginx.                        18481     [OK]       
unit                                              Official build of NGINX Unit: a polyglot app…   0         [OK]       
bitnami/nginx                                     Bitnami nginx Docker Image                      162                  [OK]
bitnami/nginx-ingress-controller                  Bitnami Docker Image for NGINX Ingress Contr…   25                   [OK]
ubuntu/nginx                                      Nginx, a high-performance reverse proxy & we…   89                   
kasmweb/nginx                                     An Nginx image based off nginx:alpine and in…   6                    
rancher/nginx-ingress-controller                                                                  11                   
...
```

### 查看本地镜像列表

```sh
> sudo docker image ls
REPOSITORY   TAG       IMAGE ID   CREATED   SIZE
nginx        latest    448a08f1d2f9   5 days ago   142MB
```


### 下载镜像

```sh
> sudo docker pull nginx
#下载默认 tag 的 nginx
Using default tag: latest
#从仓库下载最新版
latest: Pulling from library/nginx
#多文件下载
9e3ea8720c6d: Pull complete 
bf36b6466679: Pull complete 
15a97cf85bb8: Pull complete 
9c2d6be5a61d: Pull complete 
6b7e4a5c7c7a: Pull complete 
8db4caa19df8: Pull complete 
#哈希校验
Digest: sha256:480868e8c8c797794257e2abd88d0f9a8809b2fe956cbfbc05dcc0bca1f7cd43
#下载状态
Status: Downloaded newer image for nginx:latest
docker.io/library/nginx:lates
```

### 运行镜像

```sh
# -d 后台运行容器
# -p 80:80 端口映射。格式为： 宿主机端口：容器内端口
#          访问宿主机的80端口，等于访问容器内的80端口  
#运行结果如下，返回了一个 容器ID
> sudo docker run -d -p 80:80 nginx
cf60b9c990d74e29351c9630e8c12ef49dfce003990724ff75893410133e4039
```

### docker run 的流程

1. 检查本地是否有该镜像，没有就下载
2. 利用镜像创建且启动一个容器
3. 分配容器文件系统，在只读的镜像层挂载读写层
4. 宿主机的网桥接口会分配一个虚拟接口到容器中
5. 容器获得地址池里的 ip 地址
6. 执行用户指定的程序
7. 若程序里没有进程在运行，容器执行完毕后立即终止

### 查看容器是否在运行

```sh
> sudo docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS                               NAMES
cf60b9c990d7   nginx     "/docker-entrypoint.…"   2 minutes ago   Up 2 minutes   0.0.0.0:80->80/tcp, :::80->80/tcp   beautiful_poitras
```

### 停止运行中的容器(会返回容器 ID)

```sh
> sudo docker ps  #先查看停止容器的 ID
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS                               NAMES
cf60b9c990d7   nginx     "/docker-entrypoint.…"   50 minutes ago   Up 50 minutes   0.0.0.0:80->80/tcp, :::80->80/tcp   beautiful_poitras

#docker stop ContainerID 停止运行中的容器
> sudo docker stop cf60b9c990d7
cf60b9c990d7

> sudo docker ps  #再次查看该 ID 代表的容器,已停止
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

## 命令小结

```sh
#进入运行中的容器
docker exec -it 容器ID bash

#强制杀死容器
docker rm -f 容器ID

#查看容器内进程信息
docker top 容器ID

#查看容器内的资源
docker stats 容器ID

#查看容器的具体信息
docker inspect 容器ID

#获取容器内的 ip 地址，容器的格式化参数
docker inspect 容器ID | grep 192

#拿到容器内的 in
docker inspect --format '{{.NetworkSettings.IPAddress}}' 容器ID
```

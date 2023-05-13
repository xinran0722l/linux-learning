# 容器管理

`docker run` 等于 创建 + 启动

`docker run 镜像名` 如果镜像不存在本地，则会在线下载该镜像

> 容器内的进程必须处于前台运行状态，否则容器就会直接退出。如果容器内，没有运行的进程，容器也会挂掉

## 演示

```sh
#先查看本地镜像
> sudo docker images
REPOSITORY   TAG        IMAGE ID       CREATED         SIZE
nginx        latest     448a08f1d2f9   8 days ago      142MB
redis        latest     116cad43b6af   8 days ago      117MB
ubuntu       latest     6b7dfa7e8fdb   5 months ago    77.8MB
centos       latest     5d0da3dc9764   20 months ago   231MB
centos       7.8.2003   afb6fca791e0   3 years ago     203MB
opensuse     latest     efc0e91c4ab2   4 years ago     110MB
#不添加参数运行3次 centos7.8.2003 镜像
> sudo docker run centos:7.8.2003
> sudo docker run centos:7.8.2003
> sudo docker run centos:7.8.2003
# 通过 ps -a 查看容器记录
> sudo docker ps -a
CONTAINER ID   IMAGE             COMMAND                  CREATED              STATUS                          PORTS     NAMES
d5acb4a115eb   centos:7.8.2003   "/bin/bash"              8 seconds ago        Exited (0) 7 seconds ago                  wonderful_liskov
95910316f908   centos:7.8.2003   "/bin/bash"              10 seconds ago       Exited (0) 9 seconds ago                  jovial_yalow
dcb555349b63   centos:7.8.2003   "/bin/bash"              12 seconds ago       Exited (0) 11 seconds ago                 romantic_zhukovsky
78ab1bc3b180   nginx             "/docker-entrypoint.…"   About a minute ago   Exited (0) About a minute ago             nice_wilson
```

***

运行容器，且进入容器内，且在容器内执行 sh 命令

```sh
> sudo docker run -it centos:7.8.2003 sh
sh-4.2# cat /etc/redhat-release
CentOS Linux release 7.8.2003 (Core)
sh-4.2# cat /etc/shells
/bin/sh
/bin/bash
/usr/bin/sh
/usr/bin/bash
```

***

运行容器，直接在容器内执行命令 (以 ping jd.com 为例)

```sh
> sudo docker run centos:7.8.2003 ping jd.com
PING jd.com (106.39.171.134) 56(84) bytes of data.
64 bytes from 106.39.171.134 (106.39.171.134): icmp_seq=1 ttl=47 time=73.3 ms
64 bytes from 106.39.171.134 (106.39.171.134): icmp_seq=2 ttl=47 time=154 ms
64 bytes from 106.39.171.134 (106.39.171.134): icmp_seq=3 ttl=47 time=57.6 ms
64 bytes from 106.39.171.134 (106.39.171.134): icmp_seq=4 ttl=47 time=48.7 ms
^C
--- jd.com ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3004ms
rtt min/avg/max/mdev = 48.741/83.542/154.417/41.853 ms
```

***

运行一个活着的容器( docker ps 命令可以查看的)

```sh
#通过 docker run -d 参数运行一个活着的容器
# docker run -d 参数会返回一个 容器 ID
> sudo docker run -d centos:7.8.2003 ping jd.com
2b6da25c5566de8df11a8a154a4a285a8dce8aacc2c581e5936ea97fa5f12069
> sudo docker ps
CONTAINER ID   IMAGE             COMMAND         CREATED         STATUS         PORTS     NAMES
2b6da25c5566   centos:7.8.2003   "ping jd.com"   8 seconds ago   Up 8 seconds             fervent_kirch
```

## 丰富的容器参数

以上面几行命令为基础，下面是执行 docker ps -a 后的结果，有很多容器记录(很多以退出的记录)

```sh
> sudo docker ps -a
CONTAINER ID   IMAGE             COMMAND                  CREATED          STATUS                      PORTS     NAMES
2b6da25c5566   centos:7.8.2003   "ping jd.com"            2 minutes ago    Up 2 minutes                          fervent_kirch
441583439b38   centos:7.8.2003   "ping jd.com"            5 minutes ago    Exited (0) 4 minutes ago              cranky_einstein
55ff208da94a   centos:7.8.2003   "sh"                     8 minutes ago    Exited (0) 7 minutes ago              lucid_shaw
5d5d9999b1c4   centos:7.8.2003   "zsh"                    8 minutes ago    Created                               sharp_hodgkin
d5acb4a115eb   centos:7.8.2003   "/bin/bash"              12 minutes ago   Exited (0) 12 minutes ago             wonderful_liskov
95910316f908   centos:7.8.2003   "/bin/bash"              12 minutes ago   Exited (0) 12 minutes ago             jovial_yalow
dcb555349b63   centos:7.8.2003   "/bin/bash"              12 minutes ago   Exited (0) 12 minutes ago             romantic_zhukovsky
78ab1bc3b180   nginx             "/docker-entrypoint.…"   13 minutes ago   Exited (0) 13 minutes ago             nice_wilson
```

容器退出后不保留记录的 --rm 参数

```sh
#参数 --rm 容器挂掉后自动被删除
#      -d  让容器在后台运行(对宿主机而言)
> sudo docker run -d --rm centos:7.8.2003 ping baidu.com
1368fc1071b82ee58d3236862ada868a63c985a1048b57cd5b2a9b5f067fa3ef
> sudo docker ps
CONTAINER ID   IMAGE             COMMAND            CREATED         STATUS         PORTS     NAMES
1368fc1071b8   centos:7.8.2003   "ping baidu.com"   6 seconds ago   Up 6 seconds             gracious_mayer
2b6da25c5566   centos:7.8.2003   "ping jd.com"      6 minutes ago   Up 6 minutes             fervent_kirch
> sudo docker ps -a
CONTAINER ID   IMAGE             COMMAND                  CREATED          STATUS                      PORTS     NAMES
1368fc1071b8   centos:7.8.2003   "ping baidu.com"         9 seconds ago    Up 9 seconds                          gracious_mayer
2b6da25c5566   centos:7.8.2003   "ping jd.com"            6 minutes ago    Up 6 minutes                          fervent_kirch
441583439b38   centos:7.8.2003   "ping jd.com"            8 minutes ago    Exited (0) 8 minutes ago              cranky_einstein
55ff208da94a   centos:7.8.2003   "sh"                     11 minutes ago   Exited (0) 11 minutes ago             lucid_shaw
5d5d9999b1c4   centos:7.8.2003   "zsh"                    11 minutes ago   Created                               sharp_hodgkin
d5acb4a115eb   centos:7.8.2003   "/bin/bash"              15 minutes ago   Exited (0) 15 minutes ago             wonderful_liskov
95910316f908   centos:7.8.2003   "/bin/bash"              15 minutes ago   Exited (0) 15 minutes ago             jovial_yalow
dcb555349b63   centos:7.8.2003   "/bin/bash"              15 minutes ago   Exited (0) 15 minutes ago             romantic_zhukovsky
78ab1bc3b180   nginx             "/docker-entrypoint.…"   17 minutes ago   Exited (0) 17 minutes ago             nice_wilson

```

给容器起个名字
```sh
#--name 给容器起个名字
> sudo docker run -d --rm --name wangdao centos:7.8.2003 ping wangdoc.com
02d31fa7955c205709cccb2fa46fc1665120c5fcf505d2e015e25ba804ab177e
> sudo docker ps
CONTAINER ID   IMAGE             COMMAND              CREATED          STATUS          PORTS     NAMES
02d31fa7955c   centos:7.8.2003   "ping wangdoc.com"   11 seconds ago   Up 11 seconds             wangdao
1368fc1071b8   centos:7.8.2003   "ping baidu.com"     10 minutes ago   Up 10 minutes             gracious_mayer
2b6da25c5566   centos:7.8.2003   "ping jd.com"        16 minutes ago   Up 16 minutes             fervent_kirch
```

中止运行中的容器，会慢一点。由于 --rm 参数，停止后的容器不会有记录

```sh
> sudo docker ps
CONTAINER ID   IMAGE             COMMAND              CREATED          STATUS          PORTS     NAMES
02d31fa7955c   centos:7.8.2003   "ping wangdoc.com"   4 minutes ago    Up 4 minutes              wangdao
1368fc1071b8   centos:7.8.2003   "ping baidu.com"     14 minutes ago   Up 14 minutes             gracious_mayer
> sudo docker stop 1368fc1071b8
1368fc1071b8
#没有 ping baidu.com 的记录
> sudo docker ps -a
CONTAINER ID   IMAGE             COMMAND                  CREATED          STATUS                       PORTS     NAMES
02d31fa7955c   centos:7.8.2003   "ping wangdoc.com"       5 minutes ago    Up 5 minutes                           wangdao
2b6da25c5566   centos:7.8.2003   "ping jd.com"            21 minutes ago   Exited (137) 2 minutes ago             fervent_kirch
441583439b38   centos:7.8.2003   "ping jd.com"            23 minutes ago   Exited (0) 23 minutes ago              cranky_einstein
55ff208da94a   centos:7.8.2003   "sh"                     26 minutes ago   Exited (0) 26 minutes ago              lucid_shaw
5d5d9999b1c4   centos:7.8.2003   "zsh"                    26 minutes ago   Created                                sharp_hodgkin
d5acb4a115eb   centos:7.8.2003   "/bin/bash"              30 minutes ago   Exited (0) 30 minutes ago              wonderful_liskov
95910316f908   centos:7.8.2003   "/bin/bash"              30 minutes ago   Exited (0) 30 minutes ago              jovial_yalow
dcb555349b63   centos:7.8.2003   "/bin/bash"              30 minutes ago   Exited (0) 30 minutes ago              romantic_zhukovsky
78ab1bc3b180   nginx             "/docker-entrypoint.…"   32 minutes ago   Exited (0) 32 minutes ago              nice_wilson
```

## 查看容器日志

```sh
> sudo docker ps
CONTAINER ID   IMAGE             COMMAND              CREATED         STATUS         PORTS     NAMES
02d31fa7955c   centos:7.8.2003   "ping wangdoc.com"   7 minutes ago   Up 7 minutes             wangdao
> sudo docker logs 02d31fa7955c
PING wangdoc.com (172.67.160.4) 56(84) bytes of data.
64 bytes from 172.67.160.4 (172.67.160.4): icmp_seq=2 ttl=53 time=400 ms
64 bytes from 172.67.160.4 (172.67.160.4): icmp_seq=9 ttl=53 time=296 ms
64 bytes from 172.67.160.4 (172.67.160.4): icmp_seq=10 ttl=53 time=244 ms
64 bytes from 172.67.160.4 (172.67.160.4): icmp_seq=12 ttl=53 time=389 ms
...
```

### 实时刷新日志

```sh
> sudo docker logs -f  02d31fa7955c
PING wangdoc.com (172.67.160.4) 56(84) bytes of data.
64 bytes from 172.67.160.4 (172.67.160.4): icmp_seq=557 ttl=53 time=253 ms
64 bytes from 172.67.160.4 (172.67.160.4): icmp_seq=558 ttl=53 time=264 ms
64 bytes from 172.67.160.4 (172.67.160.4): icmp_seq=559 ttl=53 time=225 ms
64 bytes from 172.67.160.4 (172.67.160.4): icmp_seq=560 ttl=53 time=275 ms
^C
> 
```

也可将 docker 的日志通过管道给 tail 来查看

```sh
# 查看最后 4 条日志
> sudo docker logs  02d31fa7955c  | tail -4
64 bytes from 172.67.160.4 (172.67.160.4): icmp_seq=662 ttl=53 time=251 ms
64 bytes from 172.67.160.4 (172.67.160.4): icmp_seq=663 ttl=53 time=201 ms
64 bytes from 172.67.160.4 (172.67.160.4): icmp_seq=664 ttl=53 time=199 ms
64 bytes from 172.67.160.4 (172.67.160.4): icmp_seq=665 ttl=53 time=247 ms
```


## 进入正在运行的容器内

```sh
> sudo docker ps
CONTAINER ID   IMAGE             COMMAND              CREATED          STATUS          PORTS     NAMES
02d31fa7955c   centos:7.8.2003   "ping wangdoc.com"   12 minutes ago   Up 12 minutes             wangdao
# exec参数只能进入容器空间内，无法进入镜像
> sudo docker exec -it  02d31fa7955c  bash
[root@02d31fa7955c /]# ps -ef
UID          PID    PPID  C STIME TTY          TIME CMD
root           1       0  0 06:46 ?        00:00:00 ping wangdoc.com
root           7       0  0 06:59 pts/0    00:00:00 bash
root          21       7  0 07:00 pts/0    00:00:00 ps -ef
[root@02d31fa7955c /]#
```

## 查看容器的详细信息,用于调试

```sh
> sudo docker ps
CONTAINER ID   IMAGE             COMMAND              CREATED          STATUS          PORTS     NAMES
02d31fa7955c   centos:7.8.2003   "ping wangdoc.com"   15 minutes ago   Up 15 minutes             wangdao
> sudo docker container inspect 02d31fa7955c
[
    {
        "Id": "02d31fa7955c205709cccb2fa46fc1665120c5fcf505d2e015e25ba804ab177e",
        "Created": "2023-05-12T06:46:49.298138161Z",
        "Path": "ping",
        "Args": [
            "wangdoc.com"
        ],
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 18555,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2023-05-12T06:46:49.624479251Z",
            "FinishedAt": "0001-01-01T00:00:00Z"
        },
        "Image": "sha256:afb6fca791e071c66276202f8efca5ce3d3dc4fb218bcddff1bc565d981ddd1e",
        "ResolvConfPath": "/var/lib/docker/containers/02d31fa7955c205709cccb2fa46fc1665120c5fcf505d2e015e25ba804ab177e/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/02d31fa7955c205709cccb2fa46fc1665120c5fcf505d2e015e25ba804ab177e/hostname",
        "HostsPath": "/var/lib/docker/containers/02d31fa7955c205709cccb2fa46fc1665120c5fcf505d2e015e25ba804ab177e/hosts",
        "LogPath": "/var/lib/docker/containers/02d31fa7955c205709cccb2fa46fc1665120c5fcf505d2e015e25ba804ab177e/02d31fa7955c205709cccb2fa46fc1665120c5fcf505d2e015e25ba804ab177e-json.log",
        "Name": "/wangdao",
        "RestartCount": 0,
        "Driver": "overlay2",
        "Platform": "linux",
        "MountLabel": "",
        "ProcessLabel": "",
        "AppArmorProfile": "",
        "ExecIDs": null,
        "HostConfig": {
            "Binds": null,
            "ContainerIDFile": "",
            "LogConfig": {
                "Type": "json-file",
                "Config": {}
            },
            "NetworkMode": "default",
            "PortBindings": {},
            "RestartPolicy": {
                "Name": "no",
                "MaximumRetryCount": 0
            },
            "AutoRemove": true,
            "VolumeDriver": "",
            "VolumesFrom": null,
            "ConsoleSize": [
                77,
                106
            ],
            "CapAdd": null,
            "CapDrop": null,
            "CgroupnsMode": "private",
            "Dns": [],
            "DnsOptions": [],
            "DnsSearch": [],
            "ExtraHosts": null,
            "GroupAdd": null,
            "IpcMode": "private",
            "Cgroup": "",
            "Links": null,
            "OomScoreAdj": 0,
            "PidMode": "",
            "Privileged": false,
            "PublishAllPorts": false,
            "ReadonlyRootfs": false,
            "SecurityOpt": null,
            "UTSMode": "",
            "UsernsMode": "",
            "ShmSize": 67108864,
            "Runtime": "runc",
            "Isolation": "",
            "CpuShares": 0,
            "Memory": 0,
            "NanoCpus": 0,
            "CgroupParent": "",
            "BlkioWeight": 0,
            "BlkioWeightDevice": [],
            "BlkioDeviceReadBps": [],
            "BlkioDeviceWriteBps": [],
            "BlkioDeviceReadIOps": [],
            "BlkioDeviceWriteIOps": [],
            "CpuPeriod": 0,
            "CpuQuota": 0,
            "CpuRealtimePeriod": 0,
            "CpuRealtimeRuntime": 0,
            "CpusetCpus": "",
            "CpusetMems": "",
            "Devices": [],
            "DeviceCgroupRules": null,
            "DeviceRequests": null,
            "MemoryReservation": 0,
            "MemorySwap": 0,
            "MemorySwappiness": null,
            "OomKillDisable": null,
            "PidsLimit": null,
            "Ulimits": null,
            "CpuCount": 0,
            "CpuPercent": 0,
            "IOMaximumIOps": 0,
            "IOMaximumBandwidth": 0,
            "MaskedPaths": [
                "/proc/asound",
                "/proc/acpi",
                "/proc/kcore",
                "/proc/keys",
                "/proc/latency_stats",
                "/proc/timer_list",
                "/proc/timer_stats",
                "/proc/sched_debug",
                "/proc/scsi",
                "/sys/firmware"
            ],
            "ReadonlyPaths": [
                "/proc/bus",
                "/proc/fs",
                "/proc/irq",
                "/proc/sys",
                "/proc/sysrq-trigger"
            ]
        },
        "GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/docker/overlay2/a9ebd3be7aa0c4b8f7dd9b8f18699ef9a562f4d3a5a695499cb1048d92476a7f-init/diff:/var/lib/docker/overlay2/dfd99c0715357ac7dc577609e4f0da7580569ac6d84f8c77caf5ed6fcddf6af2/diff",
                "MergedDir": "/var/lib/docker/overlay2/a9ebd3be7aa0c4b8f7dd9b8f18699ef9a562f4d3a5a695499cb1048d92476a7f/merged",
                "UpperDir": "/var/lib/docker/overlay2/a9ebd3be7aa0c4b8f7dd9b8f18699ef9a562f4d3a5a695499cb1048d92476a7f/diff",
                "WorkDir": "/var/lib/docker/overlay2/a9ebd3be7aa0c4b8f7dd9b8f18699ef9a562f4d3a5a695499cb1048d92476a7f/work"
            },
            "Name": "overlay2"
        },
        "Mounts": [],
        "Config": {
            "Hostname": "02d31fa7955c",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
            ],
            "Cmd": [
                "ping",
                "wangdoc.com"
            ],
            "Image": "centos:7.8.2003",
            "Volumes": null,
            "WorkingDir": "",
            "Entrypoint": null,
            "OnBuild": null,
            "Labels": {
                "org.label-schema.build-date": "20200504",
                "org.label-schema.license": "GPLv2",
                "org.label-schema.name": "CentOS Base Image",
                "org.label-schema.schema-version": "1.0",
                "org.label-schema.vendor": "CentOS",
                "org.opencontainers.image.created": "2020-05-04 00:00:00+01:00",
                "org.opencontainers.image.licenses": "GPL-2.0-only",
                "org.opencontainers.image.title": "CentOS Base Image",
                "org.opencontainers.image.vendor": "CentOS"
            }
        },
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "121ac377dbf37749f45f202793ea3b87e1dc069c357ac493b6369e8d8295786a",
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "Ports": {},
            "SandboxKey": "/var/run/docker/netns/121ac377dbf3",
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "97e0ef41d876800bc8d04f9b67287ade4d7af2cc781ec3d638d1cda7d5f4c250",
            "Gateway": "172.17.0.1",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "172.17.0.4",
            "IPPrefixLen": 16,
            "IPv6Gateway": "",
            "MacAddress": "02:42:ac:11:00:04",
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "64172e89f560f2368b5a68a28471275444792954c077cfcfdb16238616cbc77c",
                    "EndpointID": "97e0ef41d876800bc8d04f9b67287ade4d7af2cc781ec3d638d1cda7d5f4c250",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.4",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:11:00:04",
                    "DriverOpts": null
                }
            }
        }
    }
]

>
```

## 容器的端口映射

首先看一下 nginx 镜像的运行脚本 (即./docker-entrypoint.sh)，该脚本运行即代表 nginx 运行

```sh
> sudo docker ps
[sudo] password for qinghuo:
CONTAINER ID   IMAGE             COMMAND              CREATED          STATUS          PORTS     NAMES
02d31fa7955c   centos:7.8.2003   "ping wangdoc.com"   21 minutes ago   Up 21 minutes             wangdao
> sudo docker run -it nginx sh
# ls
bin   dev                  docker-entrypoint.sh  home  lib64  mnt  proc  run   srv  tmp  var
boot  docker-entrypoint.d  etc                   lib   media  opt  root  sbin  sys  usr
# cat /etc/os-release
PRETTY_NAME="Debian GNU/Linux 11 (bullseye)"
NAME="Debian GNU/Linux"
VERSION_ID="11"
VERSION="11 (bullseye)"
VERSION_CODENAME=bullseye
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"
# cat docker-entrypoint.sh
#!/bin/sh
# vim:sw=4:ts=4:et

set -e

entrypoint_log() {
    if [ -z "${NGINX_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

if [ "$1" = "nginx" -o "$1" = "nginx-debug" ]; then
    if /usr/bin/find "/docker-entrypoint.d/" -mindepth 1 -maxdepth 1 -type f -print -quit 2>/dev/null | read v; then
        entrypoint_log "$0: /docker-entrypoint.d/ is not empty, will attempt to perform configuration"

        entrypoint_log "$0: Looking for shell scripts in /docker-entrypoint.d/"
        find "/docker-entrypoint.d/" -follow -type f -print | sort -V | while read -r f; do
            case "$f" in
                *.envsh)
                    if [ -x "$f" ]; then
                        entrypoint_log "$0: Sourcing $f";
                        . "$f"
                    else
                        # warn on shell scripts without exec bit
                        entrypoint_log "$0: Ignoring $f, not executable";
                    fi
                    ;;
                *.sh)
                    if [ -x "$f" ]; then
                        entrypoint_log "$0: Launching $f";
                        "$f"
                    else
                        # warn on shell scripts without exec bit
                        entrypoint_log "$0: Ignoring $f, not executable";
                    fi
                    ;;
                *) entrypoint_log "$0: Ignoring $f";;
            esac
        done

        entrypoint_log "$0: Configuration complete; ready for start up"
    else
        entrypoint_log "$0: No files found in /docker-entrypoint.d/, skipping configuration"
    fi
fi

exec "$@"
# exit
```

如果在宿主机上直接运行 nginx，会在宿主机终端内前台运行

```sh
> sudo docker run nginx
[sudo] password for qinghuo:
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2023/05/12 07:14:25 [notice] 1#1: using the "epoll" event method
2023/05/12 07:14:25 [notice] 1#1: nginx/1.23.4
2023/05/12 07:14:25 [notice] 1#1: built by gcc 10.2.1 20210110 (Debian 10.2.1-6)
2023/05/12 07:14:25 [notice] 1#1: OS: Linux 6.3.1-arch1-1
2023/05/12 07:14:25 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1073741816:1073741816
2023/05/12 07:14:25 [notice] 1#1: start worker processes
2023/05/12 07:14:25 [notice] 1#1: start worker process 29
...
```

在宿主机上重新打开一个终端，查看 docker ps 的输出，会发现 80 端口已经监听

```sh
> sudo docker ps
[sudo] password for qinghuo:
CONTAINER ID   IMAGE             COMMAND                  CREATED              STATUS              PORTS     NAMES
3bc33ebccd91   nginx             "/docker-entrypoint.…"   About a minute ago   Up About a minute   80/tcp    unruffled_robinson
02d31fa7955c   centos:7.8.2003   "ping wangdoc.com"       29 minutes ago       Up 29 minutes                 wangdao

```

此时查看宿主机的 80 端口，发现并没有开启，无法访问宿主机的80端口，如何解决？

```sh
> ss -ntpul | grep 80
> echo $?
1
```

解决宿主机无法访问：通过 -p 参数指定端口映射
```sh
> sudo docker run -d --name port_nginx -p 85:80 nginx
10a8a57e0f2c09a93c19db67d392e2bab486a0588b9c375c7246966f1332afa3
#此时已经可以通过宿主机的  85 端口访问 nginx 的 80 端口了
> sudo docker ps
CONTAINER ID   IMAGE             COMMAND                  CREATED          STATUS          PORTS                               NAMES
10a8a57e0f2c   nginx             "/docker-entrypoint.…"   2 minutes ago    Up 2 minutes    0.0.0.0:85->80/tcp, :::85->80/tcp   port_nginx
02d31fa7955c   centos:7.8.2003   "ping wangdoc.com"       35 minutes ago   Up 35 minutes                                       wangdao
```

### 查看容器的端口转发情况

```sh
> sudo docker run -d --name port_nginx -p 85:80 nginx
10a8a57e0f2c09a93c19db67d392e2bab486a0588b9c375c7246966f1332afa3
#可以看到 nginx 的 80 端口 交给了宿主机的 85 端口
> sudo docker port 10a8a57e0f2c09a93c19db67d392e2bab486a0588b9c375c7246966f1332afa3
80/tcp -> 0.0.0.0:85
80/tcp -> [::]:85
```

### 随机端口映射

随机端口映射只需将 -p 参数转为大写，即 -P 即可

```sh
> sudo docker run -d --name port_Random -P nginx
7118b49e497bfa2cd1eef265472fac0b398e07fae531074604ea9f08d85f040f
#此时通过浏览器访问 localhost:32768 即可看到 nginx 默认页面
> sudo docker port  7118b49e497bfa2cd1eef265472fac0b398e07fae531074604ea9f08d85f040f
80/tcp -> 0.0.0.0:32768
80/tcp -> [::]:32768
```

## 容器的提交

首先启动一个用于测试的容器，在其中添加一个文件,然后退出容器

```sh
> sudo docker run -it centos:7.8.2003 bash
[sudo] password for qinghuo:
[root@9f541fbd0440 /]# ls
anaconda-post.log  dev  home  lib64  mnt  proc  run   srv  tmp  var
bin                etc  lib   media  opt  root  sbin  sys  usr
[root@9f541fbd0440 /]# vi hello.py
[root@9f541fbd0440 /]# cat hello.py
print("Hello Python in the Docker")
[root@9f541fbd0440 /]# exit
exit
#docker ps 只能查看正在运行的容器，
#由于没添加 -d 参数，所以 docker ps 无法看到刚才关闭的，添加了一个文件的 centos
> sudo docker ps
CONTAINER ID   IMAGE             COMMAND                  CREATED          STATUS          PORTS                                     NAMES
7118b49e497b   nginx             "/docker-entrypoint.…"   13 minutes ago   Up 13 minutes   0.0.0.0:32768->80/tcp, :::32768->80/tcp   port_Random
10a8a57e0f2c   nginx             "/docker-entrypoint.…"   21 minutes ago   Up 21 minutes   0.0.0.0:85->80/tcp, :::85->80/tcp         port_nginx
02d31fa7955c   centos:7.8.2003   "ping wangdoc.com"       55 minutes ago   Up 55 minutes            
                                                            wangdao
#但是 docker ps -a 可以查看                                 
> sudo docker ps -a
CONTAINER ID   IMAGE             COMMAND                  CREATED             STATUS                         PORTS                                     NAMES
9f541fbd0440   centos:7.8.2003   "bash"                   2 minutes ago       Exited (0) 11 seconds ago                                                awesome_lichterman
8bcc29760b21   centos:7.8.2003   "bash"                   11 minutes ago      Exited (0) 2 minutes ago                                                 recursing_spence
7118b49e497b   nginx             "/docker-entrypoint.…"   13 minutes ago      Up 13 minutes                  0.0.0.0:32768->80/tcp, :::32768->80/tcp   port_Random
10a8a57e0f2c   nginx             "/docker-entrypoint.…"   21 minutes ago      Up 21 minutes                  0.0.0.0:85->80/tcp, :::85->80/tcp         port_nginx
3bc33ebccd91   nginx             "/docker-entrypoint.…"   27 minutes ago      Exited (0) 22 minutes ago                                                unruffled_robinson
a615cd67b11b   nginx             "/docker-entrypoint.…"   33 minutes ago      Exited (0) 31 minutes ago                                                gracious_pasteur
02d31fa7955c   centos:7.8.2003   "ping wangdoc.com"       55 minutes ago      Up 55 minutes                                                            wangdao
2b6da25c5566   centos:7.8.2003   "ping jd.com"            About an hour ago   Exited (137) 52 minutes ago                                              fervent_kirch
441583439b38   centos:7.8.2003   "ping jd.com"            About an hour ago   Exited (0) About an hour ago                                             cranky_einstein
55ff208da94a   centos:7.8.2003   "sh"                     About an hour ago   Exited (0) About an hour ago                                             lucid_shaw
5d5d9999b1c4   centos:7.8.2003   "zsh"                    About an hour ago   Created                                                                  sharp_hodgkin
d5acb4a115eb   centos:7.8.2003   "/bin/bash"              About an hour ago   Exited (0) About an hour ago                                             wonderful_liskov
95910316f908   centos:7.8.2003   "/bin/bash"              About an hour ago   Exited (0) About an hour ago                                             jovial_yalow
dcb555349b63   centos:7.8.2003   "/bin/bash"              About an hour ago   Exited (0) About an hour ago                                             romantic_zhukovsky
78ab1bc3b180   nginx             "/docker-entrypoint.…"   About an hour ago   Exited (0) About an hour ago                                             nice_wilson
```

提交添加了一个文件的容器

```sh
> sudo docker commit   9f541fbd0440 myemai_163/centos-7.8.2003-hello.py
sha256:a73851dbf982a8739ac2b02bc604a23e5f90c1b2c13c6de9d98c4e89c59faff0
> sudo docker images
REPOSITORY                            TAG        IMAGE ID       CREATED          SIZE
myemai_163/centos-7.8.2003-hello.py   latest     a73851dbf982   31 seconds ago   203MB
nginx                                 latest     448a08f1d2f9   8 days ago       142MB
redis                                 latest     116cad43b6af   8 days ago       117MB
ubuntu                                latest     6b7dfa7e8fdb   5 months ago     77.8MB
centos                                latest     5d0da3dc9764   20 months ago    231MB
centos                                7.8.2003   afb6fca791e0   3 years ago      203MB
opensuse                              latest     efc0e91c4ab2   4 years ago      110MB

```

进入提交的镜像查看文本是否存在

```sh
> sudo docker images
REPOSITORY                            TAG        IMAGE ID       CREATED          SIZE
myemai_163/centos-7.8.2003-hello.py   latest     a73851dbf982   31 seconds ago   203MB
nginx                                 latest     448a08f1d2f9   8 days ago       142MB
redis                                 latest     116cad43b6af   8 days ago       117MB
ubuntu                                latest     6b7dfa7e8fdb   5 months ago     77.8MB
centos                                latest     5d0da3dc9764   20 months ago    231MB
centos                                7.8.2003   afb6fca791e0   3 years ago      203MB
opensuse                              latest     efc0e91c4ab2   4 years ago      110MB
> sudo docker run -it myemai_163/centos-7.8.2003-hello.py bash
[root@052c21c30cb2 /]# ls
anaconda-post.log  dev  hello.py  lib    media  opt   root  sbin  sys  usr
bin                etc  home      lib64  mnt    proc  run   srv   tmp  var
[root@052c21c30cb2 /]# cat hello.py
print("Hello Python in the Docker")
```

# 控制脚本

当开始构建高级脚本时，你大概会问如何在 Linux 系统上运行和控制它们。在本书中，到目前为止，我们运行脚本的唯一方式就是以实时模式在命令行界面上直接运行。这并不是 Linux 上运行脚本的唯一方式。有不少方法可以用来运行 shell 脚本。另外还有一些选项能够用于控制脚本。这些控制方法包括向脚本发送信号、修改脚本的优先级以及在脚本运行时切换到运行模式。本章将会对逐一介绍这些方法。

## 处理信号

Linux 利用信号与运行在系统中的进程进行通信。之前介绍了不同的 Linux 信号以及 Linux 如何用这些信号来停止、启动、终止进程。可以通过对脚本进行编程，使其在收到特定信号时执行某些命令，从而控制 shell 脚本的操作。

### 重温 Linux 信号

Linux 系统和应用程序可以生成超过 30 个信号。如下列出了在 Linux 编程时会遇到的最常见的 Linux 系统信号。

- 1 SIGHUP 挂起进程
- 2 SIGINT 终止进程
- 3 SIGQUIT 停止进程
- 9 SIGKILL 无条件终止进程
- 15 SIGTERM 尽可能终止进程
- 17 SIGSTOP 无条件停止进程，但不是终止进程
- 18 IGTSTP 停止或暂停进程，但不终止进程
- 19 SIGCONT 继续运行停止的进程

默认情况下，bash shell 会忽略收到的任何 SIGQUIT (3)和 SIGTERM (15)信号（正因为这样，交互式 shell 才不会被意外终止）。但是 bash shell 会处理收到的 SIGHUP (1)和 SIGINT (2)信号。

如果 bash shell 收到了 SIGHUP 信号，比如当你要离开一个交互式 shell，它就会退出。但在退出之前，它会将 SIGHUP 信号传给所有由该 shell 所启动的进程（包括正在运行的 shell 脚本）。

通过 SIGINT 信号，可以中断 shell。Linux 内核会停止为 shell 分配 CPU 处理时间。这种情况发生时，shell 会将 SIGINT 信号传给所有由它所启动的进程，以此告知出现的状况。

shell 会将这些信号传给 shell 脚本程序来处理。而 shell 脚本的默认行为是忽略这些信号。它们可能会不利于脚本的运行。要避免这种情况，你可以脚本中加入识别信号的代码，并执行命令来处理信号。

### 生成信号

bash shell 允许用键盘上的组合键生成两种基本的 Linux 信号。这个特性在需要停止或暂停失控程序时非常方便。

1. 中断进程

Ctrl+C 组合键会生成 SIGINT 信号，并将其发送给当前在 shell 中运行的所有进程。可以运行一条需要很长时间才能完成的命令，然后按下 Ctrl+C 组合键来测试它。

```bash
$ sleep 100
^C
$ 
```

Ctrl+C 组合键会发送 SIGINT 信号，停止 shell 中当前运行的进程。sleep 命令会使得 shell 暂停指定的秒数，命令提示符直到计时器超时才会返回。在超时前按下 Ctrl+C 组合键，就可以提前终止 sleep 命令。

2. 暂停进程

可以在进程运行期间暂停进程，而无需终止它。尽管有时这可能会比较危险（比如，脚本打开了一个关键的系统文件的文件锁），但通常它可以在不终止进程的情况下使你能够深入脚本内部一窥究竟。

Ctrl+Z 组合键会生成一个 SIGTSTP 信号，停止 shell 中运行的任何进程。停止（stopping）进程跟终止（terminating）进程不同：停止进程会让程序继续保留在内存中，并能从上次停止的位置继续运行。随后你会了解如何重启一个已经停止的进程。

当用 Ctrl+Z 组合键时，shell 会通知你进程已经被停止了。

```bash
$ sleep 100
^Z
[1]+  Stopped                 sleep 100
$ 
```

方括号中的数字是 shell 分配的作业号（job number）。shell 将 shell 中运行的每个进程称为作业，并为每个作业分配唯一的作业号。它会给第一个作业分配作业号 1，第二个作业号 2，以此类推。

如果你的 shell 会话中有一个已停止的作业，在退出 shell 时，bash 会提醒你。

```bash
$ sleep 100
^Z
[1]+  Stopped                 sleep 100
$ exit
exit
There are stopped jobs.
$ 
```

可以用 ps 命令来查看已停止的作业。

```bash
$ ps -lF
F S UID          PID    PPID  C PRI  NI ADDR SZ WCHAN    RSS PSR STIME TTY          TIME CMD
0 S qinghuo     1012     996  0  80   0 -  2954 do_wai  5648  14 11:38 pts/0    00:00:00 /bin/bash --posix
0 S qinghuo     2012    1012  0  80   0 -  8714 do_wai 24168   9 11:55 pts/0    00:00:00 /usr/bin/python -O /usr/bin/ranger
0 S qinghuo     2063    2012  0  80   0 -  2982 do_wai  5868  10 11:55 pts/0    00:00:00 /bin/bash
0 T qinghuo     6753    2063  0  80   0 -  2141 do_sig   876   2 14:05 pts/0    00:00:00 sleep 100
4 R qinghuo     6834    2063  0  80   0 -  3284 -       3484   9 14:07 pts/0    00:00:00 ps -lF
$
```

在 S 列中（进程状态），ps 命令将已停止作业的状态为显示为 T。这说明命令已经被停止了。

如果在有已停止作业存在的情况下，你仍旧想退出 shell，只要再输入一遍 exit 命令就行了。shell 会退出，终止已停止作业。或者，既然你已经知道了已停止作业的 PID，就可以用 kill 命令来发送一个 SIGKILL 信号来终止它。

```bash
$ kill -9 6753
$ 
[1]+  Killed                  sleep 100
$ 
```

在终止作业时，最开始你不会得到任何回应。但下次如果你做了能够产生 shell 提示符的操作（比如按回车键），你就会看到一条消息，显示作业已经被终止了。每当 shell 产生一个提示符时，它就会显示 shell 中状态发生改变的作业的状态。在你终止一个作业后，下次强制 shell 生成一个提示符时，shell 会显示一条消息，说明作业在运行时被终止了。

### 捕获信号

也可以不忽略信号，在信号出现时捕获它们并执行其他命令。trap 命令允许你来指定 shell 脚本要监看并从 shell 中拦截的 Linux 信号。如果脚本收到了 trap 命令中列出的信号，该信号不再由 shell 处理，而是交由本地处理。


```bash
trap commands signals
```

非常简单！在 trap 命令行上，你只要列出想要 shell 执行的命令，以及一组用空格分开的待捕获的信号。你可以用数值或 Linux 信号名来指定信号。

这里有个简单例子，展示了如何使用 trap 命令来忽略 SIGINT 信号，并控制脚本的行为。

```bash
$ cat t1.sh 
#!/bin/bash
# Testing signal trapping
#
trap "echo ' Sorry! I have trapped Ctrl-C'" SIGINT
#
echo "This is a test script"
#
count=1
while [ $count -le 10 ]; do
    echo "Loop #$count"
    sleep 1
    count=$[ $count + 1 ]
done
#
echo "This is the end of the test script"
$
```

本例中用到的 trap 命令会在每次检测到 SIGINT 信号时显示一行简单的文本消息。捕获这些信号会阻止用户用 bash shell 组合键 Ctrl+C 来停止程序。

```bash
$ ./t1.sh 
This is a test script
Loop #1
Loop #2
Loop #3
Loop #4
Loop #5
^C Sorry! I have trapped Ctrl-C
Loop #6
Loop #7
Loop #8
^C Sorry! I have trapped Ctrl-C
Loop #9
Loop #10
This is the end of the test script
$ 
```

每次使用 Ctrl+C 组合键，脚本都会执行 trap 命令中指定的 echo 语句，而不是处理该信号并允许 shell 停止该脚本。

### 捕获脚本退出

除了在 shell 脚本中捕获信号，你也可以在 shell 脚本退出时进行捕获。这是在 shell 完成任务时执行命令的一种简便方法。

要捕获 shell 脚本的退出，只要在 trap 命令后加上 EXIT 信号就行。

```bash
$ cat t2.sh 
#!/bin/bash
# Testing the script exit
#
trap "echo Goodbye..." EXIT
#
count=1
while [ $count -le 5 ]; do
    echo "Loop #$count"
    sleep 1
    count=$[ $count + 1 ]
done
$ 
$ ./t2.sh 
Loop #1
Loop #2
Loop #3
Loop #4
Loop #5
Goodbye...
$ 
```

当脚本运行到正常的退出位置时，捕获就被触发了，shell 会执行在 trap 命令行指定的命令。如果提前退出脚本，同样能够捕获到 EXIT。

```bash
$ ./t2.sh 
Loop #1
Loop #2
Loop #3
^CGoodbye...

$ 
```

因为 SIGINT 信号并没有出现在 trap 命令的捕获列表中，当按下 Ctrl+C 组合键发送 SIGINT 信号时，脚本就退出了。但在脚本退出前捕获到了 EXIT，于是 shell 执行了 trap 命令

### 修改或移除捕获

要想在脚本中的不同位置进行不同的捕获处理，只需重新使用带有新选项的 trap 命令。

```bash
$ cat t3.sh 
#!/bin/bash
# Modifying a set trap
#
trap "echo 'Sorry...Ctrl-C is trapped.'" SIGINT
#
count=1
while [ $count -le 5 ]; do
    echo "Loop #$count"
    sleep 1
    count=$[ $count + 1 ]
done
#
trap "echo ' I modified the trap!'" SIGINT
#
count=1
while [ $count -le 5 ]; do
    echo "Second Loop #$count"
    sleep 1
    count=$[ $count + 1 ]
done
$
```

修改了信号捕获之后，脚本处理信号的方式就会发生变化。但如果一个信号是在捕获被修改前接收到的，那么脚本仍然会根据最初的 trap 命令进行处理。

```bash
$ ./t3.sh 
Loop #1
Loop #2
Loop #3
^CSorry...Ctrl-C is trapped.
Loop #4
Loop #5
Second Loop #1
Second Loop #2
^C I modified the trap!
Second Loop #3
Second Loop #4
Second Loop #5
$ 
```

也可以删除已设置好的捕获。只需要在 trap 命令与希望恢复默认行为的信号列表之间加上两个破折号就行了。

```bash
$ cat t3b.sh 
#!/bin/bash
# Removing a set trap
#
trap "echo 'Sorry...Ctrl-C is trapped.'" SIGINT
#
count=1
while [ $count -le 5 ]; do
    echo "Loop #$count"
    sleep 1
    count=$[ $count + 1 ]
done
#
# Remove the trap
trap -- SIGINT
echo ' I just removed the trap!'
#
count=1
while [ $count -le 5 ]; do
    echo "Second Loop #$count"
    sleep 1
    count=$[ $count + 1 ]
done

$ 
$ ./t3b.sh 
Loop #1
Loop #2
Loop #3
Loop #4
Loop #5
 I just removed the trap!
Second Loop #1
Second Loop #2
Second Loop #3
Second Loop #4
Second Loop #5
$ 
```

> 也可以在 trap 命令后使用单破折号来恢复信号的默认行为。单破折号和双破折号都可以正常发挥作用。

移除信号捕获后，脚本按照默认行为来处理 SIGINT 信号，也就是终止脚本运行。但如果信号是在捕获被移除前接收到的，那么脚本会按照原先 trap 命令中的设置进行处理。

```bash
$ ./t3b.sh 
Loop #1
Loop #2
Loop #3
^CSorry...Ctrl-C is trapped.
Loop #4
Loop #5
 I just removed the trap!
Second Loop #1
Second Loop #2
Second Loop #3
^C
$ 
```

在本例中，第一个 Ctrl+C 组合键用于提前终止脚本。因为信号在捕获被移除前已经接收到了，脚本会照旧执行 trap 中指定的命令。捕获随后被移除，再按 Ctrl+C 就能够提前终止脚本了。

## 以后台模式运行脚本



# 处理输出

到目前为止，本书中出现的脚本都是通过将数据打印在屏幕上或将数据重定向到文件中来显示信息。之前演示了如何将命令的输出重定向到文件中。本章将会展开这个主题，演示如何将脚本的输出重定向到 Linux 系统的不同位置。

## 理解输入和输出

- 在屏幕上显示输出
- 将输出重定向到文件中

这两种方法要么将数据输出全部显示，要么什么都不显示。但有时将一部分数据在显示器上显示，另一部分数据保存到文件中也是不错的。对此，了解 Linux 如何处理输入输出能够帮助你就能将脚本输出放到正确位置。

### 标准文件描述符

Linux 系统将每个对象当作文件处理。这包括输入和输出进程。Linux 用 ```文件描述符```(filedescriptot)来标识每个文件对象。文件描述符是一个非负整数，可以唯一标识会话中打开的文件。每个进程一次最多可以有九个文件描述符。出于特殊目的，bash shell 保留了前三个文件描述符（0、1 和 2）。这三个特殊文件描述符会处理脚本的输入和输出。

- 0 缩写：STDIN 含义：标准输入
- 1 缩写：STDOUT 含义：标准输出
- 2 缩写：STDERR 含义：标准错误

shell 用它们将 shell 默认的输入和输出导向到相应的位置。

1. STDIN

STDIN 文件描述符代表 shell 的标准输入。对终端界面来说，标准输入是键盘。shell 从 STDIN 文件描述符对应的键盘获得输入，在用户输入时处理每个字符。

在使用输入重定向符号（<）时，Linux 会用重定向指定的文件来替换标准输入文件描述符。它会读取文件并提取数据，就如同它是键盘上键入的。

许多 bash 命令能接受 STDIN 的输入，尤其是没有在命令行上指定文件的话。下面是个用 cat 命令处理 STDIN 输入的数据的例子。

```bash
$ cat
this is a test
this is a test
this is a second test.
this is a second test.
#未完，cat会继续等待STDIN(从键盘的输入)之后会返回一行相同的输入，继续等待
```

当在命令行上只输入 cat 命令时，它会从 STDIN 接受输入。输入一行，cat 命令就会显示出一行。但你也可以通过 STDIN 重定向符号强制 cat 命令接受来自另一个非 STDIN 文件的输入。

```bash
$ cat < testfile
This is the first line.
This is the second line.
This is the third line.
$ 
```

现在 cat 命令会用 testfile 文件中的行作为输入。你可以使用这种技术将数据输入到任何能从 STDIN 接受数据的 shell 命令中。

2. STDOUT

STDOUT 文件描述符代表 shell 的标准输出。在终端界面上，标准输出就是终端显示器。shell 的所有输出（包括 shell 中运行的程序和脚本）会被定向到标准输出中，也就是显示器。

默认情况下，大多数 bash 命令会将输出导向 STDOUT 文件描述符。你可以用输出重定向来改变输出位置。


```bash
$ ll > test2 
$ cat test2 
total 0
-rw-r--r-- 1 qinghuo qinghuo 0 Jan  5 23:27 test
-rw-r--r-- 1 qinghuo qinghuo 0 Jan  5 23:27 test2
$ 
```

通过输出重定向符号，通常会显示到显示器的所有输出会被 shell 重定向到指定的重定向文件。你也可以将数据追加到某个文件。这可以用>>符号来完成

```bash
$ who >> test2 
$ cat test2 
total 0
-rw-r--r-- 1 qinghuo qinghuo 0 Jan  5 23:27 test
-rw-r--r-- 1 qinghuo qinghuo 0 Jan  5 23:27 test2
qinghuo  tty1         2023-01-04 07:12
qinghuo  pts/2        2023-01-04 10:05 (tmux(4336).%0)
qinghuo  pts/3        2023-01-04 10:08 (tmux(4336).%1)
$ 
```

who 命令生成的输出会被追加到 test2 文件中已有数据的后面。

但是，如果你对脚本使用了标准输出重定向，你会遇到一个问题。下面的例子说明了可能会出现什么情况。

```bash
$ ll badfile > test3
ls: cannot access 'badfile': No such file or directory
$ cat test3 
$ 

```

当命令生成错误消息时，shell 并未将错误消息重定向到输出重定向文件。shell 创建了输出重定向文件，但错误消息却显示在了显示器屏幕上。注意，在显示 test3 文件的内容时并没有任何错误。test3 文件创建成功了，只是里面是空的。

shell 对于错误消息的处理是跟普通输出分开的。如果你创建了在后台模式下运行的 shell 脚本，通常你必须依赖发送到日志文件的输出消息。用这种方法的话，如果出现了错误信息，这些信息是不会出现在日志文件中的。你需要换种方法来处理。

3. STDERR

shell 通过特殊的 STDERR 文件描述符来处理错误消息。STDERR 文件描述符代表 shell 的标准错误输出。shell 或 shell 中运行的程序和脚本出错时生成的错误消息都会发送到这个位置。

默认情况下，STDERR 文件描述符会和 STDOUT 文件描述符指向同样的地方（尽管分配给它们的文件描述符值不同）。也就是说，默认情况下，错误消息也会输出到显示器输出中。

但从上面的例子可以看出，STDERR 并不会随着 STDOUT 的重定向而发生改变。使用脚本时，你常常会想改变这种行为，尤其是当你希望将错误消息保存到日志文件中的时候。

### 重定向错误

你已经知道如何用重定向符号来重定向 STDOUT 数据。重定向 STDERR 数据也没太大差别，只要在使用重定向符号时定义 STDERR 文件描述符就可以了。有几种办法实现方法。

1. 只重定向错误

你已经知道，STDERR 文件描述符被设成 2。可以选择只重定向错误消息，将该文件描述符值放在重定向符号前。该值必须紧紧地放在重定向符号前，否则不会工作。

```bash
$ ll badfile 2> test4
$ cat test4 
ls: cannot access 'badfile': No such file or directory
$ 
```

现在运行该命令，错误消息不会出现在屏幕上了。该命令生成的任何错误消息都会保存在输出文件中。用这种方法，shell 会只重定向错误消息，而非普通数据。这里是另一个将 STDOUT 和 STDERR 消息混杂在同一输出中的例子。

```bash
$ ll test badtest test2 2> test5
-rw-r--r-- 1 qinghuo qinghuo 256 Jan  5 23:28 test2
$ cat test5
ls: cannot access 'test': No such file or directory
ls: cannot access 'badtest': No such file or directory
$ 
```

ll 命令的正常 STDOUT 输出仍然会发送到默认的 STDOUT 文件描述符，也就是显示器。由于该命令将文件描述符 2 的输出（STDERR）重定向到了一个输出文件，shell 会将生成的所有错误消息直接发送到指定的重定向文件中。

2. 重定向错误和正常输出

如果想重定向错误和正常输出，必须用两个重定向符号。需要在符号前面放上待重定向数据所对应的文件描述符，然后指向用于保存数据的输出文件。

```bash
$ ll test test2 test3 badtest 2> test6 1> test7
$ cat test6
ls: cannot access 'test': No such file or directory
ls: cannot access 'badtest': No such file or directory
$ cat test7
-rw-r--r-- 1 qinghuo qinghuo 256 Jan  5 23:28 test2
-rw-r--r-- 1 qinghuo qinghuo   0 Jan  5 23:30 test3
$ 
```

shell 利用 1>符号将 ls 命令的正常输出重定向到了 test7 文件，而这些输出本该是进入 STDOUT 的。所有本该输出到 STDERR 的错误消息通过 2>符号被重定向到了 test6 文件。

可以用这种方法将脚本的正常输出和脚本生成的错误消息分离开来。这样就可以轻松地识别出错误信息，再不用在成千上万行正常输出数据中翻腾了。

另外，如果愿意，也可以将 STDERR 和 STDOUT 的输出重定向到同一个输出文件。为此 bash shell 提供了特殊的重定向符号&>。

```bash
$ ll test test2 test3 badtest &> test7
$ cat test7
ls: cannot access 'test': No such file or directory
ls: cannot access 'badtest': No such file or directory
-rw-r--r-- 1 qinghuo qinghuo 256 Jan  5 23:28 test2
-rw-r--r-- 1 qinghuo qinghuo   0 Jan  5 23:30 test3
$ 
```

当使用&>符时，命令生成的所有输出都会发送到同一位置，包括数据和错误。你会注意到其中一条错误消息出现的位置和预想中的不一样。badtest 文件（列出的最后一个文件）的这条错误消息出现在输出文件中的第二行。为了避免错误信息散落在输出文件中，相较于标准输出，bash shell 自动赋予了错误消息更高的优先级。这样你能够集中浏览错误信息了。

## 在脚本中重定向输出

如果有意在脚本中生成错误消息，可以将单独的一行输出重定向到 STDERR。你所需要做的是使用输出重定向符来将输出信息重定向到 STDERR 文件描述符。在重定向到文件描述符时，你必须在文件描述符数字之前加一个&：








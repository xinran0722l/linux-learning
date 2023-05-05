# 直接定址表

本章讨论如何有效合理地组织数据，及相关技巧

## 描述单元长度的标号

前面的章节，我们一直在代码段中使用标号来标记指令、数据、段的起始地址。比如：下面的程序将 code 段中的 a 标号处的 8 个数据累加，结果存储到 b 标号处的字中

```asm
assume cs:code
code segment
    a:  db 1,2,3,4,5,6,7,8
    b:  dw 0

start:
    mov si,offset a
    mov bx,offset b
    mov cx,8

s:  mov al,cs:[si]
    mov ah,0
    add cs:[bx],ax
    inc si
    loop s

    mov ax,4c00H
    int 21H
code ends
end start
```

上面程序中，code、a、b、start、s 都是标号。这些标号仅仅表示了内存单元的地址

但是，我们还可以使用一种标号，这种标号*不但表示内存单元的地址* ，还`表示了内存单元的长度`，即`表示在此标号处的单元，是字单元、字节单元还是双字单元`。上面的程序还可以写成这样：

```asm
assume cs:code
code segment
    a  db 1,2,3,4,5,6,7,8
    b  dw 0

start:
    mov si,0
    mov cx,8

s:  mov al,a[si]
    mov ah,0
    add b,ax
    inc si
    loop s

    mov ax,4c00H
    int 21H
code ends
end start
```

在 code 段中使用的标号 a、b 后面没有 *:* ,他们是`同时描述内存地址和单元长度的标号`。`标号 a,描述了地址 code:0，和从这个地址开始，以后的内存单元都是字节单元`。`而标号 b 描述了地址 code:8，从这个地址开始，以后的内存单元都是字单元`

因为这种标号包含了对单元长度的描述，所以在指令中，它可以代表一个段中的内存单元。比如：对于程序中的 `b dw 0` 

```asm
指令：  mov ax,b
相当于：mov ax,cs:[8]

指令：  mov b,2
相当于：mov word ptr cs:[8],2

指令：  inc b
相当于：inc word ptr cs:[8]
```

在这些指令中，标号 b 代表了一个内存单元，地址为 code:8，长度为两个字节

下面的指令会引发编译错误

`mov al,b`

因为 b 代表的是内存单元，是字单元，而 al 是 8 位寄存器

如果我们将程序中的指令 `add b,ax`,写为 `add b,al` ,将出现同样的编译错误

对于程序中的 `a db 1,2,3,4,5,6,7,8`

```asm
指令：  mov al,a[si]
相当于：mov al,cs:0[si]

指令：  mov al,a[3]
相当于：mov al,cs:0[3]

指令：  mov al,a[bx+si+3]
相当于：mov al,cs:0[bx+si+3]
```

可见，使用这种包含单元长度的标号，可以让我们以简洁的形式访问内存中的数据。以后，我们将这种标号称为`数据标号`，`它标记了存储数据的单元的地址和长度，不同于仅仅表示地址的地址标号`

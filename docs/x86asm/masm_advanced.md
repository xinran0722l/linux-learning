# 汇编进阶

## 数据处理的2个基本问题

计算机是进行数据处理、运算的机器，那么有两个基本的问题就包含在其中
1. 处理的数据在什么地方？
2. 要处理的数据有多长？

```x86asm
;bx si di bp 都是可以表示内存地址
;这4个寄存器可以单个出现，或只能以4种组合出现

;下面两行指令是错误的
mov ax,[bx + bp]
mov ax,[si + di]
```

> 只要在 [...] 中使用寄存器```bp```,而指令中没有显性给出段地址，则段地址默认在```ss```中

?> 在没有寄存器名存在的情况下，用操作符```X ptr```指明内存单元的长度，X 在汇编指令中可以为 word 或 byte。
在没有寄存器参与的内存单元访问指令中，用 word ptr 或 byte ptr *显性地指令要访问的内存单元的长度是必要* 
```x86asm
;下面的指令中，用 word ptr 指明了指令访问的内存单元是一个字单元
mov word ptr ds:[0],1
inc word ptr [bx]
inc word ptr ds:[0]
add word ptr [bx],2

;下面的指令，用 byte ptr 指令了指令访问的内存单元是一个字节单元
mov byte ptr ds:[0],1
inc byte ptr [bx]
inc byte ptr ds:[0]
add byte ptr [bx],2
```
## div 指令

div 是除法指令，用div做除法时应注意几个问题

1. 除数：有8位和16位两种
2. 被除数：默认放在 ax 或 dx和ax 中，如果除数为 8 位，被除数为16位，结果在ax中存放。如果除数为16位，被除数则为32位，在 dx 和 ax 中存放，dx 存放高16位，ax存放低16位
3. 结果：如果除数为 8 位，则 al 存储除法操作的商， ah 存储除法操作的余数。如果除数位 16 位，则 ax 存储除法操作的商， dx 存储除法操作的余数

```x86asm
div reg ; reg 表示一个普通寄存器(ax,bx,cx,dx等)
div 内存单元

div byte ptr ds:[0]
;(al) = (ax) / ((ds) * 16 + 0)的商
;(ah) = (ax) / ((ds) * 16 + 0)的余数

div word ptr es:[0]
;(ax) = [ (dx) * 10000H + (ax)] / ((es) * 16 + 0)的商
;(dx) = [ (dx) * 10000H + (ax)] / ((es) * 16 + 0)的余数

div byte ptr [bx + si + 8]
;(al) = (ax) / ((ds) * 16 + (bx) + (si) + 8)的商
;(ah) = (ax) / ((ds) * 16 + (bx) + (si) + 8)的余数

div word ptr [bx + si + 8]
;(ax) = [ (dx) * 10000H + (ax)] / ((ds) * 16 + (bx) + (si) + 8) 的商
;(dx) = [ (dx) * 10000H + (ax)] / ((ds) * 16 + (bx) + (si) + 8) 的余数 
```

- 用div 指令计算 10001 / 100

被除数 100001 大于 65535,只能用 ax 和 dx 联合存放 100001。即要进行 16 位的除法,除数100小于255,可以在
一个8位寄存器中存放，但是，因为被除数是 32 位的，除数应为16位，所以要用一个 16 位寄存器来存放除数 100

要分别位 dx 和 ax 赋值 100001 的高16位和低16位，所以应先将 100001 表示为 16进制形式：186A1H。程序如下

```x86asm
mov dx,1
mov ax,86A1H    ;(dx) * 10000H + (ax) = 100001
mov bx,64H  ; 64H = 100(ten)
div bx

;结果
;(ax) = 03e8H 即1000
;(dx) = 1   即余数1
```

- 用 div 计算 1001 / 100

```x86asm
mov ax,03e9H    ;03e9H == 10001
mov bl,64H   ;64H == 100
div bl

;结果
;(al) = 0AH 即10
;(ah) = 1   余数为1
```

### dd 伪指令

db 和 dw 定义字节型数据和字型数据。dd 用来定义 dword(double word,双字)型数据的。比如

```x86asm
data segment
    db 1    ;db 1 为01H,在data:0处，占1个字节
    dw 1    ;dw 1 为0001H,在data:1处，占1个字
    dd 1    ;dd 1 为00000001H,在data:3处，占2个字
data ends
```

用div 计算data 段中第一个数据除以第二个数据后的结果，商存储在第三个数据的存储单元内

```x86asm
assume cs:code,ds:data
data segment
	dd 100001
	dw 100
	dw 0
data ends

code segment
start:	mov ax,data
	mov ds,ax

	mov ax,ds:[0]	;ds:0 字单元中的低16位存储在 ax 中
	mov dx,ds:[2]	;ds:2 字单元中的高16位存储在 dx 中
	div word ptr ds:[4]	;用dx:ax 中的32位数据除以 ds:4 字单元中的数据
	mov ds:[6],ax	; 将商存储在 ds:6 字单元中

	mov ax,4c00H
	int 21H
code ends
end start
```

一组信息记录形式如下：

```x86asm
公司名称： DEC
总裁姓名：Ken Olsen
排    名：137
收    入：40
著名产品：PDP(小型机)
```
现在信息有了如下变化

```
Ken Olsen 的排名已上升至38
DEC 的收入增加至 70
该公司的著名产品已变为 VAX 系列计算机
```

修改内存中的过时数据

```x86asm
assume cs:codesg,ds:datasg
datasg segment
;为了在 debug 中直观显示，排名和收入写为了16进制
;以下4行数据在同一段，最后一行产品数据在第二段
	db 'DEC'	;公司名
	db 'Ken Olsen'	;总裁名
	dw 137H		;排名	=> 38
	dw 40H		;收入	=> 70
	db 'PDP'	;著名产品	=> 'VAX'
datasg ends

codesg segment
start:	mov ax,datasg
	mov ds,ax
	mov bx,0

	mov word ptr ds:[bx+12],38H 
	mov word ptr ds:[bx+14],70H

	mov si,0
	mov byte ptr ds:[bx+si+10H],'V'
	inc si
	mov byte ptr ds:[bx+si+10H],'A'
	inc si
	mov byte ptr ds:[bx+si+10H],'V'

	mov ax,4c00H
	int 21H
codesg ends
end start
```

### dup 

dup 是一个操作符，同 db、dw、dd 一样，也是由编译器处理的。他是和db、dw、dd等数据定义位指令配合使用，用来进行数据的重复

```x86asm
db 重复次数 dup (重复的字节型数据)
dw 重复次数 dup (重复的字型数据)
dd 重复次数 dup (重复的双字型数据)

db 3 dup (0)
;定义了3个字节，他们的值都是0，相当于 db 0,0,0

db 3 dup (0,1,2)
;定义了9个字节，他们是0,1,2,0,1,2,0,1,2 相当于 db 0,1,2,0,1,2,0,1,2

db 3 dup ('abc','ABC')
;定义了18个字节，他们是‘abcABCabcABCabcABC'

stack segment
    db 200 dup (0)
stack ends
;定义一个容量为200个字节的栈空间
```

## 转移指令

```可以修改IP,或同时修改CS和IP的指令统称为转移指令```,转移指令就是可以控制CPU执行内存中某处代码的指令

- 8086CPU的转移行为有两类
    1. 只修改IP，时，称为段内转移，如：jmp ax
    2. 同时修改CS和IP时，称为段间转移，如：jmp 1000:0
- 由于转移指令对IP的修改范围的不同，段内转移又分为：短转移和近转移
    1. 短转移IP的修改范围为 -128～127
    2. 近转移IP的修改范围为-32768~32767
- 8086CPU的转移指令分为一下几类
    1. 无条件转移指令(jmp)
    2. 条件转移指令
    3. 循环指令(loop)
    4. 过程
    5. 中断

### offset 操作符

操作符 offset 在汇编中是由编译器处理的符号，它的功能是取得*标号*的偏移地址

```x86asm
assume cs:codesg
codesg segment
    start:	mov ax,offset start	;相当于 mov ax,0
   	    s:  mov bx,offset s		;相当于 mov bx,3
codesg ends
end start
```

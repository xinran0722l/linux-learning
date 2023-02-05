# 汇编基础

## debug

- r 查看、改变CPU寄存器
- d 查看内存中的内容
- e 改写内存中的内容
- u 将内存中的机器指令翻译成汇编指令
- t 执行一条机器指令
- a 以汇编指令的格式在内存中写入机器指令

计算机内的地址可以表示为```段地址:偏移地址```的格式,eg：```1000:0```,然后用```d 1000:0```列出 *1000:0*处的内容

## 基础指令

- add 加法
- sub 减法
- mul 乘法
- div 除法
- shl 左移
- shr 右移
- rol 循环左移(左移后的数字会补在最后)
- ror 循环右移(右移后的数字会补在最前)
- inc ax 等于 ax++
- dec ax 等于 ax--
- nop 空指令
- xchg 交换指令
- neg 取反
- int n 中断(除零会触发int 0 这个中断)
- jmp 跳转
- sdd 带借位减法指令
- cmp 比较指令，相当于减法指令，且不保存结果

```asm
mov 寄存器，数据    eg：mov ax,8
mov 寄存器，寄存器  eg：mov ax,bx
mov 寄存器，内存单元  eg：mov ax,[0]
mov 内存单元，寄存器  eg：mov [0],ax
mov 段寄存器，寄存器  eg：mov ds,ax

add 寄存器，数据    eg：add ax,8
add 寄存器，寄存器  eg：add ax,bx
add 寄存器，内存单元  eg：add ax,[0]
add 内存单元，寄存器  eg：add [0],ax

sub 寄存器，数据    eg：sub ax,8
sub 寄存器，寄存器  eg：sub ax,bx
sub 寄存器，内存单元  eg：sub ax,[0]
sub 内存单元，寄存器  eg：sub [0],ax
```

## 地址

段地址 * 16 + 偏移地址 = 物理地址

## 寄存器

- DS(Data Segment) 数据段寄存器 通常存放要访问数据的段地址
- SS(Stack Segment) 堆栈寄存器 ```SS:SP```指向栈顶元素
- SP(Stack Pointer) 堆栈指针寄存器
- AH&AL = AX(Accumulator) 累加寄存器
- BH&BL = BX(Base) 基址寄存器
- CH&CL = CS(Count) 计数寄存器
- DH&DL = DX(Data) 数据寄存器
- BP(Base Pointer) 基址指针寄存器
- SI(Source Index) 源变址寄存器
- DI(Destination Index) 目的变址寄存器
- IP(Instruction Pointer) 指令指针寄存器
- CS(Code Segment) 代码段寄存器
- ES(Extra Segment) 附加段寄存器


## 栈

























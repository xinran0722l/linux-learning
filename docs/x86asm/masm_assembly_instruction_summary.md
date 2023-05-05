# 汇编指令总结

8086CPU 的指令系统如下(详细的 8086 指令系统中的各个指令的用法，可以查询相关的指令手册)

8086CPU 提供以下几大类指令

## 数据传送指令

eg: `mov, push, pop, pushf, popf, xchg` 等都是数据传送指令，这些指令实现*寄存器和内存、寄存器和寄存器之间的单个数据传送* 

## 算术运算指令

eg: `add, sub, adc, sbb, inc, dec, cmp, imul, idiv, aaa` 等都是算术运算指令，这些指令实现 *寄存器和内存中的数据的算术运算。他们的执行结果影响 flag 寄存器的 SF, ZF, OF, CF, PF, AF 位* 

## 逻辑指令

eg: `and, or, not, xor, test, shl, shr, sal, sar, rol, ror, rcl, rcr` 等都是逻辑指令。*除了 not 指令外，他们的执行结果都影响 flag 寄存器的相关标志位* 

## 转移指令

eg: 可以修改 IP,或同时修改 CS 和 IP 的指令统称为转移指令。转移指令分为以下几类

1. 无条件转移指令，eg：jmp
2. 条件转移指令，eg：jcxz, je, jb, ja, jnb, jna...
3. 循环指令，eg：loop
4. 过程，eg：call, ret, retf
5. 中断，eg：int, iret

## 处理机控制指令

*这些指令对 flag 寄存器或其他处理机状态进行设置*  eg:`cld, std, cli, sti, nop, clc, cmc, stc, hlt, wait, esc, lock` 等都是处理机控制指令

## 串处理指令

`这些指令对内存中的批量数据进行处理`, eg: `movsb, movsw, cmps, scas, lods, stos`。*若要使用这些指令方便地进行批量数据的处理，还需要和 rep、 repe、 repne 等前缀指令配合使用* 




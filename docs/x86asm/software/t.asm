assume cs:code,ds:dataseg,ss:stackseg
dataseg segment
    mus_freq  dw  262,262,262,196,330,330,330,262
            dw 262,330,392,392,349,330,294
            dw 294,330,349,349,330,294,330,262
            dw 262,330,294,196,247,294,262,-1

    mus_time  dw  3 dup(12,12,25,25),12,12,50
            dw 3 dup (12,12,25,25),12,12,50
dataseg ends
stackseg segment
    db 100H dup (0)
stackseg ends
code segment

start:
    mov ax,stackseg
    mov ss,ax
    mov sp,100H
    mov ax,dataseg
    mov ds,ax
    lea si,mus_freq
    lea di,mus_time

play:
    mov dx,[si]
    cmp dx,-1
    je end_play
    call sound
    add si,2
    add di,2
    jmp play
end_play:
    mov ax,4c00H
    int 21H

;===============================================
sound:
    push ax
    push dx
    push cx

    ;8253芯片(定时/计数器)的设置
    mov al,0B6H
    out 43H,al
    mov dx,12H
    mov ax,34DCh
    div word ptr [si]
    out 42H,al
    mov al,ah
    out 42H,al

    ;设置8253芯片，控制扬声器的开/关
    in al,61H
    mov ah,al
    or al,3
    out 61H,al

    ;延时一定的时长
    mov dx,[di]
wait1:
    mov cx,28000
delay:
    nop
    loop delay
    dec dx
    jnz wait1

    ;恢复扬声器端口原值
    mov al,ah
    out 61H,al

    pop cx
    pop dx
    pop ax
    ret

code ends
end start

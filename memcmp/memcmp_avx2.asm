bits 64
default rel

section .rodata
        align 0x20

        a: db "abcdefghijklmnopqrstuvwxyz123456"
        b: db "abcdefghijklmnopqrstuvwxyz123456"

section .text
        global _start

_start:
        vmovdqa ymm0, [rel a]
        vpcmpeqb ymm2, ymm0, [rel b]
        
        vpmovmskb eax, ymm2
        
        inc eax 
        setne dil
        movzx edi, dil 
        
        mov eax, 0x3C
        syscall

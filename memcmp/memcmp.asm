bits 64
default rel

section .rodata
        align 0x20

        a: db "abcdefghijklmnopqrstuvwxyz123456"
        b: db "abcdefghijklmnopqrstuvwxyz123456"

section .text
        global _start

_start:
        vmovdqu ymm0, [rel a]
        vmovdqu ymm1, [rel b]

        vpcmpeqb ymm2, ymm0, ymm1
        vpmovmskb eax, ymm2
        
        cmp eax, -1          
        jne .not_equal

    .equal:
        xor edi, edi 
        jmp .exit

    .not_equal:
        mov edi, 1           

    .exit:
        vzeroupper

        mov eax, 0x3C 
        syscall

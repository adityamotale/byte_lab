bits 64
default rel

section .rodata
    a: db "abcdefghijklmnopqrstuvwxyz123456"
    b: db "mnop"

section .text
    global _start

_start:
        lea rdi, [rel a]
        mov rsi, 0x20
        lea rdx, [rel b]
        mov rcx, 4

        movzx r8d, byte [rdx]
        mov r9, 0x0101010101010101
        imul r8, r9

        lea r10, [rdx + rcx - 1]
        movzx r10d, byte [r10]
        imul r10, r9

        lea r15, [rdi + rcx - 1]

        mov r11, 0x8080808080808080
        xor rax, rax

    .loop:
        cmp rax, rsi
        jae .not_found

        mov r12, [rdi + rax]
        mov r13, [r15 + rax]

        xor r12, r8
        xor r13, r10
        or r12, r13

        mov r14, r12
        not r14
        sub r12, r9
        and r12, r14
        and r12, r11

        jnz .found

        add rax, 8
        jmp .loop

    .found:
        tzcnt r12, r12
        shr r12, 3                  
        add rax, r12                  
        jmp .exit

    .not_found:
        mov rax, -1

    .exit:
        mov rdi, rax
        mov eax, 0x3C
        syscall

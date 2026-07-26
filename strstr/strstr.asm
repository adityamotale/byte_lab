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
        mov rcx, 0x04

        mov r9, rsi
        sub r9, rcx
        inc r9

        mov r10, 0x0101010101010101
        movzx r8d, byte [rdx]
        imul r8, r10

        lea r11, [rdx + rcx - 1]
        movzx r11d, byte [r11]
        imul r11, r10

        lea r15, [rdi + rcx - 1]
        mov rbx, 0x8080808080808080
        xor rax, rax

    .loop:
        cmp rax, r9
        jae .not_found

        mov r12, [rdi + rax]
        mov r13, [r15 + rax]

        xor r12, r8
        xor r13, r11
        or r12, r13

        mov r14, r12
        not r14
        sub r12, r10
        and r12, r14
        and r12, rbx

        jnz .found

    .next_chunk:
        add rax, 0x08
        jmp .loop

    .found:
        tzcnt r14, r12
        shr r14, 0x03

        lea r13, [rax + r14]
        mov r13d, dword [rdi + r13]

        cmp r13d, dword [rdx]
        je .match_confirmed

        lea r13, [r12 - 1]
        and r12, r13
        jnz .found
        jmp .next_chunk

    .match_confirmed:
        add rax, r14
        jmp .exit

    .not_found:
        mov rax, -1

    .exit:
        mov rdi, rax
        mov eax, 0x3C
        syscall

bits 64
default rel

section .rodata
        align 0x20
        
        dummy: db "Howdy from AVX2 ;)", 0x00

section .text
        global _start

_start:
        lea     rdi, [dummy]
        call    strlen

        ; exit(length)
        mov     rdi, rax
        mov     rax, 0x3C
        syscall

; ------------------------------------------------------------
; size_t strlen(const char *str)
;   rdi = pointer
;   rax = length
; ------------------------------------------------------------
strlen:
    mov     rax, rdi
    vpxor   ymm2, ymm2, ymm2

.loop:
    vmovdqu ymm0, [rdi]         ; load 32 bytes

    vpcmpeqb ymm1, ymm0, ymm2
    vpmovmskb ecx, ymm1

    test    ecx, ecx
    jnz     .found

    add     rdi, 32
    jmp     .loop

.found:
    tzcnt   ecx, ecx

    ; length = (current_ptr - start) + index
    sub     rdi, rax
    add     rax, rdi
    add     rax, rcx

    vzeroupper
    ret

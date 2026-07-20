; Compile using `nasm -f elf64 strlen.asm -o strlen.o`

bits 64
default rel

section .text
    global strlen

; ------------------------------------------------------------
; size_t strlen(const char *str)
;
; System V AMD64 ABI
;   rdi = pointer to string
;   rax = length
; ------------------------------------------------------------
strlen:
    mov rax, rdi
    vpxord zmm1, zmm1, zmm1       

.loop:
    vmovdqu8 zmm0, [rdi]
    vmovdqu8 zmm1, [rdi + 0x40]
    vmovdqu8 zmm2, [rdi + 0x80]
    vmovdqu8 zmm3, [rdi + 0xC0]

    vpcmpb k1, zmm0, zmm7, 0
    vpcmpb k2, zmm1, zmm7, 0
    vpcmpb k3, zmm2, zmm7, 0
    vpcmpb k4, zmm3, zmm7, 0

    korq k5, k1, k2
    korq k6, k3, k4
    korq k5, k5, k6

    kortestq k5, k5
    jnz .found_in_block

    add rdi, 0x100
    jmp .loop

.found_in_block:
    kmovq rcx, k1
    test rcx, rcx
    jnz .found
    add rdi, 0x40
    
    kmovq rcx, k2
    test rcx, rcx
    jnz .found
    add rdi, 0x40
    
    kmovq rcx, k3
    test rcx, rcx
    jnz .found
    add rdi, 0x40
    
    kmovq rcx, k4

.found:
    tzcnt rcx, rcx                
    sub rdi, rax
    lea rax, [rdi + rcx]          
    
    vzeroupper
    ret

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
	vpxor ymm2, ymm2, ymm2

.loop:
	vmovdqu ymm0, [rdi]
	
	vpcmpeqb ymm1, ymm0, ymm2
	vpmovmskb ecx, ymm1

	test    ecx, ecx
	jnz     .found

	add     rdi, 0x20
	jmp     .loop

.found:
	tzcnt   ecx, ecx
	
	sub     rdi, rax
	add     rax, rdi
	add     rax, rcx
	
	vzeroupper
	ret

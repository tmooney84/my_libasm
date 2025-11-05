;my_libasm.asm
;
; includes functions:
; strlen      -> my_strlen	;
; strchr      -> my_strchr	;
; memset      -> my_memset
; memcpy      -> my_memcpy
; strcmp      -> my_strcmp	
; memmove     -> my_memmove
; strncmp     -> my_strncmp
; strcasecmp  -> my_strcasecmp
; index       -> my_index
; read        -> my_read	;
; write       -> my_write	;

;===================================================
; my_strlen proc

global my_strlen
section .data

;test_string: db "abcdef", 0

section .text

my_strlen:
	xor rax, rax 			; set counter to zero

.loop:
	cmp byte [rdi + rax], 0		; checks for '\0'
	je .end				; jump to end if equal
	
	inc rax				; otherwise increment rax
	jmp .loop

.end:
	ret

;===================================================
; my_strchar proc
; char *strchar(const char *str, int ch);

global my_strchr
section .data

;test_string: db "abcdef", 0
;test_char: db "c"

section .text

; rdi = str
; rsi = ch

my_strchr:
	xor rax, rax 			; set counter to zero
.loop:
	cmp byte [rdi + rax], sil
	je .found

	cmp byte [rdi + rax], 0 	; check for zero
	je .null

	inc rax

	jmp .loop

.found: add rax, rdi			; return address
jmp .end
	
.null:  xor rax, rax			; return null
	jmp .end	

.end: 
	ret

;===================================================
; my_strcmp proc
; int strcmp(const char *s1, const char *s2);

global my_strcmp
section .data

; rdi = s1
; rsi = s2

section .text

my_strcmp:
	xor rax, rax

.loop:
	mov al, [rdi]
	mov dl, [rsi]
	cmp al, dl
	jne .diff
	
	test al, al
	je .equal

	inc rsi
	inc rdi
	jmp .loop

.diff
	mov eax, 1
	jb .less
	jmp .end

.less
	mov eax, -1
	jmp .end

.equal
	xor eax, eax

.end
	ret


















;===================================================
; my_read proc

; TODO? -1 for errors?
global my_read
section .text

my_read: 
	; On function entry
	; rdi = fd
	; rsi = buf
	; rdx = count

	mov rax, 0
	syscall
	
	;rax = return value (bytes read or -errno)
	ret
;===================================================
; my_write proc
; TODO? -1 for errors?

global my_write
section .text

my_write: 
	; On function entry
	; rdi = fd
	; rsi = buf
	; rdx = count

	mov rax, 1 		; syscall number for write
	syscall			; perform sys call

	; After syscall
	; rax = return value (bytes written or -errno)
	ret			; return to C caller


; Explicitly mark non-executable stack
section .note.GNU-stack noexec

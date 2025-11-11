;my_libasm.asm
;
; includes functions:
; strlen      -> my_strlen	;
; strchr      -> my_strchr	;
; memset      -> my_memset
; memcpy      -> my_memcpy
; strcmp      -> my_strcmp	;
; memmove     -> my_memmove
; strncmp     -> my_strncmp	;
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
global my_strcmp
section .text

; int strcmp(const char *s1, const char *s2)
; rdi = s1
; rsi = s2

my_strcmp:
    xor rax, rax            ; rax = 0 (will hold return value)

.loop:
    mov al, [rdi]           ; load s1[i]
    mov dl, [rsi]           ; load s2[i]

    cmp al, dl              ; compare the bytes
    jl .less
    jg .greater

    test al, al             ; check for null terminator
    je .equal               ; if zero, both matched until end

    inc rdi
    inc rsi
    jmp .loop

.less:
    mov eax, -1
    jmp .end

.greater:
    mov eax, 1
    jmp .end

.equal:
    xor eax, eax

.end:
    ret

;===================================================
; my_strncmp proc
global my_strncmp
section .text

; int strcmp(const char *s1, const char *s2, size_t num)
; rdi = s1
; rsi = s2
; rdx = num

my_strncmp:
    mov r8, rdx
    xor rax, rax            ; rax = 0 (will hold return value)
    xor rcx, rcx	    ; rcx = 0 (holds counter)	
.loop:
    cmp r8, rcx
    je .equal
    
    mov al, [rdi]           ; load s1[i]
    mov dl, [rsi]           ; load s2[i]

    cmp al, dl              ; compare the bytes
    jl .less
    jg .greater

    test al, al             ; check for null terminator
    je .equal               ; if zero, both matched until end

    inc rdi
    inc rsi
    inc rcx
    jmp .loop

.less:
    mov eax, -1
    jmp .end

.greater:
    mov eax, 1
    jmp .end

.equal:
    xor eax, eax

.end:
    ret

;===================================================
; my_strcasecmp proc
global my_strcasecmp
section .text

; int strcasecmp(const char *s1, const char *s2);
; rdi = s1
; rsi = s2

my_strcasecmp:
    xor rax, rax            ; rax = 0 (will hold return value)

.loop:
    mov al, [rdi]           ; load s1[i]
    mov dl, [rsi]           ; load s2[i]

   ; --- convert AL to lowercase if A-Z ---
    cmp al, 'A'
    jb .skip_lower_al
    cmp al, 'Z'
    ja .skip_lower_al
    or al, 0x20		; sets lowercase bit

.skip_lower_al:
    ; --- convert DL to lowercase if A-Z ---
    cmp dl, 'A'
    jb .skip_lower_dl
    cmp dl, 'Z'
    ja .skip_lower_dl
    or dl, 0x20		; sets lowercase bit

.skip_lower_dl:

    cmp al, dl
    jl .less
    jg .greater

    test al, al             ; check for null terminator
    je .equal               ; if zero, both matched until end

    inc rdi
    inc rsi
    jmp .loop

.less:
    mov eax, -1
    jmp .end

.greater:
    mov eax, 1
    jmp .end

.equal:
    xor eax, eax

.end:
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

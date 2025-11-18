;my_libasm.asm
;
; includes functions:
; strlen      -> my_strlen	;
; strchr      -> my_strchr	;
; memset      -> my_memset	;
; memcpy      -> my_memcpy	;
; strcmp      -> my_strcmp	;
; memmove     -> my_memmove
; strncmp     -> my_strncmp	;
; strcasecmp  -> my_strcasecmp  ;
; index       -> my_index	;
; read        -> my_read	;
; write       -> my_write	;

global my_strlen
global my_strchr
global my_index
global my_memset
global my_memcpy
global my_memmove
global my_strcmp
global my_strncmp
global my_strcasecmp
global my_read
global my_write

section .text

;===================================================
; my_strlen proc

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
; my_memset proc

;void* my_memmove( void* dest, const void* src, size_t count);
; rdi = dest
; rsi = src
; rdx = count

;DESCRIPTION
;The memmove() function copies n bytes from memory area src to
;memory area dest.  The memory areas may overlap: copying takes
;place as though the bytes in src are first copied into a temporary
;array that does not overlap src or dest, and the bytes are then 
;copied from the temporary array to dest.

; my_memset proc

; void * my_memset (void * ptr, int value, size_t num);
; rdi = ptr
; rsi = value
; rdx = num

my_memset:
	mov r8, rdi
	xor rcx, rcx			; set counter to 0		
		
.loop:
	cmp rcx, rdx
	je .end 			; jump to end if equal
	mov byte [rdi+rcx], sil 	; copy 'value' into mem location
	
	inc rcx				; otherwise increment rcx
	jmp .loop

.end:
	mov rax, r8
	ret

;===================================================
; my_memmove proc

;void* my_memmove( void* dest, const void* src, size_t count);
; rdi = dest
; rsi = src
; rdx = count

my_memmove:
	mov rax, rdi
	cmp  rdi, rsi
	
	je .done 		; nothing ot move if dest == src

	cmp rdi, rsi
	jb .forward_copy	; dest < src --> safe to copy forward

	; --- Backward copy ---
	; copy from the back to avoid data corruption
	add rsi, rdx
	add rdi, rdx

.back_loop:
	test rdx, rdx
	je .done

	dec rsi
	dec rdi

; load and store data from src[i] to dst[i] 
	mov al, [rsi]	 
	mov [rdi], al

	dec rdx
	jmp .back_loop

	; --- Forward copy ---
.forward_copy:
.forward_loop:
	test rdx, rdx
	je .done

	mov al, [rsi]
	mov [rdi], al

	inc rsi
	inc rdi
	dec rdx
	jmp .forward_loop

.done:
	ret

;===================================================
; my_memcpy proc

; void *my_memcpy(void *dest_str, const void * src_str, size_t n);
; rdi = dest_str
; rsi = stc_str
; rdx = n

my_memcpy:
	mov r8, rdi
	xor rcx, rcx			; set counter to 0		
.loop:
	cmp rcx, rdx
	je .end 			; jump to end if equal	
	
	mov byte al, [rsi + rcx]	
	mov byte [rdi + rcx], al 	; copy src_str[i] into dest_str[i] 
	inc rcx
	jmp .loop

.end:
	mov rax, r8
	ret

;===================================================
; my_strcmp proc

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
; my_index proc
; char *index(const char *str, int ch); 
; [!DEPRICATED POSIX FUNCTION index() as a macro that 
; expands to a call to strchr().]

my_index: 
	call my_strchr

	ret

;===================================================
; my_read proc
; TODO? -1 for errors?

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
section .note.GNU-stack

; Executable name : lowerToUpper
; Version         : 1.0
; Created date    : 2/18/2026
; Last update     : 2/18/2026
; Author          : Youson
; Description     : Changes all the lowercase letters from the standard input in uppercase

bits 64
global _start

section .data
	SYS_READ equ 0
	SYS_WRITE equ 1
	SYS_EXIT equ 60
	
	STDIN equ 0
	STDOUT equ 1

	ErrorMsg db "The standard input must contain at least 1 character", 0x0A ; message if standard input is empty
	ErrorLen equ $-ErrorMsg ; length of the error message

section .bss
	Buffer resb 32 ; buffer containing the string

section .text
	_start:
		mov rax, SYS_READ ; 0 = sys_read
		mov rdi, STDIN ; 0 = stdin
		mov rsi, Buffer ; pointer to Buffer
		mov rdx, 32 ; length of Buffer
		syscall ; system call

		cmp rax, 1
		jb .Error ; if standard input is empty

		mov rbx, 0 ; initializes the index
	
	.Treatment:
		mov cl, [Buffer+rbx] ; processes the rbx-th character
		sub cl, 'a'
		cmp cl, ('z'-'a')
		ja .NotLowLetter ; if the character is not a lowercase letter

		sub byte [Buffer+rbx], 32 ; else change it in uppercase

	.NotLowLetter:
		inc rbx ; increments the loop index
		cmp rbx, rax ; compare the index with the buffer length
		jne .Treatment ; if all the character have been processed

		mov rax, SYS_WRITE ; 1 = sys_write
		mov rdi, STDOUT ; 1 = stdout
		mov rsi, Buffer ; pointer to Buffer
		mov rdx, rbx ; length of Buffer already contained in rbx
		syscall ; system call

		mov rax, SYS_EXIT ; 60 = sys_exit
		mov rdi, 0 ; 0 = nothing to return
		syscall ; system call

	.Error:
		mov rax, SYS_WRITE ; 1 = sys_write
		mov rdi, STDOUT	; 1 = stdout
		mov rsi, ErrorMsg ; pointer to the string
		mov rdx, ErrorLen ; length of the string
		syscall ; system call

		mov rax, SYS_EXIT ; 60 = sys_exit
		mov rdi, 1 ; 1 = error
		syscall ; system call

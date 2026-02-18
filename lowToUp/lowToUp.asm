; Executable name : lowToUp
; Version         : 1.0
; Created date    : 2/17/2026
; Last update     : 2/18/2026
; Author          : Youson
; Description     : Takes a lowercase character as input and displays its uppercase equivalent

bits 64
global _start

section .data
	SYS_READ equ 0
	SYS_WRITE equ 1
	SYS_EXIT equ 60

	STDIN equ 0
	STDOUT equ 1

	ErrorMsg db "The standard input must contain 1 lowercase letter", 0x0A ; message if standard input is not 1 lowercase letter
	ErrorLen equ $-ErrorMsg ; length of the error message

section .bss
	Buffer resb 1 ; buffer containing the character

section .text
	_start:
		mov rax, SYS_READ ; 0 = sys_read
		mov rdi, STDIN ; 0 = stdin (file descriptor)
		mov rsi, Buffer ; pointer to Buffer
		mov rdx, 1 ; length of the buffer
		syscall ; system call

		cmp rax, 1
		jne .notLowLetter ; if input is not 1 character

		mov al, [Buffer]
		sub al, 'a'
		cmp al, ('z'-'a')
		ja .notLowLetter ; if Buffer don't contain a lowercase letter

		sub byte [Buffer], 32 ; transforms the lowercase letter into its uppercase equivalent (look at ASCII table)

		; displays uppercase letter
		mov rax, SYS_WRITE ; 1 = sys_write
		mov rdi, STDOUT ; 1 = stdout (file descriptor)
		mov rsi, Buffer ; pointer to buffer
		mov rdx, 1 ; length of the buffer
		syscall ; system call

		; end of program (0)
		mov rax, SYS_EXIT ; 60 = sys_exit
		mov rdi, 0 ; 0 = nothing to return
		syscall ; system call

	.notLowLetter:
		mov rax, SYS_WRITE ; 1 = sys_write
		mov rdi, STDOUT ; 1 =stdin
		mov rsi, ErrorMsg ; pointer to the string
		mov rdx, ErrorLen ; length of the string
		syscall ; system call

		; end of program (1)
		mov rax, SYS_EXIT ; 60 = sys_exit
		mov rdi, 1 ; 1 = error
		syscall ; system call

; Executable name : removeNewLine
; Version         : 1.0
; Creation date   : 2/18/2026
; Last update     : 2/18/2026
; Author          : Youson
; Description     : automatically removes the last character, from the standard input, if it's a newline

bits 64
global _start

section .data
	SYS_READ equ 0
	SYS_WRITE equ 1
	SYS_EXIT equ 60

	STDIN equ 0
	STDOUT equ 1

section .bss
	Buffer resb 32 ; buffer containing the string

section .text
	_start:
		mov rax, SYS_READ ; 0 = sys_read
		mov rdi, STDIN ; 0 = stdin
		mov rsi, Buffer ; pointer to Buffer
		mov rdx, 32 ; length of Buffer
		syscall ; system call

		cmp rax, 0
		jle .Exit ; if standard input is empty

		cmp byte [Buffer+rax-1], 0x0A
		jne .Display ; if the last character is not a LF

		dec rax ; to don't display the last character (LF)

	.Display:
		mov rsi, Buffer ; pointer to Buffer
		mov rdx, rax ; length of the final string
		mov rax, SYS_WRITE ; 1 = sys_write
		mov rdi, STDOUT ; 1 = stdout
		syscall ; system call

	.Exit:
		mov rax, SYS_EXIT ; 60 = sys_exit
		mov rdi, 0 ; 0 = nothing to return
		syscall ; system call

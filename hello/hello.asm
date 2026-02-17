; Executable name : hello
; Version         : 1.0
; Created date    : 2/16/2026
; Last update     : 2/16/2026
; Author          : Youson
; Description     : Show message "Hello, NASM!"

section .data
	HelloMsg: db "Hello, NASM!", 0x0A ; message to display in the terminal
	HelloLen: equ $-HelloMsg ; message length

section .bss

section .text

global _start

_start:	
	mov rax, 1 ; 1 = sys_read
	mov rdi, 1 ; 1 = stdout (file descriptor)
	mov rsi, HelloMsg ; pointer to the string
	mov rdx, HelloLen ; length of the string
	syscall ; system call

	mov rax, 60 ; 60 = sys_exit
	mov rdi, 0 ; 0 = nothing to return
	syscall ; system call

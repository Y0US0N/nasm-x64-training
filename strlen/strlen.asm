; Executable name : strlen
; Version         : 1.0
; Created date    : 2/18/2026
; Last update     : 2/18/2026
; Author          : Youson
; Description     : Counts the length of the string, from stdin, up to '\n'

bits 64
global _start

section .data
	SYS_READ equ 0
	SYS_WRITE equ 1
	SYS_EXIT equ 60

	STDIN equ 0
	STDOUT equ 1

	TranslateTable db "0123456789"

section .bss
	Buffer resb 32 ; buffer containing the string to be treated

section .text
	_start:
		mov rax, SYS_READ ; 0 = sys_read
		mov rdi, STDIN ; 0 = stdin
		mov rsi, Buffer ; pointer to the buffer
		mov rdx, 32 ; length of the buffer
		syscall ; system call

		xor rcx, rcx ; counter initialization (number of character before '\n')

		cmp rax, 0
		jl .Error ; if there is an error from stdin

	.Search:
		cmp rax, rcx
		je .InitTranslate ; if all the character from stdin have been processed (there is no '\n')
		cmp byte [Buffer+rcx], 0x0A
		je .InitTranslate ; if all the character before the '\n' have been processed
		
		inc rcx ; 1 more character

		jmp .Search

	.InitTranslate:
		xor r8, r8 ; counter initialization (number of decimal digits)
		mov rax, rcx ; stores the counter (dividend) in rax for the division (look at DIV mnemonic) 
		mov r9, 10 ; stores the divisor in rbx (look at DIV mnemonic)

	.Translate:
		xor rdx, rdx ; most significant portion of the dividend must be null (look at DIV mnemonic
		div r9	; result in RAX and remainder in RDX
		inc r8 ; 1 digit processed
		push rdx ; stores the digits in the stack (less significant digits first)

		cmp rax, 0
		jne .Translate ; if there is any digit left to be processed

	.Display:
		pop rdx ; displays the disgits (most significant digits first)

		mov rax, SYS_WRITE ; 1 = sys_write
		mov rdi, STDOUT ; 1 = stdout
		mov rsi, TranslateTable
		add rsi, rdx ; displays the character equivalent of each digit
		mov rdx, 1 ; displays each digits one by one
		syscall ; system call

		dec r8 ; 1 digit displayed
		cmp r8, 0
		jne .Display ; if there is any digit left to be displayed

		mov rax, SYS_EXIT ; 60 = sys_exit
		xor rdi, rdi ; 0 = nothing to return
		syscall ; system call

	.Error:
		mov rax, SYS_EXIT ; 60 = sys_exit
		mov rdi, 1 ; 1 = error
		syscall ; system call

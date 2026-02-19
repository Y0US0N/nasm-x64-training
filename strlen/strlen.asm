; Executable name : strlen
; Version         : 1.1
; Created date    : 2/18/2026
; Last update     : 2/19/2026
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

section .bss
	InputBuffer resb 32 ; buffer containing the string to be treated
	OutputBuffer resb 20 ; buffer containing the string to be displayed

section .text
	_start:
		mov rax, SYS_READ ; 0 = sys_read
		mov rdi, STDIN ; 0 = stdin
		mov rsi, InputBuffer ; pointer to the buffer
		mov rdx, 32 ; length of the buffer
		syscall ; system call

		xor rcx, rcx ; counter initialization (number of character before '\n')

		cmp rax, 0
		jl .Error ; if there is an error from stdin

	.Search:
		cmp rax, rcx
		je .Init ; if all the character from stdin have been processed (there is no '\n')
		cmp byte [InputBuffer+rcx], 0x0A
		je .Init ; if all the character before the '\n' have been processed
		
		inc rcx ; 1 more character

		jmp .Search

	.Init:
		xor r8, r8 ; counter initialization (number of decimal digits)
		mov rax, rcx ; stores the counter (dividend) in rax for the division (look at DIV mnemonic) 
		mov r9, 10 ; stores the divisor in rbx (look at DIV mnemonic)

	.Count:
		xor rdx, rdx ; most significant portion of the dividend must be null (look at DIV mnemonic
		div r9	; result in RAX and remainder in RDX
		inc r8 ; 1 digit processed
		push rdx ; stores the digits in the stack (less significant digits first)

		cmp rax, 0
		jne .Count ; if there is any digit left to be processed

		mov rdx, r8 ; number of digits to display

	.Translate:
		pop r9
		add r9b, '0'
		mov r10, rdx
		sub r10, r8
		mov byte [OutputBuffer+r10], r9b ; stores the characters of each digit (most significant digits first)

		dec r8 ; 1 digit stored
		cmp r8, 0
		jne .Translate ; if there is any digit left to be stored

		mov byte [OutputBuffer+rdx], 0x0A ; appends '\n' to the end
		inc rdx ; number of characters to display

		mov rax, SYS_WRITE ; 1 = sys_write
		mov rdi, STDOUT ; 1 = stdout
		mov rsi, OutputBuffer ; displays the buffer containing all the equivalent characters of each digit
		syscall ; system call

		mov rax, SYS_EXIT ; 60 = sys_exit
		xor rdi, rdi ; 0 = nothing to return
		syscall ; system call

	.Error:
		mov rax, SYS_EXIT ; 60 = sys_exit
		mov rdi, 1 ; 1 = error
		syscall ; system call

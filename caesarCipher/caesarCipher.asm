; Executable name : caesarCipher
; Version         : 1.0
; Created date    : 2/19/2026
; Last update     : 2/19/2026
; Author          : Youson
; Description     : algorithm for decrypting the Caesar cipher based on the ASCII table

bits 64
global _start

section .data
	SYS_READ equ 0
	SYS_WRITE equ 1
	SYS_EXIT equ 60

	STDIN equ 0
	STDOUT equ 1

section .bss
	Buffer resb 128 ; buffer containing the string to be treated

section .text
	_start:
		mov rax, SYS_READ ; 0 = sys_read
		mov rdi, STDIN ; 0 = stdin
		mov rsi, Buffer ; pointer to the buffer
		mov rdx, 128 ; lentgh of the buffer
		syscall ; system call

		cmp rax, 0
		jle .Error ; if stdin is empty

		mov r8, rax ; stores the length of the string read as input
		mov r9, 26 ; permutation counter

	.Display:
		mov rax, SYS_WRITE ; 1 = sys_write
		mov rdi, STDOUT ; 1 = stdout
		mov rsi, Buffer ; pointer to the buffer
		mov rdx, r8 ; length of the string
		syscall ; system call

		xor r10, r10 ; processed character index

	.Loop:
		cmp byte [Buffer+r10], 'A'
		jb .NextChar ; if the character is below 'A' in ASCII table (65)
		cmp byte [Buffer+r10], 'z'
		ja .NextChar ; if the character is above 'z' in ASCII table (122)
		cmp byte [Buffer+r10], 'Z'
		jbe .Permutation ; if the character is below 'Z' in ASCII table (90)
		cmp byte [Buffer+r10], 'a'
		jae .Permutation ; if the character is above 'a' in ASCII table (97)

	.NextChar:
		inc r10 ; processes the next character
		cmp r10, r8
		jb .Loop ; if not all the characters have been treated

		dec r9 ; processes the next permutation
		cmp r9, 0
		ja .Display ; displays if not all the permutation have been treated

		mov rax, SYS_EXIT ; 60 = sys_exit
		xor rdi, rdi ; 0 = nothing to return
		syscall ; system call

	.Permutation:
		inc byte [Buffer+r10] ; permutation

		cmp byte [Buffer+r10], 'z'
		ja .OutOfRange ; if the permutation has made the character anything other than a lowercase letter
		cmp byte [Buffer+r10], 'a'
		ja .NextChar ; if the character is still a lowercase letter
		cmp byte [Buffer+r10], 'Z'
		ja .OutOfRange ; if the permutation has made the character anything other than a uppercase letter

		jmp .NextChar

	.OutOfRange:
		sub byte [Buffer+r10], 26 ; rotation in the alphabet
		jmp .NextChar

	.Error:
		mov rax, SYS_EXIT ; 60 = sys_exit
		mov rdi, 1 ; 1 = error
		syscall ; system call

; Executable name : isUppercase
; Version         : 1.0
; Created date    : 2/16/2026
; Last update     : 2/17/2026
; Author          : Youson
; Description     : Takes a character as input and tells if it's capital letter or not

section .data
	SYS_READ equ 0
	SYS_WRITE equ 1
	SYS_EXIT equ 60

	STDIN equ 0
	STDOUT equ 1

	ErrorMsg db "The standard input must contain 1 character", 0x0A ; message if stardard input is not 1 character
	ErrorLen equ $-ErrorMsg ; length of the error message
	AffirmativeMsg: db "Uppercase", 0x0A ; message if character is a capital letter
	AffirmativeLen: equ $-AffirmativeMsg ; length of the affirmative message
	NegativeMsg: db "Not uppercase", 0x0A ; message if is not
	NegativeLen: equ $-NegativeMsg ; length of the negative message

section .bss
	Buffer resb 1 ; buffer containing the character

section .text

global _start

_start:
	mov rax, SYS_READ ; 0 = sys_read
	mov rdi, STDIN ; 0 = stdin (file descriptor)
	mov rsi, Buffer ; pointer to the buffer 
	mov rdx, 1 ; length of the buffer
	syscall ; system call
	
	cmp rax, 1
	jne .Error ; if input is not 1 character

	mov al, [Buffer]
	sub al, 'A'
	cmp al, ('Z'-'A')
	ja .Negative ; if not ('A' <= buffer <= 'Z')

	; else
	mov rax, SYS_WRITE ; 1 = sys_write
	mov rdi, STDOUT ; 1 = stdout (file descriptor)
	mov rsi, AffirmativeMsg ; pointer to the string
	mov rdx, AffirmativeLen ; length of the string
	syscall ; system call

.Exit_program:
	mov rax, SYS_EXIT ; 60 = sys_exit
	mov rdi, 0 ; 0 = nothing to return
	syscall ; system call

.Negative:
	mov rax, SYS_WRITE ; 1 = sys_write
	mov rdi, STDOUT ; stdout (file descriptor)
	mov rsi, NegativeMsg ; pointer to the string
	mov rdx, NegativeLen ; length of the string
	syscall ; system call

	jmp .Exit_program

.Error:
	mov rax, SYS_WRITE ; 1 = sys_write
	mov rdi, STDOUT ; 1 = stdout
	mov rsi, ErrorMsg ; pointer to the string
	mov rdx, ErrorLen ; length of the string
	syscall ; system call

	mov rax, SYS_EXIT ; 60 = sys_exit
	mov rdi, 1 ; 1 = error
	syscall ; system call

# nasm-x64-training

This repository contains my training programs written in NASM x64 assembly.

## Environment

- OS: Linux
- Assembler: NASM
- Linker: ld

## How to compile

```bash
nasm -f elf64 -g -F stabs program.asm
ld program.o -o program
./program

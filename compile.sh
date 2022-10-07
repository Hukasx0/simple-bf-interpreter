set -xe 
nasm -f elf64 -o bfInterpreter.o bfInterpreter.asm
ld -o bfInterpreter bfInterpreter.o
rm bfInterpreter.o 

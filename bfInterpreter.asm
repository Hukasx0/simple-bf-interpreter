;           https://github.com/Hukasx0/
;       ~ Hubert Hukasx0 Kasperek
;

section .text
    global _start

_start:
    push rbp
    mov rbp,rsp
    jmp _readFile

_readFile:
    mov rdi,[rbp+24]
    mov rax,2
    mov rsi,0
    syscall
    mov rdi,rax
    mov rax,0
    lea rsi,fileBuffer
    mov rdx,100000
    syscall
    mov rcx,rax
    xor rax,rax
    jmp _interpreter
_interpreter:
    cmp rcx,rax
    je _exit
    push rcx
    mov cl,[fileBuffer+rax]
    push rax
    cmp cl,43
    je inc
    cmp cl,45
    je dec
    cmp cl,62
    je rarr
    cmp cl,60
    je larr
    cmp cl,46
    je out
    cmp cl,44
    je in
    cmp cl,91
    je sLoop
    cmp cl,93
    je eLoop
    jmp loop

inc:
    mov rax,[bfMemory+rbx]
    cmp rax,255
    je twofivefive
    inc rax
    mov [bfMemory+rbx],rax
    jmp loop
twofivefive:
    mov rax,0x0
    mov [bfMemory+rbx],rax
    jmp loop

dec:
    mov rax,[bfMemory+rbx]
    cmp rax,0
    je zero
    dec rax
    mov [bfMemory+rbx],rax
    jmp loop
zero:
    mov rax,0xFF
    mov [bfMemory+rbx],rax
    jmp loop

rarr:
    cmp rbx,30000
    je _exit
    inc rbx
    jmp loop
larr:
    cmp rbx,0
    je _exit
    dec rbx
    jmp loop

out:
    mov rax,1
    mov rdi,1
    lea rsi,[bfMemory+rbx]
    mov rdx,1
    syscall
    jmp loop
in:
    mov rax,0
    mov rdi,0
    lea rsi,[bfMemory+rbx]
    mov rdx,2
    syscall
    jmp loop


sLoop:
    pop rax
    mov [loopStart],rax
    mov [loopMem],rbx
    push rax
    jmp recLoop

recLoop:
    pop rax
    mov cl,[fileBuffer+rax]
    cmp cl,93
    je closeLoop
    inc rax
    push rax
    jmp recLoop
closeLoop:
    dec rax
    push rax
    jmp loop

eLoop:
    mov rcx,[loopMem]
    mov cl,[bfMemory+rcx]
    cmp cl,0
    je loop
    pop rax
    mov rax,[loopStart]
    push rax
    jmp loop

loop:
    pop rax
    pop rcx
    inc rax
    jmp _interpreter

_exit:
    mov rax,60
    xor rdi,rdi
    syscall

section .bss
bfMemory: resb 30000
fileBuffer: resb 100000
loopStart: resb 1
loopMem: resb 1
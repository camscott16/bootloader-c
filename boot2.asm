
bits 16
    org 0x7c00

boot:
mov ax, 0x2401
    int 0x15 ; enable A20 bit

mov ax, 0x3
    int 0x10 ; set vga text mode 3

lgdt [gdt_pointer] ; load the gdt descriptor table
    mov eax, cr0
    or eax, 0x1 ; set the protected mode bit on sepcial CPU reg cr0
    mov cr0, eax
    jmp CODE_SEG:boot2 ; long jump to the code segment


; defining the global descriptor table
gdt_start:
    dq 0x0
gdt_code:
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10011010b
    db 11001111b
    db 0x0
gdt_data:
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0
gdt_end:

; needed to load the gdt
gdt_pointer:
    dw gdt_end - gdt_start
    dd gdt_start
    CODE_SEG equ gdt_code - gdt_start
    DATA_SEG equ gdt_data - gdt_start

; tell nasm to output 32 bit now
bits 32
boot2:
        mov ax, DATA_SEG
        mov ds, ax
        mov es, ax
        mov fs, ax
        mov gs, ax
        mov ss, ax

; write "hello world" in a colored text
mov esi,hello
mov ebx,0xb8000
.loop:
    lodsb
    or al,al
    jz halt
    or eax,0x0100
    mov word [ebx], ax
    add ebx,2
    jmp .loop
halt:
    cli
    hlt
hello: db "Hello world!",0 ; can change this number to edit the text color

times 510 - ($-$$) db 0
dw 0xaa55

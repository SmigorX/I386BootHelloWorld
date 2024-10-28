org 0x7C00                      ; BIOS loads our program at this address
bits 16                         ; We're working in 16-bit mode here

start:
    cli                         ; Disable interrupts
    mov si, msg                 ; SI points to our message
    mov ah, 0x09                ; BIOS teletype output function with attribute
    mov bh, 0x00                ; Page number (0 for current page)
    mov bl, 0x0A                ; Text color (bright green on black)

.loop:
    lodsb                       ; Load byte at SI into AL, increment SI
    or al, al                   ; Check if we've reached the end of the string
    jz halt                     ; Jump to halt if at the end
    mov ah, 0x09                ; Set function for colored teletype output
    mov cx, 1                   ; Print the character once
    int 0x10                    ; Call BIOS interrupt to print with color
    jmp .loop                   ; Repeat for next character

halt:
    hlt                         ; Halt the CPU

msg:
    db "Hello, World!", 0       ; Our actual message to print

;; Boot sector signature
times 510 - ($ - $$) db 0
dw 0xAA55

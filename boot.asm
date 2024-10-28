org 0x7C00                      ; BIOS loads our program at this address
bits 16                         ; We're working in 16-bit mode here

start:
    cli                         ; Disable interrupts (optional for simplicity)
    mov dh, 0x00                ; Row 
    mov bh, 0x00                ; Page number (0 for current page)
    mov bl, 0x01                ; Text and background color 
    call clear_screen
    call clear_loop
    call cursor_setup
    ;call word_print_loop
    ;mov dh, 0x01
    ;mov si, msg
    call row_runner
    jmp done

clear_screen:
    mov ax, 0xB800              ; Load VGA text mode segment
    mov es, ax                  ; Set ES to VGA segment
    mov di, 0x0000              ; Start at the beginning of the VGA memory
    mov cx, 2000                ; 80 columns * 25 rows = 2000 characters

clear_loop:
    mov al, ' '                 ; ASCII space character
    mov ah, 0x0F                ; Attribute byte (white on black)
    stosw                       ; Write AL and AH to ES:DI and increment DI by 2
    loop clear_loop             ; Decrement CX and repeat until CX is zero

cursor_setup:
    mov ah, 0x02                ; Set cursor position function
    mov bh, 0x00                ; Page number (0 for current page)
    mov dh, 0x00                ; Row 
    mov dl, 0x00                ; Column 
    int 0x10                    ; BIOS interrupt to set cursor position

advance_cursor:
    mov ah, 0x02
    inc dl
    int 0x10                    ; BIOS interrupt to set cursor position

word_print_loop:
    lodsb                       ; Load byte at SI into AL and increment SI
    or al, al                   ; Check if AL is zero (end of string)
    jz row_runner                     ; If zero, jump to done
    mov ah, 0x09                ; BIOS 'write character and attribute' function
    mov cx, 1                   ; Print character once
    int 0x10                    ; Call BIOS interrupt to print AL with color
    call advance_cursor         ; Move to the next character
    jmp word_print_loop         ; Repeat for the next character

row_runner:
    inc dh
    mov dl, 0x00
    add bl, 0x11                      ; Increment color
    cmp bl, 0xEF
    jl done
    mov si, msg
    jmp word_print_loop

return_from_word:
    ret

done:
    hlt                         ; Halt the CPU

msg:
    db "Hello World!", 0        ; Null-terminated message string

;; Boot sector signature
times 510 - ($ - $$) db 0       ; Fill the rest of the sector with zeros
dw 0xAA55                       ; Boot sector signature


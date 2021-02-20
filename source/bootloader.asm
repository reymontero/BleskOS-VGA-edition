;BleskOS VGA edition bootloader

org 0x7C00

bits 16

start:
 xor ax, ax
 mov ds, ax
 mov ss, ax
 mov sp, 0x7C00

 ;load bleskos to memory
 mov ah, 0x42
 mov si, disk_packet
 int 13h

 ;jump to executing bleskos
 jmp 0x1000:0x0000

disk_packet:
 dw 0x0010, 127, 0x0000, 0x1000
 dq 1

times 510-($-$$) db 0
dw 0xAA55

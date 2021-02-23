;BleskOS VGA edition

start_drive db 0
drive db 0

disk_packet:
 dw 0x0010, 127, 0x0000
disk_packet_segment:
 dw 0x0000
disk_packet_sector:
 dq 0

read_file:
 ;calculate file position
 mov bx, 128
 mul bx
 mov word [disk_packet_sector], ax

 ;read disk
 mov ah, 0x42
 mov si, disk_packet
 mov dl, byte [drive]
 int 13h

 ret

write_file:
 ;calculate file position
 mov bx, 128
 mul bx
 mov word [disk_packet_sector], ax

 ;write disk
 mov ah, 0x43
 mov si, disk_packet
 mov dl, byte [drive]
 int 13h

 ret

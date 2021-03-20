;BleskOS VGA

dz_fat16_format_packet:
 db 0xEB, 0x3C, 0x90
 db 'BleskOSV'
 dw 512 ;bytes per sector
 db 128 ;every file 64 KB
 dw 1 ;reserved sector
 db 1 ;only one FAT table
 dw 32 ;root dir entries
 dw 4096 ;emulate 4 MB
 db 0xF0 ;media type
 dw 1 ;sectors per FAT
 dw 128 ;sectors per track
 dw 32 ;heads per track
 dd 0 ;hidden sectors
 dd 0 ;extended media size

 db 0x81 ;emulate hard disk
 db 0 ;must be
 db 0x28 ;must be
 dd 0x11111111 ;singature
 db 'BleskOS VGA' ;name
 db 'FAT 16  ' ;fat name
 times 448 db 0
 dw 0xAA55
;FAT table
 times 256 dw 0xFFFF
;root directory 2 sectors
 times 1024 db 0

dz_fat16_format_disk_packet:
 dw 0x0010, 4, dz_fat16_format_packet, 0x1000
 dq 0

dz_format_fat16:
 DRAW_BACKGROUND 0x60

 PRINT 1, 1, str_format_fat16, '[a] Format FAT16   Warning! This destroy all data!'

 .halt:
  WAIT_FOR_KEYBOARD

  IF ah, KEY_ESC, key_esc
   jmp developer_zone
  ENDIF key_esc

  IF al, 'a', key_a
   mov ah, 0x43
   mov dl, 0x81
   mov si, dz_fat16_format_disk_packet
   int 13h

   jc .halt ;problem

   SET_CURSOR 3, 1
   mov ah, 0x0E
   mov al, 'F'
   int 10h
  ENDIF key_a
 jmp .halt

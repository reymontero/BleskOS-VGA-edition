;BleskOS

parameters_packet:
 times 0x13 db 0

dz_drives:
 DRAW_BACKGROUND 0x60

 PRINT 1, 1, str_0x80, '[a] Test 0x80'
 PRINT 3, 1, str_0x81, '[b] Test 0x81'

 .halt:
  WAIT_FOR_KEYBOARD

  IF ah, KEY_ESC, key_esc
   jmp developer_zone
  ENDIF key_esc

  IF al, 'a', key_a
   mov ah, 0x4B
   mov al, 1
   mov dl, 0x80
   mov si, parameters_packet
   int 13h

   jc .halt

   SET_CURSOR 5, 1
   mov ax, word [parameters_packet+0x00]
   call print_hex
   mov ax, word [parameters_packet+0x02]
   call print_hex
  ENDIF key_a

  IF al, 'b', key_b
   mov ah, 0x4B
   mov al, 1
   mov dl, 0x81
   mov si, parameters_packet
   int 13h

   jc .halt

   SET_CURSOR 5, 1
   mov ax, word [parameters_packet+0x00]
   call print_hex
   mov ax, word [parameters_packet+0x02]
   call print_hex
  ENDIF key_b
 jmp .halt

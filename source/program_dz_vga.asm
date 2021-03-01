;BleskOS

dz_vga:
 DRAW_BACKGROUND 0x60

 DRAW_LINE 1, 1, 20, 0x00
 DRAW_LINE 2, 1, 20, 0x10
 DRAW_LINE 3, 1, 20, 0x20
 DRAW_LINE 4, 1, 20, 0x30
 DRAW_LINE 5, 1, 20, 0x40
 DRAW_LINE 6, 1, 20, 0x50
 DRAW_LINE 7, 1, 20, 0x60
 DRAW_LINE 8, 1, 20, 0x70
 DRAW_LINE 9, 1, 20, 0x80
 DRAW_LINE 10, 1, 20, 0x90
 DRAW_LINE 11, 1, 20, 0xA0
 DRAW_LINE 12, 1, 20, 0xB0
 DRAW_LINE 13, 1, 20, 0xC0
 DRAW_LINE 14, 1, 20, 0xD0
 DRAW_LINE 15, 1, 20, 0xE0
 DRAW_LINE 16, 1, 20, 0xF0

 SET_CURSOR 18, 1

 mov ah, 0x0E
 mov al, 160
 int 10h
 mov al, 130
 int 10h
 mov al, 161
 int 10h
 mov al, 162
 int 10h
 mov al, 163
 int 10h

 .halt:
  WAIT_FOR_KEYBOARD

  IF ah, KEY_ESC, key_esc
   jmp developer_zone
  ENDIF key_esc
 jmp .halt

;BleskOS VGA edition

main_screen:
 HIDE_CURSOR

 DRAW_BACKGROUND 0x20

 DRAW_LINE 0, 0, 80, 0x40
 DRAW_LINE 24, 0, 80, 0x40
 DRAW_COLUMN 0, 0, 25, 0x40
 DRAW_COLUMN 0, 79, 25, 0x40

 PRINT 2, 2, str_up, 'Welcome in BleskOS'
 PRINT 4, 2, str_you_can, 'You can open programs with keyboard and go back with esc:'
 PRINT 6, 2, str_te, '[a] Text editor'
 PRINT 8, 2, str_ge, '[b] Graphic editor'
 PRINT 10, 2, str_se, '[c] Sound editor'
 PRINT 12, 2, str_clc, '[d] Calculator'
 PRINT 20, 2, str_dz, '[F1] Developer zone'
 PRINT 22, 2, str_down, 'You can shutdown computer by pressing power button'

 .halt:
  WAIT_FOR_KEYBOARD

  IF ah, KEY_A, key_a
   jmp text_editor
  ENDIF key_a

  IF ah, KEY_B, key_b
   jmp graphic_editor
  ENDIF key_b

  IF ah, KEY_C, key_c
   jmp sound_editor
  ENDIF key_c

  IF ah, KEY_D, key_d
   jmp calculator
  ENDIF key_d

  IF ah, KEY_F1, key_f1
   jmp developer_zone
  ENDIF key_f1
 jmp .halt

developer_zone:
 DRAW_BACKGROUND 0x60

 DRAW_LINE 0, 0, 80, 0x40
 DRAW_LINE 24, 0, 80, 0x40
 DRAW_COLUMN 0, 0, 25, 0x40
 DRAW_COLUMN 0, 79, 25, 0x40

 PRINT 2, 2, str_up, 'Developer zone'
 PRINT 4, 2, str_you_can, 'These are programs for BleskOS developers'
 PRINT 6, 2, str_vga, '[a] VGA'
 PRINT 8, 2, str_pcspk, '[b] PC speaker'
 PRINT 10, 2, str_drives, '[c] Drives'

 .halt:
  WAIT_FOR_KEYBOARD

  IF ah, KEY_ESC, key_esc
   jmp main_screen
  ENDIF key_esc

  IF al, KEY_A, key_a
   jmp dz_vga
  ENDIF key_a

  IF al, KEY_B, key_b
   jmp dz_pc_speaker
  ENDIF key_b

  IF al, KEY_C, key_c
   jmp dz_drives
  ENDIF key_c
 jmp .halt

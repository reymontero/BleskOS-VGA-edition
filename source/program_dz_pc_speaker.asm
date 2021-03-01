;BleskOS

dz_pc_speaker:
 DRAW_BACKGROUND 0x60

 PRINT 1, 1, str_1, '[a] Play freq 2000'
 PRINT 3, 1, str_2, '[b] Stop PC speaker'

 .halt:
  WAIT_FOR_KEYBOARD

  IF ah, KEY_ESC, key_esc
   jmp developer_zone
  ENDIF key_esc

  IF al, 'a', key_a
   mov ax, 2000
   call play_freq
   jmp .halt
  ENDIF key_a

  IF al, 'b', key_b
   call stop_freq
  ENDIF key_b
 jmp .halt

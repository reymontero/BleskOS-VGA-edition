;BleskOS VGA edition

%macro PLAY_FREQ 1
 %if %1!=ax
 mov ax, %1
 %endif
 call play_freq
%endmacro

play_freq:
 mov bx, ax

 OUTB 0x43, 0xB6
 mov al, bl
 OUTB 0x42, al
 mov al, bh
 OUTB 0x42, al

 INB 0x61
 or al, 0x3
 OUTB 0x61, al

 ret

stop_freq:
 INB 0x61
 and al, 0xFC
 OUTB 0x61, al

 ret

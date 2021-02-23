;BleskOS VGA edition

mouse_data db 0, 0, 0
mouse_data_pointer dw 0

init_mouse:
 ;enable interrupts
 OUTB 0x64, 0x20
 INB 0x60
 or al, 0x3
 push ax
 OUTB 0x64, 0x60
 pop ax
 OUTB 0x60, al

 ;enable mouse controller
 OUTB 0x64, 0xA8

 ;install handler
 mov ax, 0
 mov gs, ax
 mov word [gs:0x01D0], mouse_irq
 mov word [gs:0x01D2], 0x1000

 ;enable sending packets
 OUTB 0x64, 0xD4
 OUTB 0x60, 0xF4
 mov word [mouse_data_pointer], 0

 ret

mouse_irq:
 pusha
 INB 0x60

 mov bx, mouse_data
 add bx, word [mouse_data_pointer]
 mov byte [bx], al

 inc word [mouse_data_pointer]
 cmp word [mouse_data_pointer], 3
 jl .if
  mov word [mouse_data_pointer], 0
 .if:

 OUTB 0xA0, 0x20
 OUTB 0x20, 0x20
 popa
 iret

;BleskOS VGA edition

%macro INB 1
 %if %1!=dx
 mov dx, %1
 %endif
 in al, dx
%endmacro

%macro OUTB 2
 %if %1!=dx
 mov dx, %1
 %endif
 %if %2!=al
 mov al, %2
 %endif
 out dx, al
%endmacro

%macro IF 3
 cmp %1, %2
 jne .if_%3
%endmacro

%macro IF_NE 3
 cmp %1, %2
 je .if_%3
%endmacro

%macro ENDIF 1
 .if_%1:
%endmacro

%macro CYCLE 2
 mov cx, %1
 .cycle_%2:
 push cx
%endmacro

%macro ENDCYCLE 1
 pop cx
 loop .cycle_%1
%endmacro

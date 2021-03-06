puts:
  ;------------------------------------------------------------
  ; construct stackframe
  ;------------------------------------------------------------

  push bp
  mov bp, sp

  ;-----------------------------------------------------------
  ; save register 
  ;-----------------------------------------------------------
  push ax
  push bx
  push si

  ;-----------------------------------------------------------
  ; get args
  ;-----------------------------------------------------------
  mov si, [bp + 4]

  ;-----------------------------------------------------------
  ; begining of process
  ;-----------------------------------------------------------
  mov ah, 0x0E              ; teltype char 
  mov bx, 0x0000            ; set o page number char color
  cld                       ; DF = 0 add address
                            ; do
.10L:                       ; {
  lodsb                     ; AL = *AL++;
                            ;
  cmp al, 0                 ; if (0 == AL)
  je   .10E                 ;   break;
                            ; 
  int 0x10                  ; Int10(0x0E, AL); 
  jmp .10L                  ; while(1);
.10E:


  ;-----------------------------------------------------------
  ; return of register
  ;-----------------------------------------------------------
  pop si
  pop bx
  pop ax

  ;-----------------------------------------------------------
  ; deconstruct stackframe
  ;-----------------------------------------------------------
  mov sp, bp
  pop bp

  ret

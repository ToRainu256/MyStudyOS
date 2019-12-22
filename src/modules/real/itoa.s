;**************************************************************
; void itoa(num, buff, size, radix, flag)
;   return void
;   num    original
;   buff   disnation buffer
;   size   buff size
;   radix  2, 8, 10, 16
;   flags  def bit flag 
;          -------------------------
;          B2: filling space 0
;          B1: set sign
;          B0: vaule hadle signed
;**************************************************************
itoa:

  ;-----------------------------------------------------------
  ; construct stackframe
  ;-----------------------------------------------------------
                                ; BP+ 12| flag
                                ; BP+ 10| radix
                                ; BP+  8| buffer size
                                ; BP+  6| buffer address
                                ; BP+  4| value
                                ; BP+  2| IP(address of return value)
       push bp, sp              ; BP+  0| BP(original value)
       mov  bp, sp

  ;-----------------------------------------------------------
  ; save register
  ;-----------------------------------------------------------
      push ax                   
      push bx                   
      push cx                   
      push dx                   ;
      push si
      push di

  ;-----------------------------------------------------------
  ; get arg
  ;-----------------------------------------------------------
      mov ax, [bp + 4]          ; val = value; 
      mov si, [bp + 6]          ; dst = buffer address
      mov cx, [bp + 8]          ; size = remaining buffe size
      
      mov di, si                ; end of buffer
      add di, cx                ; dst = &dst[size - 1];
      dec di                    ; 

      mov bx, word [bp + 12]    ; flags = option;

  ;-----------------------------------------------------------
  ; check signed or not
  ;-----------------------------------------------------------
      test bx, 0b0001           ; if (flags & 0x01)
.10Q: je .10E                   ; {
      cmp ax, 0                 ;   if (val < 0)
.12Q: jge .12E                  ;   {
      or bx, 0b0010             ;    flags |= 2;
.12E:                           ;   }
.10E:                           ; }

  ;-----------------------------------------------------------
  ; check sign
  ;-----------------------------------------------------------
      test bx, 0b0010           ; if (flags & 0x02)// check sign
.20Q: je .20E                   ; {
      cmp ax, 0                 ;   if (val < 0)
.22Q: jge .22F                  ;   {
      neg ax                    ;     val *= -1; //reverse sign
      mov [si], byte '-'        ;     *dst = '-';// ouput sign
      jmp .22E                  ;   }
.22F:                           ;   else
                                ;   {
      mov [si], byte '+'        ;     *dst = '+';//output sign
.22E:                           ;   }
      dec cx                    ;   size--;      //decriment buff size
.20E:                           ; }

  ;-----------------------------------------------------------
  ; convert to ascii
  ;-----------------------------------------------------------
      mov bx, [bp + 10]             ; BX = radix;
.30L:                               ; do
                                    ; {
      mov dx, 0                     ; 
      div bx                        ; DX = DX:AX % radix;
                                    ; AX = DX:AX / radix;
      mov si, dx                    ; // refer ascii table
      mov dl, byte [.ascii + si]    ; DL = ASCII[DX];
                                    ;
      mov [dl], dl                  ; *dst = DL;
      dec di                        ; dst--;
                                    ;
      cmp ax, 0                     ;
      loopnz .30L                   ; } while (AX);
.30E:

  ;-----------------------------------------------------------
  ; filing space
  ;-----------------------------------------------------------
      cmp cx, 0                     ; if (size)
.40Q: je .40E                       ; {
      mov al,                       ;   AL = ' '; // filing plank by ' '
      cmp [bp + 12], word 0b0100    ;   if (flags & 0x04)
.42Q  jne .42E                      ;   {
      mov al, '0'                   ;     AL = '0'; // '0'
.42E:                               ;   }
      std                           ;   // DF = 1(negative direction)
      rep stosb                     ;   while (--CX) *DI-- = ' ';
.40E:                               ; ]

  ;-----------------------------------------------------------
  ; return of register
  ;-----------------------------------------------------------
      pop ax
      pop bx
      pop cx
      pop dx
      pop si
      pop di

  ;-----------------------------------------------------------
  ; deconstruct stackframe
  ;-----------------------------------------------------------
      mov sp, bp
      pop bp

      ret

  ;-----------------------------------------------------------
  ; ASCII TABLE
  ;-----------------------------------------------------------
.ascii db "0123456789ABCDEF"        ; ascii table

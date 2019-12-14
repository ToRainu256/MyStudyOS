memcmp:
      ;--------------------------------------------------------
      ; memcmp(src0, src1, size);
      ;      return  if equal then 0 else otherwise 
      ;      src0 addres 0
      ;      src1 addres 1
      ;      size number of byte
      ;--------------------------------------------------------

  
      ;--------------------------------------------------------
      ; Construction stack frame
      ;--------------------------------------------------------

                      ; BP + 8 | number of bite
                      ; BP + 6 | source  addres
                      ; BP + 4 | destination addres
                      ;---------------------------
                      ; BP + 2 | IP
      push bp         ; BP + 0 | BP
      mov bp, sp

      ;--------------------------------------------------------
      ; save Register
      ;--------------------------------------------------------

      push bx
      push cx
      push dx
      push si
      push di

      ;--------------------------------------------------------
      ; get argment
      ;--------------------------------------------------------

      cld                 ; clear DF (+ direction)
      mov si, [bp + 4]    ; addres 0
      mov di, [bp + 6]    ; addres 1
      mov cx, [bp + 8]    ; number of bite

      ;--------------------------------------------------------
      ; compare each byte
      ;--------------------------------------------------------

      repe cmpsb
      jnz .10F
      mov ax, 0
      jmp .10E
.10F:
  
     mov ax, -1
.10E:

      ;--------------------------------------------------------
      ; return Register
      ;--------------------------------------------------------
      pop di
      pop si
      pop dx
      pop cx
      pop bx 

      ;--------------------------------------------------------
      ; Deconstruction stack frame
      ;--------------------------------------------------------
      mov sp, bp
      pop bp

      ret

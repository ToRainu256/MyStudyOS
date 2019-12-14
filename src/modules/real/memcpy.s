memcpy:
      ;--------------------------------------------------------
      ; void memcpy(dst, src, size);
      ;     return void;
      ;     dst destnation
      ;     src source
      ;     size number of byte
      ;--------------------------------------------------------



      ;--------------------------------------------------------
      ; Construction stack frame
      ;--------------------------------------------------------

      push bp         ; BP + 8 | number of bite
                      ; BP + 6 | source  addres
                      ; BP + 4 | destination addres
                      ;---------------------------
                      ; BP + 2 | IP
                      ; BP + 0 | BP
      mov bp, sp


      ;--------------------------------------------------------
      ; Save Register
      ;--------------------------------------------------------

      push cx
      push si
      push di

      ;--------------------------------------------------------
      ; copy for each byte
      ;--------------------------------------------------------

      cld             ; DF = 0; //+ Direction
      mov di, [bp + 4]; DI = destination 
      mov si, [bp + 6]; SI = source
      mov cx, [bp + 8]; CX = number of bite 

      rep movsvb      ; while(*DI++ = *SI++);

      ;--------------------------------------------------------
      ; return Register
      ;--------------------------------------------------------

      pop di
      pop si
      pop cx


      ;--------------------------------------------------------
      ; Deconstruction Stack frame
      ;--------------------------------------------------------
      mov sp, bp
      pop bp

      ret



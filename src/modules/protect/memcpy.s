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

      push ebp        ; EBP + 12 | number of bite
                      ; EBP + 10 | source  addres
                      ; EBP + 8  | destination addres
                      ;---------------------------
                      ; EBP + 0 | IP
                      ; EBP + 4 | BP
      mov ebp, esp


      ;--------------------------------------------------------
      ; Save Register
      ;--------------------------------------------------------

      push ecx
      push esi
      push edi

      ;--------------------------------------------------------
      ; copy for each byte
      ;--------------------------------------------------------

      cld              ; DF = 0; //+ Direction
      mov edi, [ebp + 8] ; DI = destination 
      mov esi, [ebp + 10]; SI = source
      mov ecx, [ebp + 12]; CX = number of bite 

      rep movsvb      ; while(*DI++ = *SI++);

      ;--------------------------------------------------------
      ; return Register
      ;--------------------------------------------------------

      pop edi
      pop esi
      pop ecx


      ;--------------------------------------------------------
      ; Deconstruction Stack frame
      ;--------------------------------------------------------
      mov esp, ebp
      pop ebp

      ret



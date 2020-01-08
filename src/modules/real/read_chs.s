;************************************************
; read_chs(drive, sect, dst);
;   return how many sector readed
;   drive: drive struct address
;   sect : How many sector read
;   dst  : destnation address
;************************************************

read_chs:
        ;----------------------------------------
        ; construct stack frame
        ;----------------------------------------



        push bp
        mov  bp, sp
        push 3
        push 0

        ;----------------------------------------
        ; save register
        ;----------------------------------------

        push bx
        push cx
        push dx
        push es
        push si

        ;----------------------------------------
        ; begining of process
        ;----------------------------------------

        mov si, [bp + 4]        ; SI = SRC buffer


        ;----------------------------------------
        ; Config CX register
        ;----------------------------------------

        mov ch, [si + drive.cyln + 0] ; CH = cylnder number(low byte)
        mov cl, [si + drive.cyln + 1] ; CL = clynder number(high byte)
        shl cl, 6                     ; CL <<= 6; // shift to highest 2bit
        or  cl, [si + drive.sect]      ; CL |= sector number


        ;----------------------------------------
        ; read sector
        ;----------------------------------------

        mov dh, [si + drive.head]     ; DH = head number;
        mov dl, [si + 0]              ; DL = drive number;
        mov ax, 0x0000                ; AX = 0x0000;
        mov es, ax                    ; ES = SEGMENT
        mov bx, [bp + 8]              ; BX = copy destnation;
.10L:                                 ;do
                                      ;{
        mov ah, 0x02                  ; AH = read sector;
        mov al, [bp + 6]              ; AL =  sectors;
                                      ;
        int 0x13                      ; CF = BIOS(0x13, 0x02);
        jnc .11E                      ; if(CF)
                                      ; {
        mov al, 0                     ;   AL = 0; 
        jmp .10E                      ;   break;
.11E:                                 ; }
        
        cmp al, 0                     ;   if(readed sector)
        jne .10E                      ;     break;

        mov ax, 0                     ;   ret = 0;
        dec word[bp - 2]              ; }
        jnz .10L                      ;while(--retry);
.10E:
        mov ah, 0                     ; AH = 0


        ;----------------------------------------
        ; return register 
        ;----------------------------------------

        pop si
        pop es
        pop dx
        pop cx
        pop bx

        ;----------------------------------------
        ; deconstruct stack
        ;----------------------------------------

        mov sp , bp
        pop bp

        ret

        

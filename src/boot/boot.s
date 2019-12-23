    BOOT_LOAD     equ     0x7C00 ;boot program adress

    ORG  BOOT_LOAD               ;load adress

;**********************************************
; Macro
;**********************************************
%include "../include/macro.s"

;**********************************************
; Entry Point
;**********************************************

entry:

  ;--------------------------------------------------
  ; BPB (BIOS Parameter Block)
  ;--------------------------------------------------

  jmp ipl               ; jump to ipl
  times 90 - ($ - $$) db 0x90

  ;--------------------------------------------------
  ; IPL(Initial Program Loader)
  ;--------------------------------------------------

ipl:
    cli

    mov ax, 0x0000       ; AX = 0x0000
    mov ds, ax           ; DS = 0x0000
    mov es, ax           ; ES = 0x0000
    mov ss, ax           ; SS = 0x0000
    mov sp, BOOT_LOAD    ; SP = 0x7C00

    sti                  ; alow 

    mov [BOOT.DRIVE], dl ; save bootdrive

  ;--------------------------------------------------
  ; output chars
  ;--------------------------------------------------
    cdecl puts, .s0 

  ;--------------------------------------------------
  ; output value
  ;--------------------------------------------------
  ;  cdecl itoa, 8086, .s1, 8, 10, 0b0001  ; "     8086"
  ;  cdecl puts, .s1 

  ;  cdecl itoa, 8086, .s1, 8, 10, 0b0011  ; "+    8086"
  ;  cdecl puts, .s1

  ;  cdecl itoa, -8086, .s1, 8, 10, 0b0001 ; "-    8086"
  ;  cdecl puts, .s1

  ;  cdecl itoa, -1,    .s1, 8, 10, 0b0001 ; "-       1"
  ;  cdecl puts, .s1

  ;--------------------------------------------------
  ; read next 512 byte
  ;--------------------------------------------------
      mov ah, 0x02                            ; AH = read op
      mov al, 1                               ; al = number of read sector
      mov cx, 0x0002                          ; CX = cylinder/sector
      mov dh, 0x00                            ; DH = head position
      mov dl, [BOOT.DRIVE]                    ; DL = drive numver
      mov bx, 0x7C00 + 512                    ; BX = offset
      int 0x13                                ; if (CF = BIOS(0x13, 0x02))
.10Q: jnc .10E                                ; {
.10T: cdecl puts, .e0                         ;   puts(.e0);
      call reboot                             ;   reboot();
.10E:                                         ; }

  ;--------------------------------------------------
  ; boot processing goes NEXT STAGE!!!!
  ;--------------------------------------------------
      jmp stage_2                                 ; 

  ;--------------------------------------------------
  ; End of process
  ;--------------------------------------------------

  jmp $                 ;while(true)

  ;--------------------------------------------------
  ; Data
  ;--------------------------------------------------
.s0 db "Booting...", 0x0A, 0x0D, 0 
.e0 db "Error:sector read", 0

ALIGN 2, db 0
BOOT:                   ; infomation about boot drive
.DRIVE: dw 0            ; number of drive


;**********************************************
; modules
;**********************************************
%include "../modules/real/puts.s"
%include "../modules/real/itoa.s"
%include "../modules/real/reboot.s"
  
;**********************************************
; Boot Flag(End of Head 512 bytes)
;**********************************************
    times 510 - ($ - $$) db 0x00
    db 0x55, 0xAA

;**********************************************
; boot process 2nd stage
;**********************************************
stage_2:

  ;--------------------------------------------------
  ; output literal
  ;--------------------------------------------------
    cdecl puts, .s0


  ;--------------------------------------------------
  ; end of prossecing
  ;--------------------------------------------------
    jmp $

  ;--------------------------------------------------
  ; data
  ;--------------------------------------------------
.s0 db "2nd stage...", 0x0A, 0x0D, 0

;**********************************************
; Padding
;**********************************************
    times (1024 * 8) - ($ - $$) db 0 ;8Kbyte

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
  ; End of process
  ;--------------------------------------------------

  jmp $                 ;while(true)

  ;--------------------------------------------------
  ; Data
  ;--------------------------------------------------
.s0 db "Booting...", 0x0A, 0x0D, 0

ALIGN 2, db 0
BOOT:                   ; infomation about boot drive
.DRIVE: dw 0            ; number of drive


;**********************************************
; modules
;**********************************************
%include "../modules/real/puts.s"
  
;**********************************************
; Boot Flag(End of Head 512 bytes)
;**********************************************
  times 510 - ($ - $$) db 0x00
  db 0x55, 0xAA



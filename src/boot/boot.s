
;**********************************************
; include 
;**********************************************
%include "../include/cdecl.s"
%include "../include/construct.s"
%include "../include/define.s"
      
ORG BOOT_LOAD           ; aply road address to asm            ;

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
    cli                  ; deny interupt

    mov ax, 0x0000       ; AX = 0x0000
    mov ds, ax           ; DS = 0x0000
    mov es, ax           ; ES = 0x0000
    mov ss, ax           ; SS = 0x0000
    mov sp, BOOT_LOAD    ; SP = 0x7C00

    sti                  ; alow interupt

    mov [BOOT + drive.no], dl ; save bootdrive

  ;--------------------------------------------------
  ; output chars
  ;--------------------------------------------------
    cdecl puts, .s0 

  ;--------------------------------------------------
  ; read all of sector
  ;--------------------------------------------------
    
      mov bx, BOOT_SECT -1                      ; BX = How many Boot sector left
      mov cx, BOOT_LOAD + SECT_SIZE             ; CX = nexr boot address

      cdecl read_chs, BOOT, bx, cx              ; AX = read_chs(BOOT, BX, CX)

       cmp ax, bx                                ; if(AX != How many Boot sector left)
.10Q:  jz .10E                                   ; {
.10T:  cdecl puts, .e0                            ;   puts(.e0);
       call reboot                               ;   reboot();
.10E:                                            ; }
  

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
;**************************************************
; infomation about boot drive
;**************************************************

ALIGN 2, db 0
BOOT:                   ; 
    istruc drive
        at drive.no,    dw 0 ; drive number
        at drive.cyln,  dw 0 ; C: cylinder
        at drive.head,  dw 0 ; H: head
        at drive.sect,  dw 2 ; S: Sector
    iend


;**********************************************
; modules
;**********************************************
%include "../modules/real/puts.s"
%include "../modules/real/itoa.s"
%include "../modules/real/reboot.s"
%include "../modules/real/read_chs.s"
  
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
    times BOOT_SIZE - ($ - $$) db 0   

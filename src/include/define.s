  BOOT_LOAD equ 0x7C00                  ; read postion for boot program

  BOOT_SIZE equ (1024 * 8)              ; boot code size
  SECT_SIZE equ (512)                   ; sector size
  BOOT_SECT equ (BOOT_SIZE / SECT_SIZE) ; How sector will read

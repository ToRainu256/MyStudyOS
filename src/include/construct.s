;******************************************************
; struct drive
;******************************************************

struc drive
    .no   resw 1 ;drive number
    .cyln resw 1 ; cylinder
    .head resw 1 ; head
    .sect resw 1 ; sector
endstruc


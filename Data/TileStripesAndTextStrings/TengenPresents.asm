;the flashing string that shows up when the game is booted up/reset
.macro PutTengenPresentsStringData
TengenPresentsString_A085:
.word $20C8
.byte "TENGEN PRESENTS"
.byte $FF
.byte $00
.endmacro
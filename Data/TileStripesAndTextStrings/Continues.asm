;the compressed "CONTINUES" string after game over and returning to options screen
.macro PutContinuesStringData
ContinuesString_9FCB:
.word $2298
.byte $E0,$E1,$E2,$E3
.byte $FF
.byte $00
.endmacro
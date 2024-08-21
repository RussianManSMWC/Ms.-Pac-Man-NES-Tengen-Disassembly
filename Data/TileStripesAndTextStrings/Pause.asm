.macro PutPauseStringData
PauseString_9DB2:
.word $22AE
.byte "PAUSE"
.byte $FF
.byte $00
.endmacro

;remove the pause string
.macro PutPauseEmptyStringData
EmptyPauseString_9EB9:
.word $22AE
.byte "     "
.byte $FF
.byte $00
.endmacro
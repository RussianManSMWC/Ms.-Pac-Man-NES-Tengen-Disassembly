;unused LEVEL XX (where XX is an actual number) string
.macro PutUnusedLevelXXStringData
LevelXXString_9CB4:
.word $232C
.byte "LEVEL   "
.byte $FF
.byte $00
.endmacro

;this string would've been used to clear the unused "LEVEL   " string
.macro PutUnusedLevelXXEmptyStringData
EmptyLevelXXString_9CE9:
.word $232C
.byte "        "
.byte $FF
.byte $00
.endmacro
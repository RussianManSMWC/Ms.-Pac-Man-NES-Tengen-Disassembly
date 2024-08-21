;Special game over text that doesn't use the standard font (differently colored letters)
.macro PutGameOverStringData
GameOverString_9CDC:
.word $232C
.byte $D8,$D9,$DA,$DB," ",$DC,$DD,$DB,$DE
.byte $FF
.byte $00
.endmacro


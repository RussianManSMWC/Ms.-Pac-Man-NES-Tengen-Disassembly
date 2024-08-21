;strings for the credits screen
.macro PutCreditsStringData
CreditsStrings_9FD3:
.word $20C3
.byte "CREDITS FOR MS PAC-MAN"
.byte $FF

.word $2144
.byte "GAME PROGRAMMER:"
.byte $FF

;the man!
.word $218A
.byte "FRANZ LANZINGER"
.byte $FF

;other people
.word $21E4
.byte "SPECIAL THANKS:"
.byte $FF

.word $222A
.byte "JEFF YONAN"
.byte $FF

.word $224A
.byte "DAVE O'RIVA"
.byte $FF

.word $22C5
.byte "MS PAC-MAN TM NAMCO LTD"
.byte $FF

.word $22E5
.byte "  ",CopyrightSymbol-FontTileOffset,"1990 TENGEN INC"
.byte $FF

.word $2305
.byte " ALL RIGHTS RESERVED"
.byte $FF
.byte $00
.endmacro
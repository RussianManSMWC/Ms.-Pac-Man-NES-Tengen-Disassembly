.macro PutTitleScreenStripeData
TitleScreenTilemap_9BE8:
.word $20C8
.byte "TENGEN PRESENTS"
.byte $FF

;top of MS. part of the title screen graphic
.word $2105
.byte $C0,$C1,$20,$C3,$C2
.byte $FF

;bottom of MS. part
.word $2125
.byte $C2,$AF,$20,$C2,$C4,$20,$CE
.byte $FF

;top of Pac-Man part of the title screen
.word $2165
.byte $C2,$C5,$20,$C6,$C7,$20,$CA,$CB
.byte $20,$E8,$20,$C0,$C1,$20,$C6,$C7
.byte $20,$C0,$C2
.byte $FF

;bottom of Pac-Man part
.word $2185
.byte $AF,$20,$20,$C8,$C9,$20,$CC,$CD
.byte $20,$E9,$20,$C2,$AF,$20,$C8,$C9
.byte $20,$C2,$AF
.byte $FF

;press start string that will blink
.word $220A
.byte "PRESS START"
.byte $FF

;copyright stuff
.word $22C5
.byte "MS PAC-MAN TM NAMCO LTD"
.byte $FF

.word $22E7
.byte CopyrightSymbol-FontTileOffset,"1990 TENGEN INC"      ;why is copyright (©) symbol 2 bytes instead of one????
.byte $FF

.word $2306
.byte "ALL RIGHTS RESERVED"
.byte $FF
.byte $00
.endmacro
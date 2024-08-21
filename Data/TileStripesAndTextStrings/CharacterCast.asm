;attract mode

;note: the square brakets here are actually quotation characters, the left and right ones
.macro PutGameNameStringData
QuoteMsPacManUnquoteString_9F55:
.word $20AA
.byte "[MS PAC-MAN]"
.byte $FF
.byte $00
.endmacro

.macro PutStarringMsPacManStringData
StarringMsPacManStrings_9F65:
.word $2149
.byte "STARRING"
.byte $FF

.word $218B
.byte "MS PAC-MAN"
.byte $FF
.byte $00
.endmacro

.macro PutWithStringData
WithString_9F7E:
.word $2149
.byte "WITH"
.byte $FF
.byte $00
.endmacro

.macro PutBlinkyStringData
BlinkyString_9F86:
.word $218D
.byte "BLINKY"
.byte $FF
.byte $00
.endmacro

.macro PutInkyStringData
InkyString_9F90:
.word $218D
.byte "INKY  "
.byte $FF
.byte $00
.endmacro

.macro PutPinkyStringData
PinkyString_9F9A:
.word $218D
.byte "PINKY "
.byte $FF
.byte $00
.endmacro

.macro PutSueStringData
SueString_9FA4:
.word $218D
.byte "SUE   "
.byte $FF
.byte $00
.endmacro

;blank the WITH string
.macro PutWithEmptyStringData
EmptyWithString_9FAE:
.word $2149
.byte "    "
.byte $FF
.byte $00
.endmacro

;blank a ghost or pac-man's name (small oversight - PA part of PAC-MAN remains for a brief moment before being replaced by starring ms. pac-man text because this empty string's position is slightly off and it's short by 1 space)
.macro PutCharacterNameEmptyStringData
EmptyCharacterName_9FB6:
.word $218D
.byte "      "
.byte $FF
.byte $00
.endmacro

.macro PutPacManStringData
PacManString_9FC0:
.word $218B
.byte "PAC-MAN"
.byte $FF
.byte $00
.endmacro
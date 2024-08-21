;contains all strings that can be displayed at the top HUD

;displayed at the top of the maze where score is
.macro PutHighScoreStringData
HighScoreString_9C8A:
.word $20AB
.byte "HIGH SCORE"
.byte $FF
.byte $00
.endmacro

;for score, player 1
.macro Put1UPStringData
OneUPString_9CCE:
.word $20A4
.byte "1UP"
.byte $FF
.byte $00
.endmacro

;blink 1UP string by clearing it and drawing again
.macro PutEmpty1UPStringData
Empty1UPString_9CD5:
.word $20A4
.byte "   "
.byte $FF
.byte $00
.endmacro

.macro Put2UPStringData
TwoUpString_9E69:
.word $20B8
.byte "2UP"
.byte $FF
.byte $00
.endmacro

.macro PutEmpty2UPStringData
Empty2UpString_9E70:
.word $20B8
.byte "   "
.byte $FF
.byte $00
.endmacro

;replaces high score in 2P co-op mode
.macro PutTotalStringData
TotalString_9E77:
.word $20AD
.byte "TOTAL"
.byte $FF
.byte $00
.endmacro

;2P competitive strings
.macro PutLeaderStringData
LeaderString_9E8B:
.word $20AD
.byte "LEADER"
.byte $FF
.byte $00
.endmacro

.macro PutPlayer1LeaderStringData
Player1String_9E95:
.word $20CC
.byte "PLAYER 1"
.byte $FF
.byte $00
.endmacro

.macro PutPlayer2LeaderStringData
Player2String_9EA1:
.word $20CC
.byte "PLAYER 2"
.byte $FF
.byte $00
.endmacro

.macro PutTiedStringData
TiedString_9EAD:
.word $20CC
.byte "  TIED  "
.byte $FF
.byte $00
.endmacro
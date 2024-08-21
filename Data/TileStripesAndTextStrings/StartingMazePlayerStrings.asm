;note: if you're looking for PLAYER ONE/PLAYER TWO strings used in the hud for 2P modes, look elsewhere

;player one string displayed in 1 player and 2 player alternating mode
.macro PutPlayerOneStringData
PlayerOneString_9C98:
.word $226B
.byte "PLAYER ONE"
.byte $FF
.byte $00
.endmacro

;player two string displayed in 2 player alternating mode
.macro PutPlayerTwoStringData
PlayerTwoString_9CA6:
.word $226B
.byte "PLAYER TWO"
.byte $FF
.byte $00
.endmacro

;used to clear the PLAYER ONE/PLAYER TWO string after a bit
.macro PutEmptyPlayerStringData
EmptyPlayerString_9CC0:
.word $226B
.byte "          "
.byte $FF
.byte $00
.endmacro

;for multiplayer in 2 player competitive/cooperative
.macro PutPlayersStringData
PlayersString_9E5B:
.word $226B
.byte " PLAYERS  "
.byte $FF
.byte $00
.endmacro

;an unused PLAYERS string, seems to be an early version of the used one?
;the difference is that it lacks spaces from both sides (doesn't match the width of PLAYER ONE/PLAYER TWO), but is displayed in the same position as the final.
.macro PutUnusedPlayersStringData
UnusedPlayersString_9E80:
.word $226C
.byte "PLAYERS"
.byte $FF
.byte $00
.endmacro
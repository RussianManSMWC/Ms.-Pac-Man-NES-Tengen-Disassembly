.macro PutAct1NameStringData
ActNameTheyMeet_9F00:
.word $212E
.byte "THEY MEET"
.byte $FF
.byte $00
.endmacro

.macro PutAct2NameStringData
ActNameTheChase_9F0D:
.word $212E
.byte "THE CHASE"
.byte $FF
.byte $00
.endmacro

.macro PutAct3NameStringData
ActNameJunior_9F1A:
.word $212E
.byte "JUNIOR"
.byte $FF
.byte $00
.endmacro

.macro PutAct4NameStringData
ActNameTheEnd_9F24:
.word $212E
.byte "THE END"
.byte $FF
.byte $00
.endmacro

;blank out the act name
.macro PutActNameEmptyStringData
EmptyActName_9F2F:
.word $212E
.byte "         "
.byte $FF
.byte $00
.endmacro

;used to remove clapper GFX and launch the act cutscene
.macro PutClapperRemovalStripeData
RemoveClapper_9F3C:
.word $2148
.byte "     "
.byte $FF

.word $2168
.byte "     "
.byte $FF

.word $2188
.byte "     "
.byte $FF
.byte $00
.endmacro